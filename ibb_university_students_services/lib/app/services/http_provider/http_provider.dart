import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;
import 'package:hive/hive.dart';
import '../../components/pop_up_cards/alert_message_card.dart';
import '../notification_services/notification_services.dart';
import '../../repositories/user_repository.dart';

class HttpProvider {
  static final Dio _dio = Dio();
  static int _refreshTries = 5;

  static Future<void> init({
    String baseUrl = '',
    String accept = 'application/json',
    String contentType = 'application/json',
    Duration? connectTimeout = const Duration(seconds: 10),
    Duration? sendTimeout,
    Duration? receiveTimeout,
  }) async {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers["Accept"] = accept;
    _dio.options.headers["Content-Type"] = contentType;
    _dio.options.connectTimeout = connectTimeout;
    _dio.options.sendTimeout = sendTimeout;
    _dio.options.receiveTimeout = receiveTimeout;
    if (kIsWeb) {
      await reSetAccessToken();
    }
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        List<ConnectivityResult> connectivityResult =
            await (Connectivity().checkConnectivity());
        if (kDebugMode) {
          // print(error.requestOptions.uri);
          // print("HttpProviderError ------------------ ");
          // print("error: ${error.message}");
          // print("status code: ${error.response?.statusCode}");
          // print("res data: ${error.response?.data}");
          // print("status headers: ${error.response?.isRedirect}");
          // print("request headers: ${error.requestOptions.headers}");
          // print(connectivityResult);
        }
        if (connectivityResult.contains(ConnectivityResult.none)) {
          try {
            get_x.Get.dialog(PopUpAlertCard(
                "no internet connection \n please check your connection ",
                Icons.warning));
          } catch (e) {
            if (kDebugMode) {
              print(error);
            }
          }
          return handler.resolve(
              Response(requestOptions: error.requestOptions, statusCode: 900));
        }

        if (error.response?.statusCode == 401 &&
            error.requestOptions.path != "refresh" &&
            error.requestOptions.path != "login") {
          try {
            Response? response = await _refreshAndRetry(error.requestOptions);
            if (response != null) {
              return handler.resolve(response);
            }
          } catch (e) {
            if (kDebugMode) {
              print("________________________________________________");
              print("________________________________________________");
              // print(e?.statusCode);
              // print(response?.data);
              print(_dio.options.headers);
              print("________________________________________________");
              print("________________________________________________");
            }
          }
        } else if (((error.response?.statusCode) ?? 0) == 422) {
          return handler.resolve(error.response!);
        }

        if (error.response?.statusCode == 401 &&
            error.requestOptions.path == "refresh") {
          return handler.resolve(error.response!);
        }

        return handler.next(error);
      },
    ));
  }

  static Future<Response?> get(String url, {dynamic data}) async {
    try {
      final response = await _dio.get(url, data: data);
      return response;
    } on DioException catch (error) {
      if (error.response != null) {
        return error.response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  static Future<Response?> post(String url, {dynamic data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return response;
    } on DioException catch (error) {
      if (error.response != null) {
        return error.response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  static Future<Response?> put(String url, {dynamic data}) async {
    try {
      final response = await _dio.put(url, data: data);
      return response;
    } on DioException catch (error) {
      if (error.response != null) {
        return error.response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  static Future<Response?> delete(String url, {dynamic data}) async {
    try {
      final response = await _dio.delete(url, data: data);
      return response;
    } on DioException catch (error) {
      if (error.response != null) {
        return error.response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  static Future<Response?> uploadFileWithProgress({
    required String filePath,
    required String uploadUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      File file = File(filePath);
      int fileSize = await file.length();
      // Show initial notification with 0% progress
      NotificationHandler().showProgressNotification(
          uniqueId: file.hashCode,
          progress: 0,
          message: "Uploading ${file.path.split("/").last}");
      final response = await _dio.post(
        uploadUrl,
        data: FormData.fromMap({
          'files': [
            MultipartFile.fromStream(() => file.openRead(),fileSize ,
                filename: file.path.split("/").last)
          ],
          'assignment_id': '45'
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/octet-stream',
            'Content-Length':  fileSize,
          },
        ),
        onSendProgress: (sent, total) {
          double progress = (sent / total) * 100;
          // Show updated progress (same notification ID for progress updates)
          NotificationHandler().showProgressNotification(
              uniqueId: file.hashCode,
              progress: progress.toInt(),
              message: "Uploading ${file.path.split("/").last}");
        },
      );
      return response;
    } on DioException catch (error) {
      if (error.response != null) {
        return error.response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  static Future<Response?> _refreshAndRetry(
      RequestOptions requestOptions) async {
    try {
      _refreshTries--;
      if (_refreshTries < 0) {
        get_x.Get.offAllNamed("login");
        _refreshTries = 5;
        return null;
      }

      Box box = await Hive.openBox('Tokens');
      Response response = await _dio.post("refresh",
          data: {"refreshToken": await box.get("refreshToken") ?? ""});
      await box.close();
      if (response.statusCode == 401) {
        // re login if remember me data available
        List<String>? credentials =
            await UserRepository.fetchCachedCredentials();
        if (credentials != null) {
          await UserRepository.userLogin(credentials[0], credentials[1]);
        }
      } else if (response.statusCode == 200) {
        addAccessTokenHeader(
          response.data["accessToken"],
        );
        return await _dio.request(
          requestOptions.path,
          queryParameters: requestOptions.queryParameters,
          data: requestOptions.data,
          options: Options(
            method: requestOptions.method,
          ),
        );
      }
    } on DioException catch (error) {
      return error.response;
    }
    return null;
  }

  static void addAccessTokenHeader(String? accessToken) {
    _dio.options.headers["Authorization"] = "Bearer $accessToken";
    if (kIsWeb) {
      storeAccessToken(accessToken ?? "");
    }
  }

  static void storeRefreshToken(String refreshToken) async {
    Box box = await Hive.openBox('Tokens');
    await box.put("refreshToken", refreshToken);
    await box.close();
  }

  static void storeAccessToken(String accessToken) async {
    Box box = await Hive.openBox('Tokens');
    await box.put("AccessToken", accessToken);
    await box.close();
  }

  static Future<void> reSetAccessToken() async {
    Box box = await Hive.openBox('Tokens');
    _dio.options.headers["Authorization"] = "Bearer ${box.get("AccessToken")}";
    await box.close();
  }

  static void removeAccessTokenHeader() {
    _dio.options.headers["Authorization"] = null;
  }
}

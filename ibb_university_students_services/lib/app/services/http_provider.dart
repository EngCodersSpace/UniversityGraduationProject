import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/utils/local_lisenter.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../repositories/user_repository.dart';

class HttpProvider {
  static final Dio _dio = Dio();
  static int _refreshTries = 5;
  static Map<int, CancelToken> cancelTokens = {};
  static int onProcessUploads = 0;

  static int onProcessDownloads = 0;

  static Future<void> init({
    String baseUrl = '',
    String accept = 'application/json',
    String contentType = 'application/json',
    Duration? connectTimeout = const Duration(seconds: 10),
    Duration? sendTimeout = const Duration(seconds: 30),
    Duration? receiveTimeout = const Duration(seconds: 30),
  }) async {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers["Accept"] = accept;
    _dio.options.headers["Content-Type"] = contentType;
    _dio.options.connectTimeout = connectTimeout;
    _dio.options.sendTimeout = sendTimeout;
    _dio.options.receiveTimeout = receiveTimeout;
    _dio.options.headers["Accept-Language"] =
        LocaleListener.currentLocal.value?.languageCode ?? "en";
    if (kIsWeb) {
      await reSetAccessToken();
    }
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        List<ConnectivityResult> connectivityResult =
            await (Connectivity().checkConnectivity());
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

        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          return handler.resolve(Response(
              requestOptions: error.requestOptions,
              statusCode: 901,
              data: error.response?.data));
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

  static Future<Response?> get(String url,
      {dynamic data, Options? options}) async {
    try {
      final response = await _dio.get(url, data: data, options: options);
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

  static Future<Response?> post(String url,
      {dynamic data, void Function(int, int)? onSendProgress}) async {
    try {
      final response =
          await _dio.post(url, data: data, onSendProgress: onSendProgress);
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

  static Future<Response?> put(String url,
      {dynamic data, void Function(int, int)? onSendProgress}) async {
    try {
      final response =
          await _dio.put(url, data: data, onSendProgress: onSendProgress);
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

  static Future<Response?> uploadFile({
    required File file,
    required String uploadUrl,
    required void Function(int, int)? onSendProgress,
    Map<String, dynamic> data = const {},
    int? fileSize,
  }) async {
    try {
      fileSize ??= await file.length();
      cancelTokens[file.path.hashCode] = CancelToken();
      Map<String, dynamic> dataMap = {
        'file': [
          MultipartFile.fromStream(() => file.openRead(), fileSize,
              filename: file.path.split("/").last)
        ],
      };
      dataMap.addAll(data);
      onProcessUploads++;
      showSnakeBar(
          title: "$onProcessUploads Files Uploading ",
          message: "for details look on notifications",
          overWrite: true);

      final response = await _dio.post(
        uploadUrl,
        cancelToken: cancelTokens[file.path.hashCode],
        data: FormData.fromMap(dataMap),
        options: Options(
            headers: {
              'Content-Type': 'application/octet-stream',
              'Content-Length': fileSize.toString(),
            },
            // receiveTimeout: Duration(),
            sendTimeout: null),
        onSendProgress: onSendProgress,
      );
      HttpProvider.onProcessUploads--;
      return response;
    } on DioException catch (error) {
      HttpProvider.onProcessUploads--;
      if (error.response != null) {
        return error.response;
      }
    } catch (e) {
      HttpProvider.onProcessUploads--;
      rethrow;
    }
    return null;
  }

  static Future<Response?> downloadFile({
    required String savePath,
    required String downloadUrl,
    required void Function(int, int)? onReceiveProgress,
    int? fileSize,
  }) async {
    try {
      cancelTokens[savePath.hashCode] = CancelToken();
      final response = await _dio.download(
        downloadUrl,
        savePath,
        // cancelToken: cancelTokens[file.path.hashCode],
        onReceiveProgress: onReceiveProgress,
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
        Box box = await Hive.openBox('rememberMe');
        box.clear();
        box.close();
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
        _refreshTries = 5;
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

  static void updateLangHeader() {
    _dio.options.headers["Accept-Language"] =
        LocaleListener.currentLocal.value?.languageCode ?? "en";
  }

  static String parseUrl(String endPoint) {
    return _dio.options.baseUrl + endPoint;
  }

  static Widget httpImage({
    required String imageUrl,
    String? secImageUrl,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, dynamic)? errorWidget,
    Widget? imageError,
    BoxFit fit = BoxFit.cover,
  }) {
    if (imageUrl.startsWith('/') ||
        imageUrl.contains(':\\') ||
        imageUrl.contains('/storage/')) {
      return Image.file(File(imageUrl),
          fit: fit,
          errorBuilder: (_, __, ___) => imageError ?? Icon(Icons.error));
    } else {
      return CachedNetworkImage(
        imageUrl: "${_dio.options.baseUrl}$imageUrl",
        httpHeaders: {
          'Authorization': _dio.options.headers["Authorization"] ?? "",
        },
        placeholder: placeholder ??
            (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => CachedNetworkImage(
          imageUrl: secImageUrl??"",
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget:
              errorWidget ?? (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        fit: fit,
      );
    }
  }
}

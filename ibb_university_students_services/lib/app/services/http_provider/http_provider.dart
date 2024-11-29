import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/pop_up_cards/alert_message_card.dart';
import '../user_services.dart';

class HttpProvider {
  static final Dio _dio = Dio();
  static  String? refreshToken;

  static init({
    String baseUrl = "",
    String accept = 'application/json',
    Duration connectTimeout = const Duration(seconds: 3),
    Duration sendTimeout = const Duration(seconds: 3),
    Duration receiveTimeout = const Duration(seconds: 3),
  }) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers["Accept"] = accept;
    _dio.options.connectTimeout = connectTimeout;
    _dio.options.sendTimeout = sendTimeout;
    _dio.options.receiveTimeout = receiveTimeout;
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        List<ConnectivityResult> connectivityResult =
            await (Connectivity().checkConnectivity());
        if (kDebugMode) {
          print(error.requestOptions.path);
          print("HttpProviderError ------------------ ");
          print("error: ${error.message}");
          print("status code: ${error.response?.statusCode}");
          print("status headers: ${error.response?.isRedirect}");
          print(connectivityResult);
        }
        if (connectivityResult.contains(ConnectivityResult.none)) {
          get_x.Get.dialog(PopUpAlertCard(
              "no internet connection \n please check your connection ",
              Icons.warning));
          return handler.resolve(
              Response(requestOptions: error.requestOptions, statusCode: 900));
        }
        if (error.response?.statusCode == 401 &&
            error.requestOptions.path != "auth/refresh") {
          try {
            Response? response = await _refreshAndRetry(error.requestOptions);
            if (response != null) {
              return handler.resolve(response);
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        } else if (((error.response?.statusCode) ?? 0) == 422) {
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
        if (kDebugMode) {
          print(error.response?.statusCode);
        }
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
        if (kDebugMode) {
          print(error.response?.statusCode);
        }
        return error.response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  static Future<Response?> patch(String url, {dynamic data}) async {
    try {
      final response = await _dio.patch(url, data: data);
      return response;
    } on DioException catch (error) {
      if (error.response != null) {
        if (kDebugMode) {
          print(error.response?.statusCode);
        }
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
        if (kDebugMode) {
          print(error.response?.statusCode);
        }
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
      addAuthTokenInterceptor(refreshToken??"");
      Response response = await _dio.post("auth/refresh");
      if (response.statusCode == 401) {
        // re login if remember me data available
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String>? credentials = prefs.getStringList("credentials");
        if (credentials != null) {
          UserServices.userLogin(credentials[0], credentials[1]);
        } else {
          get_x.Get.offAllNamed("/login");
        }
      } else if (response.statusCode == 200) {
        addAuthTokenInterceptor(
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

  static void addAuthTokenInterceptor(String authToken) {
    _dio.options.headers["Authorization"] = "Bearer $authToken";
  }

  static void removeAuthTokenInterceptor() {
    _dio.options.headers["Authorization"] = null;
  }
}

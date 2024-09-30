import 'package:dio/dio.dart';
import '../models/doctor_model.dart';
import '../models/result.dart';
import '../models/student_model.dart';
import '../models/user_model.dart';
import 'api/api_end_points.dart';
import 'api/http_provider.dart';

class UserServices {
  static User? _user;

  // static Student? _student;

  static Future<Result<bool>> userLogin(String id, String password) async {
    late Response response;
    try {
      response = await HttpProvider.post(EndPoints.login,
          data: {"id": id, "password": password});
      if (response.data["user_type"] == "student") {
        _user = Student.fromJson(response.data["user"]);
      }else{
        _user = Doctor.fromJson(response.data["user"]);
      }
      HttpProvider.addAuthTokenInterceptor(
          response.data["token"]["original"]["access_token"]);
      return Result(
          hasError: false, statusCode: response.statusCode, data: true);
    } on DioException catch (error) {
      if (error.response != null) {
        return Result(
            hasError: true,
            statusCode: error.response?.statusCode,
            message: error.response?.statusMessage,
            data: false
        );
      }
      return Result(hasError: true, statusCode: 600,message: "please check your connection", data: false);
    }
  }

  static Future<Result<User>> fetchUser({bool hardFetch = false}) async {
    if (_user != null && !hardFetch) {
      return Result(data: _user, hasError: false, message: "successful");
    }

    late Response response;
    try {
      response = await HttpProvider.post(EndPoints.getUserData);
      if(response.data["userType"] == "student"){
        _user = Student.fromJson(response.data["user"]);
        return Result(
            data: _user as Student,
            hasError: false,
            statusCode: response.statusCode,
            message: "successful");

      }else{
        _user = Doctor.fromJson(response.data["user"]);
        return Result(
            data: _user as Doctor,
            hasError: false,
            statusCode: response.statusCode,
            message: "successful");
      }


    } on DioException catch (error) {
      if (error.response != null) {
        return Result(
            hasError: true,
            statusCode: error.response?.statusCode,
            data: error.response?.data);
      }
      return Result(hasError: true, message: error.message);
    }
  }

  static void write() {}
}

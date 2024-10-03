import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/globals.dart';

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
        AppData.role = "student";
      } else {
        _user = Doctor.fromJson(response.data["user"]);
        AppData.role = "doctor";
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
            data: false);
      }
      if (id == "1" && password == "12345678") {
        // virtual response for test
        Map<String, dynamic> response = {
          'message': 'login successfully',
          'user': {
            'id': 2070093,
            'name': 'Shehab AL-Saidi',
            'email': 'shehab@gmail.com',
            'phone': '772388461',
            'level': '4th',
            'part': 'Electrical engineering',
            'department': 'Computer engineering',
            'profile_image': 'assets/images/login_background_0.jpg',
          },
          'user_type': 'student',
          'token': 'token_val'
        };

        if (response["user_type"] == "student") {
          _user = Student.fromJson(response["user"]);
        } else {
          _user = Doctor.fromJson(response["user"]);
        }
        return Result(hasError: false, statusCode: 200, data: true);
      } else if (id == "2" && password == "12345678") {
        // virtual response for test
        Map<String, dynamic> response = {
          'message': 'login successfully',
          'user': {
            'id': 2070093,
            'name': 'Shehab AL-Saidi',
            'email': 'shehab@gmail.com',
            'phone': '772388461',
            'department': 'Computer Eng',
            'academic_degree': 'Doctor',
            'administrative_position': 'Lecturer',
            'profile_image': 'assets/images/login_background_0.jpg',
          },
          'user_type': 'doctor',
          'token': 'token_val'
        };

        if (response["user_type"] == "student") {
          _user = Student.fromJson(response["user"]);
          AppData.role = "student";
        } else {
          _user = Doctor.fromJson(response["user"]);
          AppData.role = "doctor";
        }
        return Result(hasError: false, statusCode: 200, data: true);
      }

      return Result(
          hasError: true,
          statusCode: 600,
          message: "please check your connection",
          data: false);
    }
  }

  static Future<Result<User>> fetchUser({bool hardFetch = false}) async {
    if (_user != null && !hardFetch) {
      return Result(
          data: _user, statusCode: 200, hasError: false, message: "successful");
    }

    late Response response;
    try {
      response = await HttpProvider.post(EndPoints.getUserData);
      if (response.data["userType"] == "student") {
        _user = Student.fromJson(response.data["user"]);
        return Result(
            data: _user as Student,
            hasError: false,
            statusCode: response.statusCode,
            message: "successful");
      } else {
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

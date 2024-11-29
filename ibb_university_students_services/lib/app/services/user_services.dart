import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ibb_university_students_services/app/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' as get_x;
import '../models/doctor_model.dart';
import '../models/result.dart';
import '../models/student_model.dart';
import '../models/user_model.dart';
import 'http_provider/http_provider.dart';

class UserServices {
  static SharedPreferences? _prefs;
  static User? _user;

  // static Student? _student;
  static void _fakeUser(String type){
    if (type == "student") {
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
    } else if (type =="doctor") {
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
    }

  }
  static Future<Result<bool>> _userFakeLogin(String id, String password) async {
    if (id == "1" && password == "12345678") {
      _fakeUser("student");
    } else if (id == "2" && password == "12345678") {
      _fakeUser("doctor");
    }
    return Result(hasError: false, statusCode: 200, data: true);
  }

  static Future<Result<bool>> userLogin(String id, String password,
      {bool rememberMe = false}) async {
    late Response? response;
    try {
      response = await HttpProvider.post("auth/login",
          data: {"id": id, "password": password});
      if (response?.statusCode == 200) {
        if (response?.data["user_type"] == "student") {
          _user = Student.fromJson(response?.data["user"]);
          AppData.role = "student";
        } else {
          _user = Doctor.fromJson(response?.data["user"]);
          AppData.role = "doctor";
        }
        HttpProvider.addAuthTokenInterceptor(response?.data["token"]);
        if (rememberMe) {
          _prefs ??= await SharedPreferences.getInstance();
          await _prefs?.setStringList("credentials", <String>[id, password]);
          return await _userFakeLogin(id, password);
        }
        return Result(
          hasError: false,
          statusCode: response?.statusCode,
          data: true,
        );
      }
      if(rememberMe){
        return await _userFakeLogin(id, password);
      }
      return Result(
        hasError: true,
        statusCode: response?.statusCode ?? 601,
        message: response?.data["message"] ?? "error",
        data: false,
      );
    } catch (error) {
      if (kDebugMode) {
        print("____________________________________________");
        print("internalException\n");
        print(error);
      }
      return Result(
        hasError: true,
        statusCode: 601,
        message: error.toString(),
      );
    }
  }

  static Future<Result<bool>> userRegister(String name, String email,
      String password, String passwordConfirmation) async {
    late Response? response;
    try {
      response = await HttpProvider.post("auth/register", data: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation
      });
      if (response?.statusCode == 200) {
        if (response?.data["user_type"] == "student") {
          _user = Student.fromJson(response?.data["user"]);
          AppData.role = "student";
        } else {
          _user = Doctor.fromJson(response?.data["user"]);
          AppData.role = "doctor";
        }
        HttpProvider.addAuthTokenInterceptor(response?.data["token"]);
        return Result(
            hasError: false, statusCode: response?.statusCode, data: true);
      }
      return Result(
          hasError: true,
          statusCode: response?.statusCode ?? 602,
          message: response?.data["message"] ?? "error",
          data: false);
    } catch (error) {
      return Result(
        hasError: true,
        statusCode: 602,
        message: error.toString(),
      );
    }
  }

  static Future<Result?> userLogout() async {
    Response? response;
    try {
      response = await HttpProvider.post("auth/logout");
      if (response?.statusCode == 200) {
        _prefs ??= await SharedPreferences.getInstance();
        await _prefs?.remove("credentials");
        get_x.Get.offAllNamed("/login");
        return null;
      }
      return Result(
        hasError: true,
        statusCode: response?.statusCode ?? 603,
        message: response?.data["message"] ?? "some thing wrong",
        data: null,
      );
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      return Result(
          hasError: true,
          statusCode: 603,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<User>> fetchUser({bool hardFetch = false}) async {
    if (_user != null && !hardFetch) {
      return Result(
        data: _user,
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    _fakeUser("student");
    late Response? response;
    try {
      response = await HttpProvider.post("auth/me");
      if (response?.statusCode == 200) {
        if (response?.data["userType"] == "student") {
          _user = Student.fromJson(response?.data["user"]);
          return Result(
              data: _user as Student,
              hasError: false,
              statusCode: response?.statusCode,
              message: "successful");
        } else {
          _user = Doctor.fromJson(response?.data["user"]);
          return Result(
              data: _user as Doctor,
              hasError: false,
              statusCode: response?.statusCode,
              message: "successful");
        }
      }
      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode??604,
          message: response?.data["message"]??"error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: 604,
          message: error.toString(),
          data: null);
    }
  }

  static Future<List<String>?> fetchCachedCredentials() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? credentials = _prefs?.getStringList("credentials");
    return credentials;
  }
}

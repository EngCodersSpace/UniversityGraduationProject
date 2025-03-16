import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart' as get_x;
import 'package:ibb_university_students_services/app/services/hive_services/hive_services.dart';
import '../models/doctor_model/doctor.dart';
import '../models/helper_models/result.dart';
import '../models/student_model/student.dart';
import '../models/user_model/user.dart';
import '../utils/internet_connection_cheker.dart';
import '../services/http_provider/http_provider.dart';

class UserRepository {
  static Box<User>? _userBox;

  static get userRule => _userBox?.get('currentUser')?.role;

  static Future<void> openBox() async {
    _userBox = await Hive.openBox<User>('userBox');
  }

  static Future<void> clearBox() async {
    _userBox = await Hive.openBox<User>('userBox');
    await _userBox?.clear();
    Box box = await Hive.openBox('rememberMe');
    await box.clear();
    await box.close();
  }

  static Future<void> closeBox() async {
    if (_userBox?.isOpen ?? false) {
      await _userBox?.close();
    }
    // Box  = await Hive.openBox('');
  }

  static Future<Result<bool>> userLogin(String id, String password,
      {bool rememberMe = false}) async {
    late Response? response;
    try {
      response = await HttpProvider.post("login",
          data: {"user_id": id, "password": password});
      if (response?.statusCode == 200) {
        if (response?.data["user_type"] == "student") {
          Student user = Student.fromJson(response?.data["user"]);
          _userBox?.put('currentUser', user);
        } else {
          Doctor user = Doctor.fromJson(response?.data["user"]);
          _userBox?.put('currentUser', user);
        }
        HttpProvider.addAccessTokenHeader(response?.data["accessToken"]);
        HttpProvider.storeRefreshToken(response?.data["refreshToken"]);

        if (rememberMe) {
          // List<int> encryptionKey = Hive.generateSecureKey();
          Box box = await Hive.openBox(
            'rememberMe',
          );
          await box.put("credentials", <String>[id, password]);
          await box.close();
        }
        return Result(
          hasError: false,
          statusCode: response?.statusCode,
          data: true,
        );
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
      response = await HttpProvider.post("register", data: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation
      });
      if (response?.statusCode == 200) {
        if (response?.data["user_type"] == "student") {
          Student user = Student.fromJson(response?.data["user"]);
          await _userBox?.put('currentUser', user);
        } else {
          Doctor user = Doctor.fromJson(response?.data["user"]);
          await _userBox?.put('currentUser', user);
        }
        HttpProvider.addAccessTokenHeader(response?.data["token"]);
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

  static Future<void> userLogout() async {
    Response? response;
    try {
      response = await HttpProvider.post(
          "logout?user_id=${_userBox?.get('currentUser')?.id}");
      if (response?.statusCode == 200 || true) {
        Box box = await Hive.openBox('rememberMe');
        box.clear();
        box.close();
        await HiveServices.clearAllBox();
        get_x.Get.offAllNamed("/login");
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  static Future<Result<Map>> fetchDashboardDoctors({
    bool hardfetch = false,
  }) async {
    late Response? response;
    try {
      Map<int, Doctor> doctor = {};
      response = await HttpProvider.get("get-doctors-panle");
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsDoctor in response?.data['data']) {
          doctor[jsDoctor["doctor_id"]] = Doctor.fromJson(jsDoctor);
        }
      }
      return Result(
          data: {
            "Doctors": doctor,
            "totalDoctor": response?.data["pagination"]["totalDoctors"],
          },
          hasError: true,
          statusCode: response?.statusCode,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: response?.statusCode,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<Map>> fetchDashboardStudent({
    bool hardFetch = false,
  }) async {
    late Response? response;
    try {
      Map<int, Student> student = {};
      response = await HttpProvider.get("get-student-panle");
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsStudent in response?.data['data']) {
          student[jsStudent['student_id']] = Student.fromJson(jsStudent);
        }
      }
      return Result(
        data: {
          "students": student,
          "totalStudent": response?.data["pagination"]["totalstudents"],
        },
        hasError: true,
        statusCode: response?.statusCode,
        message: response?.data["message"] ?? "error",
      );
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: response?.statusCode,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<User>> fetchUser({bool hardFetch = false}) async {
    if (_userBox?.get('currentUser') != null &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
        data: _userBox?.get('currentUser'),
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("me");
      if (response?.statusCode == 200) {
        if (response?.data["user_type"] == "student") {
          Student user = Student.fromJson(response?.data["user"]);
          await _userBox?.put('currentUser', user);
          return Result(
              data: user,
              hasError: false,
              statusCode: response?.statusCode,
              message: "successful");
        } else {
          Doctor user = Doctor.fromJson(response?.data["user"]);
          await _userBox?.put('currentUser', user);
          return Result(
              data: user,
              hasError: false,
              statusCode: response?.statusCode,
              message: "successful");
        }
      }
      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode ?? 604,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: 604,
          message: error.toString(),
          data: null);
    }
  }

  static Future<bool> isCredentialsCached() async {
    Box box = await Hive.openBox('rememberMe');
    bool isCredentialsCached =
        box.containsKey("credentials") && (box.get("credentials") != null);
    await box.close();
    return isCredentialsCached;
  }

  static Future<List<String>?> fetchCachedCredentials() async {
    Box box = await Hive.openBox('rememberMe');
    List<String>? credentials = box.get("credentials");
    await box.close();
    return credentials;
  }

  static bool? isCurrentUser(int? id) {
    return _userBox?.get('currentUser')?.id == id;
  }

  static Type? currentUserType() {
    return _userBox?.get('currentUser')?.runtimeType;
  }
}

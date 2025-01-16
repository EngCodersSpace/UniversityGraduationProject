import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart' as get_x;
import '../models/doctor_model/doctor.dart';
import '../models/helper_models/result.dart';
import '../models/student_model/student.dart';
import '../models/user_model/user.dart';
import '../utils/internet_connection_cheker.dart';
import 'http_provider/http_provider.dart';

class UserServices {
  static Box<User>? _userBox;
  static get permission  => _userBox?.get('currentUser')?.permission;

  static Future<void> openBox() async {
    _userBox = await Hive.openBox<User>('userBox');
    // Box  = await Hive.openBox('');
  }

  static Future<void> closeBox() async {
    await _userBox?.close();
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
          _userBox?.put('currentUser',user);
        } else {
          Doctor user = Doctor.fromJson(response?.data["user"]);
          _userBox?.put('currentUser',user);
        }
        HttpProvider.addAccessTokenHeader(response?.data["accessToken"]);
        HttpProvider.storeRefreshToken(response?.data["refreshToken"]);

        if (rememberMe) {
          // List<int> encryptionKey = Hive.generateSecureKey();
          Box box = await Hive.openBox('rememberMe',);
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
      response = await HttpProvider.post("auth/register", data: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation
      });
      if (response?.statusCode == 200) {
        if (response?.data["user_type"] == "student") {
          Student user = Student.fromJson(response?.data["user"]);
          await _userBox?.put('currentUser',user);
        } else {
          Doctor user = Doctor.fromJson(response?.data["user"]);
          await _userBox?.put('currentUser',user);
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
      response = await HttpProvider.post("logout");
      if (response?.statusCode == 200 || true) {
        Box box = await Hive.openBox('rememberMe');
        await box.clear();
        await box.close();
        get_x.Get.offAllNamed("/login");
      }

    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  static Future<Result<User>> fetchUser({bool hardFetch = false}) async {
    if (_userBox?.get('currentUser') != null && (!hardFetch|| !(await checkInternetConnection()))) {
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
          await _userBox?.put('currentUser',user);
          return Result(
              data: user,
              hasError: false,
              statusCode: response?.statusCode,
              message: "successful");
        } else {
          Doctor user = Doctor.fromJson(response?.data["user"]);
          await _userBox?.put('currentUser',user);
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

  static Future<bool> isCredentialsCached()async{
    Box box = await Hive.openBox('rememberMe');
     bool isCredentialsCached = box.containsKey("credentials");
    await box.close();
    return isCredentialsCached;
  }

  static Future<List<String>?> fetchCachedCredentials() async {
    Box box = await Hive.openBox('rememberMe');
    List<String>? credentials = box.get("credentials");
    await box.close();
    return credentials;
  }

////////////////////////////////////////////////////////////////////////////////////////////
//////                                     fake data                                 ///////
////////////////////////////////////////////////////////////////////////////////////////////
// static void _fakeUser(String type) {
//   if (type == "student") {
//     // virtual response for test
//     Map<String, dynamic> response = {
//       'message': 'login successfully',
//       'user': {
//         'id': 2070093,
//         'name': 'Shehab AL-Saidi',
//         'email': 'shehab@gmail.com',
//         'phone': '772388461',
//         'level': '4th',
//         'part': 'Electrical engineering',
//         'department': 'Computer engineering',
//         'profile_image': 'assets/images/login_background_0.jpg',
//       },
//       'user_type': 'student',
//       'token': 'token_val'
//     };
//     if (response["user_type"] == "student") {
//       _user = Student.fromJson(response["user"]);
//     } else {
//       _user = Doctor.fromJson(response["user"]);
//     }
//   } else if (type == "doctor") {
//     // virtual response for test
//     Map<String, dynamic> response = {
//       'message': 'login successfully',
//       'user': {
//         'id': 2070093,
//         'name': 'Shehab AL-Saidi',
//         'email': 'shehab@gmail.com',
//         'phone': '772388461',
//         'department': 'Computer Eng',
//         'academic_degree': 'Doctor',
//         'administrative_position': 'Lecturer',
//         'profile_image': 'assets/images/login_background_0.jpg',
//       },
//       'user_type': 'doctor',
//       'token': 'token_val'
//     };
//     if (response["user_type"] == "student") {
//       _user = Student.fromJson(response["user"]);
//       _permission = "student";
//     } else {
//       _user = Doctor.fromJson(response["user"]);
//       _permission = "doctor";
//     }
//   }
// }
//
// static Future<Result<bool>> _userFakeLogin(String id, String password) async {
//   if (id == "1231" && password == "1111aaaa@") {
//     _fakeUser("student");
//   } else if (id == "113" && password == "1111aaaa@") {
//     _fakeUser("doctor");
//   }
//   return Result(hasError: false, statusCode: 200, data: true);
// }
}

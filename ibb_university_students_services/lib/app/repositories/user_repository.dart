import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart' as get_x;
import 'package:ibb_university_students_services/app/components/pop_up_cards/alert_message_card.dart';
import 'package:ibb_university_students_services/app/components/pop_up_cards/loading_card.dart';
import 'package:ibb_university_students_services/app/services/hive_services.dart';
import '../models/doctor_model/doctor.dart';
import '../models/helper_models/result.dart';
import '../models/student_model/student.dart';
import '../models/user_model/user.dart';
import '../services/notification_services.dart';
import '../utils/internet_connection_cheker.dart';
import '../services/http_provider.dart';

class UserRepository {
  static Box<User>? _userBox;
  static const int _createError = 623;

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
      String? fcmToken = await NotificationHandler.getDeviceToken();
      response = await HttpProvider.post("login",
          data: {"user_id": id, "password": password, "fcm_token": fcmToken});
      if (response?.statusCode == 200) {
        if (response?.data["user_type"] == "student") {
          Student user = Student.fromJson(response?.data["user"]);
          _userBox?.put('currentUser', user);
        } else {
          Doctor user = Doctor.fromJson(response?.data["user"]);
          await _userBox?.put('currentUser', user);
        }
        if (!kIsWeb) {
          await NotificationHandler.registerTopics(getUserTopics() ?? []);
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

  static Future<Result<Student>> fetchStudents({
    required int id,
    bool hardfetch = false,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.get("student/200?student_id=$id");
      if (response?.statusCode == 200) {
        Student? student = Student.fromJson(response?.data["data"]);
        return Result(
            data: student,
            hasError: false,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }
      return Result(
          data: null,
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

  static Future<Result<Map>> fetchDashboardDoctors({
    int? doctorId,
    String? acadimicDegree,
    String? postion,
    String? name,
    String? email,
    int? dateOfBirth,
    int? roleId,
    int? sectionName,
    int? phoneNumber,
    String? order,
    String? sort,
    String? search,
    int limit = 20,
    int? page,
    bool hardfetch = false,
  }) async {
    late Response? response;
    try {
      Map<int, Doctor> doctor = {};
      response = await HttpProvider.get(
          "get-doctors-panle?doctor_id=${doctorId ?? ''}&academic_degree=${acadimicDegree ?? ''}&administrative_position=${postion ?? ''}&user_name=${name ?? ''}&email=${email ?? ''}&data_of_birth=${dateOfBirth ?? ''}&roleId=${roleId ?? ''}&sectionName=${sectionName ?? ''}&phoneNumber=${phoneNumber ?? ''}&orderBy=${order ?? ''}&sort=${sort ?? ''}&limit=$limit&search=${search ?? ''}&page=$page");
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsDoctor in response?.data['data']) {
          doctor[jsDoctor["doctor_id"]] = Doctor.fromJson(jsDoctor);
        }
        return Result(
            data: {
              "Doctors": doctor,
              "totalDoctor": response?.data["pagination"]["totalDoctors"],
            },
            hasError: false,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }
      return Result(
          data: {
            "Doctors": doctor,
            "totalDoctor": 0,
          },
          hasError: false,
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
    int? studentId,
    int? level,
    int? section,
    int? limit,
    int? page,
    String? studySystem,
    String? sort,
    String? order,
    String? search,
    bool hardFetch = false,
  }) async {
    late Response? response;
    try {
      Map<int, Student> student = {};
      response = await HttpProvider.get(
          "get-student-panle?student_id=${studentId ?? ''}&student_level_id=${level ?? ''}&sectionName=${section ?? ''}&studentSystem=${studySystem ?? ''}&limit=${limit ?? ""}&orderBy=${order ?? ""}&sort=${sort ?? ""}&search=${search ?? ""}&page=$page");
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsStudent in response?.data['data']) {
          student[jsStudent["student_id"]] = Student.fromJson(jsStudent);
        }
        return Result(
          data: {
            "students": student,
            "totalStudent": response?.data["pagination"]["totalStudents"],
          },
          hasError: false,
          statusCode: response?.statusCode,
          message: response?.data["message"] ?? "error",
        );
      }
      return Result(
        data: {
          "students": student,
          "totalStudent": 0,
        },
        hasError: false,
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

  static Future<Result<Student>> createStudent({
    required int studentId,
    required int sectionId,
    required int roleId,
    required int level,
    required String name,
    required String dateOfBirth,
    required String college,
    required String email,
    required String password,
    required String enrolment,
    required String system,
    required List<Map<String, int>> phonenumber,
  }) async {
    get_x.Get.dialog(
      const PopUpLoadingCard(),
      barrierDismissible: false,
    );
    late Response? response;
    try {
      response = await HttpProvider.post("registerStudent", data: {
        "user_id": studentId,
        "user_name": name,
        "user_section_id": sectionId,
        "date_of_birth": dateOfBirth,
        "collegeName": college,
        "email": email,
        "roleId": roleId,
        "password": password,
        "student_level_id": level,
        "enrollment_year": enrolment,
        "student_system": system,
      });
      Student? newstudent;
      if (response?.statusCode == 201) {
        newstudent = Student.fromJson(response?.data["student"]);
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
        data: newstudent,
        hasError: true,
        statusCode: response?.statusCode ?? _createError,
        message: response?.data["message"] ?? "error",
      );
    } catch (error) {
      return Result(
        hasError: true,
        statusCode: _createError,
        message: error.toString(),
        data: null,
      );
    }
  }

  static Future<Result<Doctor>> createDoctor({
    required int doctorId,
    required int sectionId,
    required int roleId,
    required String name,
    required String dateOfBirth,
    required String college,
    required String email,
    required String password,
    required String academicdegree,
    required String postion,
    required List<Map<String, String>> phonenumber,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response = await HttpProvider.post("registerDoctor", data: {
        "user_id": doctorId,
        "user_name": name,
        "user_section_id": sectionId,
        "date_of_birth": dateOfBirth,
        "roleId": roleId,
        "password": password,
        "collegeName": college,
        "email": email,
        "academic_degree": academicdegree,
        "administrative_position": postion,
      });
      Doctor? newdoctor;
      if (response?.statusCode == 201) {
        newdoctor = Doctor.fromJson(response?.data["doctor"]);
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
        data: newdoctor,
        hasError: true,
        statusCode: response?.statusCode ?? _createError,
        message: response?.data["message"] ?? "error",
      );
    } catch (error) {
      return Result(
        hasError: true,
        statusCode: _createError,
        message: error.toString(),
        data: null,
      );
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

  static Future<Result<void>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.post("change-password", data: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": passwordConfirmation,
      });
      if (response?.statusCode == 200) {
        return Result(
            hasError: false,
            statusCode: response?.statusCode,
            message: "successful");
      }
      return Result(
          hasError: true,
          statusCode: response?.statusCode ?? 604,
          message: response?.statusMessage ?? "error");
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

  static bool checkPermission({
    required String target,
    required String action,
  }) {
    return _userBox
            ?.get('currentUser')
            ?.role
            ?.permissions[target]
            ?.any((e) => e.action == action) ??
        false;
  }

  static List<String>? getUserTopics() {
    if (_userBox?.get("currentUser") == null) return null;
    if (currentUserType() == Doctor) {
      return [
        "section_${_userBox?.get("currentUser")?.section?.id}",
        "doctor",
        "role_${_userBox?.get("currentUser")?.role?.id}",
        "all"
      ];
    }
    return [
      "section_${_userBox?.get("currentUser")?.section?.id}",
      "level_${(_userBox?.get("currentUser") as Student).level?.id}",
      "student",
      "role_${_userBox?.get("currentUser")?.role?.id}",
      "all"
    ];
  }
}

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../models/helper_models/result.dart';
import '../models/subject_model/subject_model.dart';
import '../services/http_provider/http_provider.dart';
import '../utils/internet_connection_cheker.dart';

class SubjectRepository {
  static const int _fetchAllError = 681;
  static const int _fetchError = 682;
  static Box<Subject>? _subjectsBox;

  static Future<void> openBox() async {
    _subjectsBox = await Hive.openBox<Subject>("subjectsBox");
  }

  static Future<void> clearBox() async {
    _subjectsBox = await Hive.openBox<Subject>("subjectsBox");
    _subjectsBox?.clear();
  }

  static Future<void> closeBox() async {
    if (_subjectsBox?.isOpen ?? false) {
      await _subjectsBox?.close();
    }
  }

  // static Future<Result<Map<String, Subject>>> fetchSubjects(
  //     {bool hardFetch = false, bool asMap = false}) async {
  //   if (_subjects != null && !hardFetch) {
  //     return Result(
  //       data: _subjects,
  //       statusCode: 200,
  //       hasError: false,
  //       message: "successful",
  //     );
  //   }
  //   late Response? response;
  //   try {
  //     response = await HttpProvider.get("get-all-subject");
  //     if (response?.statusCode == 200) {
  //       _subjects = {};
  //       for (Map<String, dynamic> jsSubject in response?.data["data"]) {
  //         _subjects?[jsSubject["subject_id"]] = Subject.fromJson(jsSubject);
  //       }
  //       return Result(
  //           data: _subjects,
  //           hasError: false,
  //           statusCode: response?.statusCode,
  //           message: response?.data["message"] ?? "error");
  //     }
  //     return Result(
  //         data: null,
  //         hasError: true,
  //         statusCode: response?.statusCode ?? _fetchAllError,
  //         message: response?.data["message"] ?? "error");
  //   } catch (error) {
  //     return Result(
  //         hasError: true,
  //         statusCode: _fetchAllError,
  //         message: error.toString(),
  //         data: null);
  //   }
  // }

  static Future<Result<Map<String, Subject>>> fetchSubjects({
    bool hardFetch = false,
  }) async {
    if ((_subjectsBox?.values.isNotEmpty ?? false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
          data: (_subjectsBox!.toMap().cast<String, Subject>()),
          hasError: false,
          statusCode: 200);
    }
    late Response? response;
    try {
      response = await HttpProvider.get("get-all-subject");
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsSubject in response?.data["data"]) {
          await _subjectsBox?.put(
              jsSubject["subject_id"], Subject.fromJson(jsSubject));
        }
        return Result(
            data: _subjectsBox?.toMap().cast<String, Subject>(),
            hasError: false,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }

      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode ?? _fetchAllError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchAllError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<Subject>> fetchSubject({
    required String id,
    bool hardFetch = false,
  }) async {
    if ((_subjectsBox?.get(id) != null) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
          data: (_subjectsBox?.get(id)), hasError: false, statusCode: 200);
    }
    late Response? response;
    try {
      response = await HttpProvider.get("/get-subject-id?id=$id");
      if (response?.statusCode == 200) {
        Subject subject = Subject.fromJson(response?.data["data"]);
        await _subjectsBox?.put(subject.id, subject);
        return Result(
            data: subject,
            hasError: false,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }

      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode ?? _fetchError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<Map>> fetchDashboardSubject({
    hardFetch = false,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.get("get-subject-panle");
      Map<int, Subject> subjects = {};
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jSubject in response?.data["data"]) {
          subjects[jSubject["id"]] = Subject.fromJson(jSubject);
        }
      }
      return Result(
        data: {
          "subject": subjects,
          "totalSubject": response?.data["pagination"]["totalSubjects"],
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
}

import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/subject_model.dart';
import '../models/result.dart';
import 'http_provider/http_provider.dart';

class SubjectServices {
  static const int _fetchAllError = 681;
  static const int _fetchError = 682;

  static Map<String, Subject>? _subjects;

  static Future<Result<Map<String, Subject>>> fetchSubjects(
      {bool hardFetch = false, bool asMap = false}) async {
    if (_subjects != null && !hardFetch) {
      return Result(
        data: _subjects,
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("get-all-subject");
      if (response?.statusCode == 200) {
        return Result(
            data: null,
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

    print("here2");
    if (_subjects == null) {
      fetchSubjects();
    }

    if (_subjects?[id] != null && !hardFetch) {
      return Result(
        data: _subjects?[id],
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("/get-subject-id?id=$id");
      if (response?.statusCode == 200) {
        _subjects?[response?.data["data"]["subject_id"]] =Subject.fromJson(response?.data["data"]);
        return Result(
            data: _subjects?[id],
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

  static void cacheSubjects(Map<String, Subject> subjects) {
    _subjects = subjects;
  }
}

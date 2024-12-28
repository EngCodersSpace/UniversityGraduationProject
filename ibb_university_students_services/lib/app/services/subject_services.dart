import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/level_model.dart';
import 'package:ibb_university_students_services/app/models/subject_model.dart';
import '../models/result.dart';
import 'http_provider/http_provider.dart';


class SubjectServices {
  static const int _fetchError = 611;

  static Map<String,Subject>? _subjects;

  static Future<Result<List<Subject>>> fetchSubjects({
    bool hardFetch = false,
  }) async {
    if (_subjects  != null &&
        !hardFetch) {
      return Result(
        data: _subjects?.values.toList(),
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("lectures/");
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


  static void cacheSubjects(Map<String,Subject> subjects){
    _subjects = subjects;
  }

}
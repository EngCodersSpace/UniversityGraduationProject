import 'dart:math';

import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/grads_model/grads_model.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import '../models/helper_models/result.dart';
import '../services/http_provider.dart';

class GradRepository {
  static const int _fetchError = 611;

  static Map<int, Map<int, Grad>>? _gradsByLevels;

  static Future<Result<List<Grad>>> fetchStudentGrads({
    required int levelId,
    required String? term,
    required int studentID,
    bool hardFetch = false,
  }) async {
    if (_gradsByLevels?[levelId] != null &&
        (_gradsByLevels?[levelId]?.isNotEmpty ?? false) &&
        !hardFetch) {
      return Result(
        data: _gradsByLevels?[levelId]?.values.toList(),
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-grades?studentID=$studentID&levelID=$levelId&Term=$term");
      // print(response?.data);
      if (response?.statusCode == 200) {
        _gradsByLevels ??= {};
        _gradsByLevels?[levelId] = {};

        for (Map<String, dynamic> jsGrad in response?.data["Grades"]) {
          // print("here");
          Grad grad = Grad.fromJson(jsGrad);

          _gradsByLevels?[levelId]?[grad.id] = grad;
        }
      }

      return Result(
          data: _gradsByLevels?[levelId]?.values.toList(),
          hasError: false,
          statusCode: response?.statusCode,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<Map>> fetchDashboardGrad({
    int? sectionId,
    int? levelId,
    int? studentId,
    String? subjectId,
    int limit = 20,
    int? page,
    String? term,
    String? order,
    String? sort,
    String? search,
    bool? hardfetch = false,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-grades-grouped-panle?student_id=${studentId ?? ''}&subject_id=${subjectId ?? ''}&section_id=${sectionId ?? ''}&level_id=${levelId ?? ''}&term=${term ?? ''}&order=${order ?? ''}&sort=${sort ?? ''}&search=${search ?? ''}&limit=$limit&page=$page&");
      Map<int, Grad> grad = {};
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsGrad in response?.data['data']) {
          Student? student =
              await UserRepository.fetchStudents(id: jsGrad["student_id"])
                  .then((e) => e.data);
          grad[jsGrad['id']] = Grad.fromJson(jsGrad, student: student);
        }
        return Result(
            data: {
              "grads": grad,
              "totalGrads": response?.data["pagination"]["totalGrades"],
            },
            hasError: false,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }
      return Result(
          data: {
            "grads": grad,
            "totalGrads": 0,
          },
          hasError: false,
          statusCode: response?.statusCode,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchError,
          message: error.toString(),
          data: null);
    }
  }
}

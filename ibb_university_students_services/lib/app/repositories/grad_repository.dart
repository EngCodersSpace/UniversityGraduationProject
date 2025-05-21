import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/grads_model/grads_model.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import '../models/helper_models/result.dart';
import '../models/helper_models/students_grades_cache/students_grades_cache.dart';
import '../services/http_provider.dart';
import '../utils/internet_connection_cheker.dart';

class GradRepository {
  static const int _fetchError = 611;


  static Box<StudentGradesCache>? _studentGradesBox;

  static Future<void> openBox() async {
    _studentGradesBox = await Hive.openBox<StudentGradesCache>("StudentGradesBox");
  }

  static Future<void> clearBox() async {
    _studentGradesBox = await Hive.openBox<StudentGradesCache>("StudentGradesBox");
    _studentGradesBox?.clear();
  }

  static Future<void> closeBox() async {
    if (_studentGradesBox?.isOpen ?? false) {
      await _studentGradesBox?.close();
    }
  }

  static Future<Result<Map<int,Grad>>> fetchStudentGrads({
    required int studentID,
    required String? mode,
    bool hardFetch = false,
  }) async {
    _studentGradesBox?.get(studentID);
    if ((_studentGradesBox?.get(studentID)?.data.values.isNotEmpty ?? false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
          data: _studentGradesBox?.get(studentID)?.data,
          hasError: false,
          statusCode: 200);
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "${(mode=="self")?"get-grades":"get-all-grades"}?studentID=$studentID");
      // print(response?.data);
      if (response?.statusCode == 200) {
        StudentGradesCache cachedGrads = StudentGradesCache(key: studentID, data: {});
        for (Map<String, dynamic> jsGrad in response?.data["Grades"] ?? {}) {
          Grad grad = Grad.fromJson(jsGrad);
          cachedGrads.data[grad.id] = grad;
          await _studentGradesBox?.put(
            studentID,
            cachedGrads,
          );
        }
        return Result(
            data: cachedGrads.data,
            hasError: false,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }

      return Result(
          data: null,
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
          "get-grades-grouped-panle?student_id=${studentId ?? ''}&subject_id=${subjectId ?? ''}&section_id=${sectionId ?? ''}&level_id=${levelId ?? ''}&term=${term ?? ''}&order=${order ?? ''}&sort=${sort ?? ''}&search=$search &limit=$limit&page=$page&");
      Map<int, Grad> grad = {};
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsGrad in response?.data['data']) {
          Subject? subject =
              await SubjectRepository.fetchSubject(id: jsGrad["subject_id"])
                  .then((e) => e.data);
          grad[jsGrad['grad_id']] = Grad.fromJson(
            jsGrad,
            subject: subject,
          );
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

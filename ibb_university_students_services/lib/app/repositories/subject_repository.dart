import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../models/helper_models/result.dart';
import '../models/helper_models/subjects_cache/subjects_cache.dart';
import '../models/subject_model/subject_model.dart';
import '../services/http_provider/http_provider.dart';
import '../utils/internet_connection_cheker.dart';

class SubjectRepository {
  static const int _fetchAllError = 681;
  static const int _fetchError = 682;

  static Map<String, Subject>? _subjects;
  static Box<SubjectsCache>? _subjectsBox;

  static Future<void> openBox() async {
    _subjectsBox = await Hive.openBox<SubjectsCache>("subjectsBox");
  }

  static Future<void> clearBox() async {
    _subjectsBox = await Hive.openBox<SubjectsCache>("subjectsBox");
    _subjectsBox?.clear();
  }

  static Future<void> closeBox() async {
    if(_subjectsBox?.isOpen??false) {
      await _subjectsBox?.close();
    }
  }

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
        _subjects = {};
        for (Map<String, dynamic> jsSubject in response?.data["data"]) {
          _subjects?[jsSubject["subject_id"]] = Subject.fromJson(jsSubject);
        }
        return Result(
            data: _subjects,
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

  static Future<Result<Map<String, Subject>>> fetchSubjectsGroup(
      {required int sectionId,
      required int levelId,
      required int studyPlanId,
      bool hardFetch = false,
      bool asMap = false}) async {
    SubjectsCache? cachedSubjects =
        _subjectsBox?.get("${sectionId}_${levelId}_${studyPlanId}_Subjects");
    if ((cachedSubjects != null) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
          data: cachedSubjects.data, hasError: false, statusCode: 200);
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-subject-by-filter?level_id=$levelId&section_id=$sectionId&study_plan_id=$studyPlanId");
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
        _subjects?[response?.data["data"]["subject_id"]] =
            Subject.fromJson(response?.data["data"]);
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

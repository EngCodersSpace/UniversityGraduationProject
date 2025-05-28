import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/study_plan_elements_model/study_plan_elements.dart';
import 'package:ibb_university_students_services/app/models/study_plan_model/study_plan_model.dart';
import '../models/helper_models/result.dart';
import '../services/http_provider.dart';
import '../utils/internet_connection_cheker.dart';

class StudyPlanRepository {
  static const int _fetchError = 611;

  static Box<StudyPlan>? _studyPlaneBox;
  static Box<StudyPlanElement>? _studyPlanElementBox;

  static Future<void> openBox() async {
    _studyPlaneBox = await Hive.openBox<StudyPlan>('studyPlanBox');
    _studyPlaneBox = await Hive.openBox<StudyPlan>('studyPlanElementBox');
    // Box  = await Hive.openBox('');
  }

  static Future<void> clearBox() async {
    _studyPlaneBox = await Hive.openBox<StudyPlan>('studyPlanBox');
    _studyPlaneBox?.clear();
    _studyPlanElementBox = await Hive.openBox<StudyPlanElement>('studyPlanElementBox');
    _studyPlanElementBox?.clear();
  }

  static Future<void> closeBox() async {
    if (_studyPlaneBox?.isOpen ?? false) {
      await _studyPlaneBox?.close();
    }
    if (_studyPlanElementBox?.isOpen ?? false) {
      await _studyPlanElementBox?.close();
    }
  }

  static Future<Result<Map<int, StudyPlan>>> fetchStudyPlans({
    bool hardFetch = false,
  }) async {
    if ((_studyPlaneBox?.isNotEmpty ?? false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
        data: (_studyPlaneBox?.toMap().cast<int, StudyPlan>()),
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("study-plan");
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsStudyPlan in response?.data["data"]) {
          StudyPlan studyPlan = StudyPlan.fromJson(jsStudyPlan);
          await _studyPlaneBox?.put(studyPlan.id,studyPlan );
        }
        return Result(
            data: (_studyPlaneBox?.toMap().cast<int, StudyPlan>()),
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

}

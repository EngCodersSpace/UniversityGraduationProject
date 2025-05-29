import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/study_plan_elements_model/study_plan_elements.dart';
import 'package:ibb_university_students_services/app/models/study_plan_model/study_plan_model.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/helper_models/result.dart';
import '../services/http_provider.dart';
import '../utils/internet_connection_cheker.dart';
import 'package:get/get.dart' as get_x;

class StudyPlanRepository {
  static const int _fetchError = 611;
  static const int _createError = 612;

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

  static Future<Result<Map<int,StudyPlanElement>>> fetchStudyPlanElements({
    required int studyPlanId,
    required String? mode,
    bool hardFetch = false,
  }) async {
    if ((_studyPlanElementBox?.values.isNotEmpty ?? false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
          data:Map.fromEntries( _studyPlanElementBox!.toMap().cast<int,StudyPlanElement>().entries.where((e)=>e.value.studyPlanId == studyPlanId)),
          hasError: false,
          statusCode: 200);
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-All-study-plan-element?study_plan_id=$studyPlanId");
      // print(response?.data);
      if (response?.statusCode == 200) {
        Map<int,StudyPlanElement> map = {};
        for (Map<String, dynamic> jsStudyPlanElement in response?.data["data"] ?? {}) {
          Subject? subject =  await SubjectRepository.fetchSubject(id: jsStudyPlanElement['subject_id']).then((e)=>e.data);
          StudyPlanElement studyPlanElement = StudyPlanElement.fromJson(jsStudyPlanElement,subject: subject);
          map[studyPlanElement.id] = studyPlanElement;
          await _studyPlanElementBox?.put(
            studyPlanElement.id,
            studyPlanElement,
          );
        }
        return Result(
            data: map,
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

  static Future<Result<StudyPlan>> createStudyPlan({
    required String name,
    bool withCache = true,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response = await HttpProvider.post("study-plan", data: {
        "study_plan_name": name,
      });
      StudyPlan? studyPlan;
      if (response?.statusCode == 201) {
        studyPlan = StudyPlan.fromJson(response?.data["data"]);
        if (withCache) {
          await _studyPlaneBox?.put(studyPlan.id, studyPlan);
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: studyPlan,
          hasError: true,
          statusCode: response?.statusCode ?? _createError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _createError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<StudyPlanElement>> createStudyPlanElement({
    required int studyPlanId,
    required int sectionId,
    required int levelId,
    required String subjectId,
    required int doctorId,
    required String term,
    bool withCache = true,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response = await HttpProvider.post("create-lecture", data: {
        "study_plan_id": studyPlanId,
        "subject_id": subjectId,
        "doctor_id": doctorId,
        "section": sectionId,
        "level": levelId,
        "term": term
      });
      StudyPlanElement? studyPlanElement;
      if (response?.statusCode == 201) {
        Subject? subject = await SubjectRepository.fetchSubject(
            id: response?.data["data"]["subject_id"])
            .then((e) => e.data);
        studyPlanElement = StudyPlanElement.fromJson(response?.data["data"], subject: subject);
        if (withCache) {
          await _studyPlanElementBox?.put(studyPlanElement.id, studyPlanElement);
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: studyPlanElement,
          hasError: true,
          statusCode: response?.statusCode ?? _createError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _createError,
          message: error.toString(),
          data: null);
    }
  }
}

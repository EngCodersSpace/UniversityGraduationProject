import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart' as get_x;
import 'package:ibb_university_students_services/app/components/pop_up_cards/alert_message_card.dart';
import 'package:ibb_university_students_services/app/components/pop_up_cards/loading_card.dart';
import '../models/helper_models/result.dart';
import '../models/subject_model/subject_model.dart';
import '../services/http_provider.dart';
import '../utils/internet_connection_cheker.dart';

class SubjectRepository {
  static const int _fetchAllError = 681;
  static const int _fetchError = 682;
  static const int _createError = 623;
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

  static Future<Result<Subject>> createSubject({
    required String subjectId,
    required String subjectName,
    required int numberOfUnit,
    required String description,
  }) async {
    get_x.Get.dialog(PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response = await HttpProvider.post("create-subject", data: {
        "subject_id": subjectId,
        "subject_name": subjectName,
        "number_of_units": numberOfUnit,
        "subject_description": description,
      });
      Subject? newsubject;
      if (response?.statusCode == 201) {
        newsubject = Subject.fromJson(response?.data["subject"]);
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
        data: newsubject,
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

  static Future<Result<Map>> fetchDashboardSubject({
    int? sectionid,
    int? levelid,
    String? subjectId,
    String? subjectName,
    int? numberOfUnit,
    String? description,
    String? order,
    String? sort,
    String? search,
    int? limit,
    int? page,
    hardFetch = false,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-subject-panle?subject_id=${subjectId ?? ''}&subject_name=${subjectName ?? ''}&number_of_units=${numberOfUnit ?? ''}&subject_description=${description ?? ''}&section_id=${sectionid ?? ''}&level_id=${levelid ?? ''}&orderBy=${order ?? ''}&sort=${sort ?? ''}&limit=${limit ?? ''}&search=${search ?? ''}&page=$page ");
      Map<String, Subject> subjects = {};
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jSubject in response?.data['data']) {
          subjects[jSubject['subject_id']] = Subject.fromJson(jSubject);
        }
        return Result(
          data: {
            "subject": subjects,
            "totalSubject": response?.data["pagination"]["totalSubjects"],
          },
          hasError: false,
          statusCode: response?.statusCode,
          message: response?.data["message"] ?? "error",
        );
      }
      return Result(
        data: {
          "subject": subjects,
          "totalSubject": 0,
        },
        hasError: false,
        statusCode: response?.statusCode,
        message: response?.data["message"] ?? "error",
      );
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchError,
          message: error.toString(),
          data: null);
    }
  }
}

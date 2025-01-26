import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart' as get_x;
import '../components/pop_up_cards/alert_message_card.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/assignment_model/assignment_model.dart';
import '../models/helper_models/assignments_cache/assignments_cache.dart';
import '../models/helper_models/result.dart';
import '../services/http_provider/http_provider.dart';
import '../utils/internet_connection_cheker.dart';

class AssignmentsRepository {
  static const int _fetchAllError = 621;
  // ignore: unused_field
  static const int _fetchError = 622;
  static const int _createError = 623;
  // ignore: unused_field
  static const int _updateError = 624;
  static const int _deleteError = 625;

  static Map<String, Map<int, Assignment>?>? _assignments;

  static Box<AssignmentsCache>? _assignmentsBox;

  static Future<void> openBox() async {
    _assignmentsBox = await Hive.openBox<AssignmentsCache>("assignmentsBox");
  }

  static Future<void> clearBox() async {
    _assignmentsBox = await Hive.openBox<AssignmentsCache>("assignmentsBox");
    _assignments?.clear();
  }

  static Future<void> closeBox() async {
    if (_assignmentsBox?.isOpen ?? false) {
      await _assignmentsBox?.close();
    }
  }

  static Future<Result<Map<int, Assignment>>> fetchAssignmentsGroup({
    required int sectionId,
    required int levelId,
    required String year,
    required String subjectId,
    bool hardFetch = false,
  }) async {
    AssignmentsCache? cachedAssignments = _assignmentsBox
        ?.get("${sectionId}_${levelId}_${year}_${subjectId}_Assignments");
    if ((cachedAssignments != null) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
          data: cachedAssignments.data, hasError: false, statusCode: 200);
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-assignments-subject?subject_id=$subjectId&level_id=$levelId&section_id=$sectionId");
      if (response?.statusCode == 200) {
        cachedAssignments = AssignmentsCache(
            key: "${sectionId}_${levelId}_${year}_${subjectId}_Assignments",
            data: {});
        for (Map<String, dynamic> jsAssignments in response?.data["data"]) {
          {
            Assignment assignment = Assignment.fromJson(jsAssignments);
            cachedAssignments.data[assignment.id] = assignment;
          }
          await _assignmentsBox?.put(
            "${sectionId}_${levelId}_${year}_${subjectId}_Assignments",
            cachedAssignments,
          );
        }
        return Result(
            data: cachedAssignments.data,
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

  static Future<Result<Assignment>> createAssignment({
    required int sectionId,
    required int levelId,
    required String subjectId,
    String year = "",
    required data,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response =
          await HttpProvider.post("upload-assignment-doctor", data: data);
      Assignment? newAssignment;
      if (response?.statusCode == 201) {
        newAssignment =
            Assignment.fromJson(response?.data["data"]["assignment"]);
        AssignmentsCache? cachedAssignments = _assignmentsBox
            ?.get("${sectionId}_${levelId}_${year}_${subjectId}_Assignments");
        cachedAssignments ??
            AssignmentsCache(
                key: "${sectionId}_${levelId}_${year}_${subjectId}_Assignments",
                data: {});
        cachedAssignments?.data[newAssignment.id] = newAssignment;
        if (cachedAssignments != null) {
          await _assignmentsBox?.put(
              "${sectionId}_${levelId}_${year}_${subjectId}_Assignments",
              cachedAssignments);
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: newAssignment,
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

  // static Future<Result<Lecture>> updateLecture({
  //   required int sectionId,
  //   required int levelId,
  //   required String year,
  //   required String term,
  //   required String day,
  //   required data,
  //   required id,
  //   bool hardFetch = false,
  // }) async {
  //   get_x.Get.dialog(const PopUpLoadingCard(),
  //       barrierDismissible: false, name: "loadingDialog");
  //   late Response? response;
  //   AssignmentsCache? cachedDayAssignments = _lecturesBox?.get(
  //       "${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Assignments");
  //   try {
  //     response = await HttpProvider.put("update-lecture?id=$id", data: data);
  //     if (response?.statusCode == 200) {
  //       Subject? subject;
  //       if (cachedDayAssignments?.data[day]?[id]?.subject?.id !=
  //           data["subject_id"]) {
  //         subject = await SubjectRepository.fetchSubject(id: data["subject_id"])
  //             .then((e) => e.data);
  //       }
  //
  //       cachedDayAssignments?.data[day]?[id]
  //           ?.updateFromJson(data, subject: subject);
  //       if (cachedDayAssignments != null) {
  //         await _lecturesBox?.put(
  //             "${sectionId}_${levelId}_${year}_${term}_Assignments",
  //             cachedDayAssignments);
  //       }
  //     } else if (response?.statusCode == 403) {
  //       await get_x.Get.dialog(PopUpAlertCard(
  //           response?.data["message"] ?? "UnAuthorized Action", Icons.block));
  //     }
  //     return Result(
  //         data: cachedDayAssignments?.data[day]?[id],
  //         hasError: true,
  //         statusCode: response?.statusCode ?? _updateError,
  //         message: response?.data["message"] ?? "error");
  //   } catch (error) {
  //     return Result(
  //         hasError: true,
  //         statusCode: _updateError,
  //         message: error.toString(),
  //         data: null);
  //   }
  // }
  //
  static Future<Result<void>> deleteAssignment({
    required int sectionId,
    required int levelId,
    String year = "",
    required String subjectId,
    required id,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response =
          await HttpProvider.delete("delete-assignment?assignment_id=$id");
      if (response?.statusCode == 200) {
        AssignmentsCache? cachedAssignments = _assignmentsBox
            ?.get("${sectionId}_${levelId}_${year}_${subjectId}_Assignments");
        cachedAssignments?.data.remove(id);
        if (cachedAssignments != null) {
          await _assignmentsBox?.put(cachedAssignments.key, cachedAssignments);
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          hasError: false,
          statusCode: response?.statusCode ?? _deleteError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _deleteError,
          message: error.toString(),
          data: null);
    }
  }
  //
  // static Future<Result<void>> changeLectureState({
  //   required int sectionId,
  //   required int levelId,
  //   required String year,
  //   required String term,
  //   required String day,
  //   required String action,
  //   required int id,
  //   bool hardFetch = false,
  // }) async {
  //   get_x.Get.dialog(const PopUpLoadingCard(),
  //       barrierDismissible: false, name: "loadingDialog");
  //   late Response? response;
  //   try {
  //     AssignmentsCache? cachedDayAssignments = _lecturesBox?.get(
  //         "${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Assignments");
  //     response = await HttpProvider.post("changeLecStatus-lecture",
  //         data: {"id": 7, "action": action});
  //     if (response?.statusCode == 200) {
  //       cachedDayAssignments?.data[day]?[id]?.lectureStatus =
  //           (action == "confirm")
  //               ? true
  //               : (action == "cancel")
  //                   ? false
  //                   : null;
  //       if (cachedDayAssignments != null) {
  //         await _lecturesBox?.put(
  //             "${sectionId}_${levelId}_${year}_${term}_Assignments",
  //             cachedDayAssignments);
  //       }
  //     } else if (response?.statusCode == 403) {
  //       await get_x.Get.dialog(PopUpAlertCard(
  //           response?.data["message"] ?? "UnAuthorized Action", Icons.block));
  //     }
  //
  //     return Result(
  //         hasError: false,
  //         statusCode: response?.statusCode ?? _changeStateError,
  //         message: response?.data["message"] ?? "error");
  //   } catch (error) {
  //     return Result(
  //         hasError: true,
  //         statusCode: _changeStateError,
  //         message: error.toString(),
  //         data: null);
  //   }
  // }
}

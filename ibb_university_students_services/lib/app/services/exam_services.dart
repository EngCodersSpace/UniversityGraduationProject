import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/components/pop_up_cards/alert_message_card.dart';
import 'package:ibb_university_students_services/app/models/helper_models/exams_cache/exams_cache.dart';
import 'package:ibb_university_students_services/app/services/subject_services.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/exam_model/exam_model.dart';
import '../models/helper_models/result.dart';
import '../models/subject_model/subject_model.dart';
import '../utils/internet_connection_cheker.dart';
import 'http_provider/http_provider.dart';

class ExamServices {
  static const int _fetchAllError = 621;

  // ignore: unused_field
  static const int _fetchError = 622;
  static const int _createError = 623;
  static const int _updateError = 624;
  static const int _deleteError = 625;

  static Box<ExamsCache>? _examsBox;

  static Future<void> openBox() async {
    _examsBox = await Hive.openBox<ExamsCache>("ExamBox");
  }

  static Future<void> closeBox() async {
    await _examsBox?.close();
  }

  static Future<Result<Map<int, Exam>>> fetchExamsGroup({
    required int sectionId,
    required int levelId,
    bool hardFetch = false,
  }) async {
    ExamsCache? cachedExams = _examsBox?.get("${sectionId}_${levelId}_Exams");
    if ((cachedExams != null) && (!hardFetch|| !(await checkInternetConnection())
        )) {
      return Result(
        data: cachedExams.data,
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-exam-grouped?section_id=$sectionId&level_id=$levelId");
      if (response?.statusCode == 200) {
        ExamsCache exams =
            ExamsCache(key: "${sectionId}_${levelId}_Exams", data: {});
        for (Map<String, dynamic> jsExam in response?.data["data"]) {
          Subject? subject =
              await SubjectServices.fetchSubject(id: jsExam["subject_id"])
                  .then((e) {
            return e.data;
          });
          Exam exam = Exam.fromJson(jsExam, subject: subject);
          exams.data[exam.id] = exam;
        }
        await _examsBox?.put(
          exams.key,
          exams,
        );
        return Result(
            data: exams.data,
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

  static Future<Result<Exam>> createExam({
    required int sectionId,
    required int levelId,
    required data,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.post("create-exam", data: data);
      Exam? newExam;
      if (response?.statusCode == 201) {
        ExamsCache? cachedExams =
            _examsBox?.get("${sectionId}_${levelId}_Exams");
        cachedExams ??=
            ExamsCache(key: "${sectionId}_${levelId}_Exams", data: {});
        Subject? subject = await SubjectServices.fetchSubject(
                id: response?.data["exam"]["subject_id"])
            .then((e) => e.data);
        newExam = Exam.fromJson(response?.data["exam"], subject: subject);
        cachedExams.data[newExam.id] = newExam;
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: newExam,
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

  static Future<Result<Exam>> updateExam({
    required int sectionId,
    required int levelId,
    required data,
    required id,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.put("update-exam?exam_id=$id", data: data);
      Exam? newExam;
      if (response?.statusCode == 200) {
        ExamsCache? cachedExams =
            _examsBox?.get("${sectionId}_${levelId}_Exams");
        Subject? subject = await SubjectServices.fetchSubject(
                id: response?.data["exam"]["subject_id"])
            .then((e) => e.data);
        newExam = Exam.fromJson(response?.data["exam"], subject: subject);
        cachedExams?.data[newExam.id] = newExam;
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: newExam,
          hasError: true,
          statusCode: response?.statusCode ?? _updateError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _updateError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<void>> deleteExam({
    required int sectionId,
    required int levelId,
    required id,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response = await HttpProvider.delete("delete-exam?exam_id=$id");
      if (response?.statusCode == 200) {
        _examsBox?.get("${sectionId}_${levelId}_Exams")?.data.remove(id);
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
}

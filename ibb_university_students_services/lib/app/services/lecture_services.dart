import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ibb_university_students_services/app/models/lecture_model.dart';
import 'package:get/get.dart' as get_x;
import 'package:ibb_university_students_services/app/services/subject_services.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/days_table.dart';
import '../models/result.dart';
import '../models/subject_model.dart';
import 'http_provider/http_provider.dart';

class LectureServices {
  static const int _fetchAllError = 611;
  static const int _fetchError = 611;
  static const int _createError = 612;
  static const int _updateError = 612;
  static const int _deleteError = 612;
  static const int _fetchYearsError = 619;

  static Map<
          String,
          Map<String,
              Map<String, Map<String, Map<String, Map<int, Lecture>>>?>?>?>?
      _lectures;
  static List<String>? _years;

  static Future<Result<TableDays>> fetchTableTime({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    bool hardFetch = false,
  }) async {
    if (_lectures?[sectionId.toString()]?[levelId.toString()]?[year]?[term] !=
            null &&
        !hardFetch) {
      return Result(
        data: TableDays.fromJson(_lectures![sectionId.toString()]![
            levelId.toString()]![year]![term]!),
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "lectures/grouped?section_id=$sectionId&level_id=$levelId&term=$term");
      if (response?.statusCode == 200) {
        _lectures ??= {};
        if (_lectures?[sectionId.toString()] == null) {
          _lectures?[sectionId.toString()] = {};
        }
        if (_lectures?[sectionId.toString()]?[levelId.toString()] == null) {
          _lectures?[sectionId.toString()]?[levelId.toString()] = {};
        }
        if (_lectures?[sectionId.toString()]?[levelId.toString()]?[year] ==
            null) {
          _lectures?[sectionId.toString()]?[levelId.toString()]?[year] = {};
        }
        if (_lectures?[sectionId.toString()]?[levelId.toString()]?[year]
                ?[term] ==
            null) {
          _lectures?[sectionId.toString()]?[levelId.toString()]?[year]
              ?[term] = {};
        }

        for (String term in (response?.data["data"] as Map).keys) {
          for (String day in (response?.data["data"][term] as Map).keys) {
            _lectures?[sectionId.toString()]?[levelId.toString()]?[year]?[term]
                ?[day] = {};
            for (Map<String, dynamic> jsLecture in response?.data["data"][term]
                [day]) {
              Subject? subject = await SubjectServices.fetchSubject(
                      id: jsLecture["subject"]["subject_id"])
                  .then((e) => e.data);
              Lecture lecture = Lecture.fromJson(jsLecture, subject: subject);
              _lectures?[sectionId.toString()]?[levelId.toString()]?[year]
                  ?[term]?[day]?[lecture.id] = lecture;
            }
          }
        }
        if (_lectures?[sectionId.toString()]?[levelId.toString()]?[year]
                ?[term] !=
            null) {
          return Result(
              data: TableDays.fromJson(_lectures![sectionId.toString()]![
                  levelId.toString()]![year]![term]!),
              hasError: false,
              statusCode: response?.statusCode,
              message: response?.data["message"] ?? "error");
        }
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

  static Future<Result<Lecture>> createLecture({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    required String day,
    required data,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.post("create-lecture", data: data);
      print(response?.data);
      Lecture? newLecture;
      if (response?.statusCode == 201) {
        Subject? subject = await SubjectServices.fetchSubject(
                id: response?.data["data"]["subject_id"])
            .then((e) => e.data);
        newLecture = Lecture.fromJson(response?.data["data"], subject: subject);
        _lectures?[sectionId.toString()]?[levelId.toString()]?[year]?[term]
            ?[day]?[newLecture.id] = newLecture;
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: newLecture,
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

  static Future<Result<Lecture>> updateLecture({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    required String day,
    required data,
    required id,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.put("update-lecture?id=$id", data: data);
      print(response?.data);
      Lecture? newLecture;
      if (response?.statusCode == 200) {
        Subject? subject = await SubjectServices.fetchSubject(
                id: response?.data["exam"]["subject_id"])
            .then((e) => e.data);
        newLecture = Lecture.fromJson(response?.data["exam"], subject: subject);
        _lectures?[sectionId.toString()]?[levelId.toString()]?[year]?[term]
        ?[day]?[newLecture.id] = newLecture;
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: newLecture,
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

  static Future<Result<void>> deleteLecture({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    required String day,
    required id,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.delete("delete-exam?exam_id=$id");
      if (response?.statusCode == 200) {
        _lectures?[sectionId.toString()]?[levelId.toString()]?[year]?[term]
        ?[day]?.remove(id);
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

  static Future<Result<List<String>>> fetchLectureYears({
    bool hardFetch = false,
  }) async {
    if (_years != null && !hardFetch) {
      return Result(
        data: _years,
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("lecture/year");
      if (response?.statusCode == 200) {
        _years = List<String>.from(response?.data["data"]);
        return Result(
            data: _years,
            hasError: true,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }
      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode ?? _fetchYearsError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchYearsError,
          message: error.toString(),
          data: null);
    }
  }
}

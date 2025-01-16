import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/helper_models/lectures_cache/lectures_cache.dart';
import 'package:ibb_university_students_services/app/models/lecture_model/lecture_model.dart';
import 'package:get/get.dart' as get_x;
import 'package:ibb_university_students_services/app/services/subject_services.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/helper_models/days_table.dart';
import '../models/helper_models/result.dart';
import '../models/subject_model/subject_model.dart';
import '../utils/internet_connection_cheker.dart';
import 'http_provider/http_provider.dart';

class LectureServices {
  static const int _fetchAllError = 611;

  // ignore: unused_field
  static const int _fetchError = 611;
  static const int _createError = 612;
  static const int _updateError = 612;
  static const int _deleteError = 612;
  static const int _changeStateError = 612;
  static const int _fetchYearsError = 619;

  static Box<LecturesCache>? _lecturesBox;

  static Future<void> openBox() async {
    _lecturesBox = await Hive.openBox<LecturesCache>("lectureBox");
  }

  static Future<void> closeBox() async {
    await _lecturesBox?.close();
  }

  static Future<Result<TableDays>> fetchTableTime({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    bool hardFetch = false,
  }) async {
    LecturesCache? cachedDayLectures = _lecturesBox?.get(
        "${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Lectures");
    if ((cachedDayLectures != null) && (!hardFetch|| !(await checkInternetConnection()))) {
      return Result(
          data: TableDays.fromJson(cachedDayLectures!.data),
          hasError: false,
          statusCode: 200);
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "lectures/grouped?section_id=$sectionId&level_id=$levelId&term=$term");
      if (response?.statusCode == 200) {
        LecturesCache dayLectures = LecturesCache(
            key:
                "${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Lectures",
            data: {});

        for (String term in (response?.data["data"] as Map).keys) {
          for (String day in (response?.data["data"][term] as Map).keys) {
            dayLectures.data[day] = {};
            for (Map<String, dynamic> jsLecture in response?.data["data"][term]
                [day]) {
              Subject? subject = await SubjectServices.fetchSubject(
                      id: jsLecture["subject_id"])
                  .then((e) => e.data);
              Lecture lecture = Lecture.fromJson(jsLecture, subject: subject);
              dayLectures.data[day]?[lecture.id] = lecture;
            }
          }

          await _lecturesBox?.put(
            dayLectures.key,
            dayLectures,
          );
        }
        return Result(
            data: TableDays.fromJson(dayLectures.data),
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

  static Future<Result<Lecture>> createLecture({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    required String day,
    required data,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response = await HttpProvider.post("create-lecture", data: data);
      Lecture? newLecture;
      if (response?.statusCode == 201) {
        Subject? subject = await SubjectServices.fetchSubject(
                id: response?.data["data"]["subject_id"])
            .then((e) => e.data);
        newLecture = Lecture.fromJson(response?.data["data"], subject: subject);
        LecturesCache? cachedDayLectures = _lecturesBox?.get(
            "${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Lectures");
        cachedDayLectures?.data[day]?[newLecture.id] = newLecture;
        if (cachedDayLectures != null) {
          await _lecturesBox?.put(
              "${sectionId}_${levelId}_${year}_${term}_Lectures",
              cachedDayLectures);
        }
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
    LecturesCache? cachedDayLectures = _lecturesBox?.get(
        "${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Lectures");
    try {
      response = await HttpProvider.put("update-lecture?id=$id", data: data);
      if (response?.statusCode == 200) {
        Subject? subject;
        if (cachedDayLectures?.data[day]?[id]?.subject?.id !=
            data["subject_id"]) {
          subject = await SubjectServices.fetchSubject(id: data["subject_id"])
              .then((e) => e.data);
        }

        cachedDayLectures?.data[day]?[id]
            ?.updateFromJson(data, subject: subject);
        if (cachedDayLectures != null) {
          await _lecturesBox?.put(
              "${sectionId}_${levelId}_${year}_${term}_Lectures",
              cachedDayLectures);
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: cachedDayLectures?.data[day]?[id],
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
      LecturesCache? cachedDayLectures = _lecturesBox?.get(
          "${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Lectures");

      response = await HttpProvider.delete("delete-lecture?id=$id");
      if (response?.statusCode == 200) {
        cachedDayLectures?.data[day]?.remove(id);
        if (cachedDayLectures != null) {
          await _lecturesBox?.put(
              "${sectionId}_${levelId}_${year}_${term}_Lectures",
              cachedDayLectures);
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

  static Future<Result<void>> changeLectureState({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    required String day,
    required String action,
    required int id,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      LecturesCache? cachedDayLectures = _lecturesBox?.get(
          "${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Lectures");
      response = await HttpProvider.post("changeLecStatus-lecture",
          data: {"id": 7, "action": action});
      if (response?.statusCode == 200) {
        cachedDayLectures?.data[day]?[id]?.lectureStatus = (action == "confirm")
            ? true
            : (action == "cancel")
                ? false
                : null;
        if (cachedDayLectures != null) {
          await _lecturesBox?.put(
              "${sectionId}_${levelId}_${year}_${term}_Lectures",
              cachedDayLectures);
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }

      return Result(
          hasError: false,
          statusCode: response?.statusCode ?? _changeStateError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _changeStateError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<Lecture>> tempReplaceLecture({
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
      LecturesCache? cachedDayLectures = _lecturesBox?.get("${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Lectures");
      response =
          await HttpProvider.post("replaceOne-lecture?id=$id", data: data);

      Lecture? newLecture;
      if (response?.statusCode == 200) {
        Subject? subject = await SubjectServices.fetchSubject(
                id: response?.data["replacedLecture"]["subject_id"])
            .then((e) => e.data);
        newLecture = Lecture.fromJson(response?.data["replacedLecture"],
            subject: subject);
        cachedDayLectures?.data[day]?[newLecture.id] = newLecture;
        cachedDayLectures?.data[day]
            ?.remove(id);
        if (cachedDayLectures != null) {
          await _lecturesBox?.put(
              "${sectionId}_${levelId}_${year}_${term}_Lectures",
              cachedDayLectures);
        }

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

  static Future<Result<List<String>>> fetchLectureYears({
    bool hardFetch = false,
  }) async {
    Box lecturesYearsBox = await Hive.openBox<List<String>>("YearsBox");
    List<String>? years = lecturesYearsBox.get("lectureYears");
    if (years != null && !hardFetch && !(await checkInternetConnection())) {
      await lecturesYearsBox.close();
      return Result(
        data: years,
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("lecture/year");
      if (response?.statusCode == 200) {
        List<String> years = List<String>.from(response?.data["data"]);
        await lecturesYearsBox.put("lectureYears",years);
        lecturesYearsBox.close();
        return Result(
            data: years,
            hasError: true,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }
      lecturesYearsBox.close();
      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode ?? _fetchYearsError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      lecturesYearsBox.close();
      return Result(
          hasError: true,
          statusCode: _fetchYearsError,
          message: error.toString(),
          data: null);
    }
  }
}

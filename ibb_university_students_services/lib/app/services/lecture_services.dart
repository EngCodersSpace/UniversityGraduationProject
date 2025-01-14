import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/lecture_model/lecture_model.dart';
import 'package:get/get.dart' as get_x;
import 'package:ibb_university_students_services/app/services/subject_services.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/helper_models/days_table.dart';
import '../models/helper_models/result.dart';
import '../models/subject_model/subject_model.dart';
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

  static Box<Map<String, Map<int, Lecture>>>? _lecturesBox;
  static List<String>? _years;

  static Future<void> openBox() async {
    _lecturesBox =
        await Hive.openBox<Map<String, Map<int, Lecture>>>("lectureBox");
    // await _lecturesBox?.clear();
    // Box  = await Hive.openBox('');
  }

  static Future<void> closeBox() async {
    await _lecturesBox?.close();
    // Box  = await Hive.openBox('');
  }

  static Future<Result<TableDays>> fetchTableTime({
    required int sectionId,
    required int levelId,
    required String year,
    required String term,
    bool hardFetch = false,
  }) async {
    await openBox();
    print("heree_____________________");
    print("${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Lectures");
    // var cachedDayLectures =  _lecturesBox!.get("${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Lectures");
    var cachedDayLectures =  Map<String, Map<int, Lecture>>.from(_lecturesBox?.get("t1",defaultValue: {})??{});
    print(cachedDayLectures);
    if ((cachedDayLectures != null)&&
        !hardFetch) {
      return Result(
          data: TableDays.fromJson(cachedDayLectures),
          hasError: false,
          statusCode: 200);
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "lectures/grouped?section_id=$sectionId&level_id=$levelId&term=$term");
      if (response?.statusCode == 200) {
        Map<String, Map<int, Lecture>> dayLectures = {};
        for (String term in (response?.data["data"] as Map).keys) {
          for (String day in (response?.data["data"][term] as Map).keys) {
              dayLectures[day] = {};
            for (Map<String, dynamic> jsLecture in response?.data["data"][term]
                [day]) {
              Subject? subject = await SubjectServices.fetchSubject(
                      id: jsLecture["subject_id"])
                  .then((e) => e.data);
              Lecture lecture = Lecture.fromJson(jsLecture, subject: subject);
              dayLectures[day]?[lecture.id] = lecture;
            }
          }
          await _lecturesBox?.put(
              "t1",
              dayLectures);

          closeBox();
        }
        return Result(
            data: TableDays.fromJson(dayLectures),
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
        Map<String, Map<int, Lecture>>? dayLectures = await _lecturesBox?.get("${sectionId}_${levelId}_${year}_${term}_Lectures");
        if(dayLectures != null){
          dayLectures[day]?[newLecture.id] = newLecture;
          await _lecturesBox?.put("${sectionId}_${levelId}_${year}_${term}_Lectures", dayLectures);
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
    Map<String, Map<int, Lecture>>? dayLectures = await _lecturesBox?.get("${sectionId}_${levelId}_${year}_${term}_Lectures");
    try {
      response = await HttpProvider.put("update-lecture?id=$id", data: data);
      if (response?.statusCode == 200) {
        Subject? subject;
        if (dayLectures?[day]?[id]?.subject?.id !=
            data["subject_id"]) {
          subject = await SubjectServices.fetchSubject(id: data["subject_id"])
              .then((e) => e.data);
        }

        dayLectures?[day]?[id]
            ?.updateFromJson(data, subject: subject);
        await _lecturesBox?.put("${sectionId}_${levelId}_${year}_${term}_Lectures", dayLectures??{});

      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: dayLectures?[day]?[id],
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
      Map<String, Map<int, Lecture>>? dayLectures = await _lecturesBox?.get("${sectionId}_${levelId}_${year}_${term}_Lectures");
      response = await HttpProvider.delete("delete-lecture?id=$id");
      if (response?.statusCode == 200) {
        dayLectures?[day]
            ?.remove(id);
        await _lecturesBox?.put("${sectionId}_${levelId}_${year}_${term}_Lectures", dayLectures??{});
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
      Map<String, Map<int, Lecture>>? dayLectures = await _lecturesBox?.get("${sectionId}_${levelId}_${year}_${term}_Lectures");
      response = await HttpProvider.post("changeLecStatus-lecture",
          data: {"id": 7, "action": action});
      if (response?.statusCode == 200) {
        dayLectures?[day]?[id]?.lectureStatus =
            (action == "confirm")
                ? true
                : (action == "cancel")
                    ? false
                    : null;
        await _lecturesBox?.put("${sectionId}_${levelId}_${year}_${term}_Lectures", dayLectures??{});
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
      Map<String, Map<int, Lecture>>? dayLectures = await _lecturesBox?.get("${sectionId}_${levelId}_${year}_${term}_Lectures");
      response =
          await HttpProvider.post("replaceOne-lecture?id=$id", data: data);

      Lecture? newLecture;
      if (response?.statusCode == 200) {
        Subject? subject = await SubjectServices.fetchSubject(
                id: response?.data["replacedLecture"]["subject_id"])
            .then((e) => e.data);
        newLecture = Lecture.fromJson(response?.data["replacedLecture"],
            subject: subject);
        dayLectures?[day]?[newLecture.id] = newLecture;
        dayLectures?[day]
            ?.remove(id);
        await _lecturesBox?.put("${sectionId}_${levelId}_${year}_${term}_Lectures", dayLectures??{});

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

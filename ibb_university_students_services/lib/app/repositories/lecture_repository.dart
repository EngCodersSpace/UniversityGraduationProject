import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/helper_models/lectures_cache/lectures_cache.dart';
import 'package:ibb_university_students_services/app/models/lecture_model/lecture_model.dart';
import 'package:get/get.dart' as get_x;
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/helper_models/days_table.dart';
import '../models/helper_models/result.dart';
import '../models/subject_model/subject_model.dart';
import '../utils/date_time_utils.dart';
import '../utils/internet_connection_cheker.dart';
import '../services/http_provider.dart';

class LectureRepository {
  static const int _fetchAllError = 611;

  // ignore: unused_field
  static const int _fetchError = 611;
  static const int _createError = 612;
  static const int _updateError = 612;
  static const int _deleteError = 612;
  static const int _changeStateError = 612;
  static const int _fetchYearsError = 619;

  static Box<LecturesCache>? _lecturesGroupsBox;
  static Box<Lecture>? _lecturesBox;

  static Future<void> openBox() async {
    _lecturesGroupsBox = await Hive.openBox<LecturesCache>("lecturesGroupBox");
    _lecturesBox = await Hive.openBox<Lecture>("lecturesBox");
  }

  static Future<void> clearBox() async {
    _lecturesBox ?? await Hive.openBox<Lecture>("lectureBox");
    _lecturesBox?.clear();
    _lecturesGroupsBox ?? await Hive.openBox<LecturesCache>("lecturesGroupBox");
    _lecturesGroupsBox?.clear();
  }

  static Future<void> closeBox() async {
    if (_lecturesBox?.isOpen ?? false) {
      await _lecturesBox?.close();
    }
    if (_lecturesGroupsBox?.isOpen ?? false) {
      await _lecturesGroupsBox?.close();
    }
  }

  static Future<Result<TableDays>> fetchTableTime({
    required int sectionId,
    required int levelId,
    bool hardFetch = false,
  }) async {
    LecturesCache? cachedDayLectures =
        _lecturesGroupsBox?.get("${sectionId}_${levelId}_Lectures");
    Map<String, Map<int, Lecture>> lectures = {};
    if ((cachedDayLectures != null) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      for (String day in cachedDayLectures.data.keys) {
        lectures[day] = {};
        for (int id in cachedDayLectures.data[day] ?? []) {
          Lecture? lecture =
              await fetchLecture(lectureId: id).then((e) => e.data);
          if (lecture != null) {
            lectures[day]?[lecture.id] = lecture;
          }
        }
      }
      return Result(
          data: TableDays.fromJson(lectures), hasError: false, statusCode: 200);
    }

    late Response? response;
    try {
      response = await HttpProvider.get(
          "lectures/grouped?section_id=$sectionId&level_id=$levelId");
      if (response?.statusCode == 200) {
        _lecturesGroupsBox?.delete("${sectionId}_${levelId}_Lectures");
        LecturesCache dayLectures =
            LecturesCache(key: "${sectionId}_${levelId}_Lectures", data: {});

        for (String day in (response?.data["data"] as Map).keys) {
          dayLectures.data[day] = [];
          lectures[day] = {};
          for (Map<String, dynamic> jsLecture in response?.data["data"][day]) {
            Subject? subject = await SubjectRepository.fetchSubject(
                    id: jsLecture["subject_id"])
                .then((e) => e.data);
            Lecture lecture = Lecture.fromJson(jsLecture, subject: subject);
            await _lecturesBox?.put(
              lecture.id,
              lecture,
            );
            dayLectures.data[day]?.add(lecture.id);
            lectures[day]?[lecture.id] = lecture;
          }
        }
        await _lecturesGroupsBox?.put(
          dayLectures.key,
          dayLectures,
        );
        return Result(
            data: TableDays.fromJson(lectures),
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

  static Future<Result<Lecture>> fetchLecture({
    required int lectureId,
    bool hardFetch = false,
  }) async {
    if ((_lecturesBox?.get(lectureId) != null) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      Lecture? lecture = _lecturesBox?.get(lectureId);
      return Result(data: lecture, hasError: false, statusCode: 200);
    }
    Response? response;
    try {
      response = await HttpProvider.get("");
      if (response?.statusCode == 200) {
        Lecture lecture = Lecture.fromJson(response?.data["lecture"]);
        await _lecturesBox?.put(
          lecture.id,
          lecture,
        );
        return Result(
            data: lecture,
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

  static Future<Result<Lecture>> createLecture({
    required int sectionId,
    required int levelId,
    required String day,
    required String subjectId,
    required String lectureTime,
    required int doctorId,
    required int lectureDuration,
    String? lectureRoom,
    bool withCache = true,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response = await HttpProvider.post("create-lecture", data: {
        "lecture_section_id": sectionId,
        "lecture_level_id": levelId,
        "lecture_day": day,
        "subject_id": subjectId,
        "doctor_id": doctorId,
        "lecture_time": DateTimeUtils.formatStringTime(
            time: lectureTime,
            format: TimeFormat.hhMmSs,
            currentFormat: TimeFormat.hhMmA),
        "lecture_duration": lectureDuration,
        "lecture_room": lectureRoom,
      });
      Lecture? newLecture;
      if (response?.statusCode == 201) {
        Subject? subject = await SubjectRepository.fetchSubject(
                id: response?.data["data"]["subject_id"])
            .then((e) => e.data);
        newLecture = Lecture.fromJson(response?.data["data"], subject: subject);
        if (withCache) {
          LecturesCache? cachedDayLectures = _lecturesGroupsBox
                  ?.get("${sectionId}_${levelId}_Lectures") ??
              LecturesCache(key: "${sectionId}_${levelId}_Lectures", data: {});
          cachedDayLectures.data[day]?.add(newLecture.id);
          await _lecturesBox?.put(newLecture.id, newLecture);
          await _lecturesGroupsBox?.put(
            cachedDayLectures.key,
            cachedDayLectures,
          );
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
    required String day,
    required String subjectId,
    required String lectureTime,
    required int doctorId,
    required int lectureDuration,
    String? lectureRoom,
    required id,
    bool hardFetch = false,
    bool withCache = true,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.put("update-lecture?id=$id", data: {
        "lecture_section_id": sectionId,
        "lecture_level_id": levelId,
        "lecture_day": day,
        "subject_id": sectionId,
        "doctor_id": doctorId,
        "lecture_time": lectureTime,
        "lecture_duration": lectureDuration,
        "lecture_room": lectureRoom,
      });

      if (response?.statusCode == 200) {
        Subject? subject = await SubjectRepository.fetchSubject(id: subjectId)
            .then((e) => e.data);
        Lecture updatedLecture =
            Lecture.fromJson(response?.data["data"], subject: subject);
        if (withCache) {
          await _lecturesBox?.put(updatedLecture.id, updatedLecture);
        }
        return Result(
            data: updatedLecture,
            statusCode: response?.statusCode ?? _updateError,
            message: response?.data["message"] ?? "error");
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
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
    required id,
    bool withCache = true,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.delete("delete-lecture?id=$id");
      if (response?.statusCode == 200 && withCache) {
        Lecture? lecture = _lecturesBox?.get(id);
        if (lecture != null) {
          _lecturesGroupsBox
              ?.get("${lecture.sectionId}_${lecture.levelId}_Lectures")
              ?.data
              .remove(id);
          _lecturesBox?.delete(id);
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
    required String action,
    required int id,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.post("changeLecStatus-lecture",
          data: {"id": id, "action": action});
      if (response?.statusCode == 200) {
        _lecturesBox?.get(id)?.lectureStatus = (action == "confirm")
            ? true
            : (action == "cancel")
                ? false
                : null;
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

// static Future<Result<Lecture>> fetchAllLecture() async {
//   Response? response;
//   try {
//     response = await HttpProvider.get("get-all-lecture");
//     Lecture? getLecture;
//     if (response?.statusCode == 200) {
//       getLecture = Lecture.fromJson(response?.data["data"]);
//     }
//     return Result(
//         data: getLecture,
//         hasError: true,
//         statusCode: response?.statusCode ?? _updateError,
//         message: response?.data["message"] ?? "error");
//   } catch (error) {
//     return Result(
//         hasError: true,
//         statusCode: _fetchError,
//         message: error.toString(),
//         data: null);
//   }
// }

  static Future<Result<Map>> fetchDashboardLecture({
    int? sectionId,
    int? levelId,
    int limit = 20,
    int? page,
    String? year,
    // String? term,
    String? day,
    String? order,
    String? sort,
    String? search,
    bool hardFetch = false,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.get(
        "lectures/panle?section_id=${sectionId ?? ''}&level_id=${levelId ?? ''}&year=${year ?? ''}&day=${day ?? ''}&orderBy=${order ?? ''}&sort=${sort ?? ''}&limit=$limit&search=${search ?? ''}&page=$page",
      );
      Map<int, Lecture> lectures = {};

      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsLecture in response?.data['data']) {
          Subject? subject =
              await SubjectRepository.fetchSubject(id: jsLecture["subject_id"])
                  .then((e) => e.data);
          lectures[jsLecture['id']] =
              Lecture.fromJson(jsLecture, subject: subject);
        }
        return Result(
            data: {
              "lectures": lectures,
              "totalLectures": response?.data["pagination"]["totalLectures"],
            },
            hasError: false,
            statusCode: response?.statusCode ?? _updateError,
            message: response?.data["message"] ?? "error");
      }
      return Result(
          data: {
            "lectures": lectures,
            "totalLectures": 0,
          },
          hasError: false,
          statusCode: response?.statusCode ?? _updateError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<Lecture>> tempReplaceLecture({
    required id,
    required int doctorId,
    required String subjectId,
    required String lectureTime,
    required String lectureRoom,
    required int lectureDuration,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.post("replaceOne-lecture?id=$id", data: {
        "subject_id": subjectId,
        "doctor_id": doctorId,
        "lecture_time": lectureTime,
        "lecture_duration": lectureDuration
      });

      Lecture? newLecture;
      if (response?.statusCode == 200) {
        Subject? subject = await SubjectRepository.fetchSubject(
                id: response?.data["replacedLecture"]["subject_id"])
            .then((e) => e.data);
        newLecture = Lecture.fromJson(response?.data["replacedLecture"],
            subject: subject);

        Lecture? lecture = _lecturesBox?.get(id);
        _lecturesBox?.put(newLecture.id, newLecture);
        if (lecture != null) {
          _lecturesGroupsBox
              ?.get("${lecture.sectionId}_${lecture.levelId}_Lectures")
              ?.data[lecture.day]
              ?.add(newLecture.id);
          _lecturesGroupsBox
              ?.get("${lecture.sectionId}_${lecture.levelId}_Lectures")
              ?.data[lecture.day]
              ?.remove(id);
        }
        return Result(
            data: newLecture,
            hasError: true,
            statusCode: response?.statusCode ?? _updateError,
            message: response?.data["message"] ?? "error");
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
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
    Box lecturesYearsBox = await Hive.openBox<List<String>>("lectureYearsBox");
    List<String>? years = lecturesYearsBox.get("lectureYears");
    if ((years != null) && (!hardFetch || !(await checkInternetConnection()))) {
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
        await lecturesYearsBox.put("lectureYears", years);
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

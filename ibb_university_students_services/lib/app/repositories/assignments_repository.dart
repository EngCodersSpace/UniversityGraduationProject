import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import '../models/assignment_model/assignment_model.dart';
import '../models/helper_models/assignments_cache/assignments_cache.dart';
import '../models/helper_models/result.dart';
import '../models/subject_model/subject_model.dart';
import '../services/http_provider/http_provider.dart';
import '../utils/internet_connection_cheker.dart';

class AssignmentsRepository {
  static const int _fetchAllError = 621;
  static const int _fetchError = 622;
  static const int _createError = 623;
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
        cachedAssignments =
            AssignmentsCache(
                key: "${sectionId}_${levelId}_${year}_${subjectId}_Assignments",
                data: {});
        for (Map<String, dynamic> jsAssignments in response?.data["data"]) {
          {
            Assignment assignment = Assignment.fromJson(jsAssignments);
            cachedAssignments.data[assignment.id] = assignment;
          }
          await _assignmentsBox?.put(
            cachedAssignments.key,
            cachedAssignments,
          );
                }
        print("data ${cachedAssignments?.data}");
        return Result(
            data: cachedAssignments?.data,
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

  // static Future<Result<Lecture>> createLecture({
  //   required int sectionId,
  //   required int levelId,
  //   required String year,
  //   required String term,
  //   required String day,
  //   required data,
  //   bool hardFetch = false,
  // }) async {
  //   get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
  //   late Response? response;
  //   try {
  //     response = await HttpProvider.post("create-lecture", data: data);
  //     Lecture? newLecture;
  //     if (response?.statusCode == 201) {
  //       Subject? subject = await SubjectRepository.fetchSubject(
  //               id: response?.data["data"]["subject_id"])
  //           .then((e) => e.data);
  //       newLecture = Lecture.fromJson(response?.data["data"], subject: subject);
  //       AssignmentsCache? cachedDayAssignments = _lecturesBox?.get(
  //           "${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Assignments");
  //       cachedDayAssignments?.data[day]?[newLecture.id] = newLecture;
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
  //         data: newLecture,
  //         hasError: true,
  //         statusCode: response?.statusCode ?? _createError,
  //         message: response?.data["message"] ?? "error");
  //   } catch (error) {
  //     return Result(
  //         hasError: true,
  //         statusCode: _createError,
  //         message: error.toString(),
  //         data: null);
  //   }
  // }
  //
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
  // static Future<Result<void>> deleteLecture({
  //   required int sectionId,
  //   required int levelId,
  //   required String year,
  //   required String term,
  //   required String day,
  //   required id,
  //   bool hardFetch = false,
  // }) async {
  //   get_x.Get.dialog(const PopUpLoadingCard(),
  //       barrierDismissible: false, name: "loadingDialog");
  //   late Response? response;
  //   try {
  //     AssignmentsCache? cachedDayAssignments = _lecturesBox?.get(
  //         "${sectionId}_${levelId}_${year}_${term.replaceAll(' ', '_')}_Assignments");
  //
  //     response = await HttpProvider.delete("delete-lecture?id=$id");
  //     if (response?.statusCode == 200) {
  //       cachedDayAssignments?.data[day]?.remove(id);
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
  //         hasError: false,
  //         statusCode: response?.statusCode ?? _deleteError,
  //         message: response?.data["message"] ?? "error");
  //   } catch (error) {
  //     return Result(
  //         hasError: true,
  //         statusCode: _deleteError,
  //         message: error.toString(),
  //         data: null);
  //   }
  // }
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

  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
// fake data

  static Future<Result<Map<int, Assignment>?>> fetchFakeAssignments({
    required String subjectId,
    bool hardFetch = false,
  }) async {
    if (_assignments?[subjectId] != null && !hardFetch) {
      return Result(
        data: _assignments?[subjectId],
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    for (String jsSubjectId in fakeAssignments.keys) {
      Subject? subject =
          await SubjectRepository.fetchSubject(id: jsSubjectId).then((e) {
        return e.data;
      });

      for (Map<String, dynamic> jsAssignment
          in fakeAssignments[jsSubjectId] ?? []) {
        Assignment assignment =
            Assignment.fromJson(jsAssignment, subject: subject);
        _assignments?[jsSubjectId]?[assignment.id] = assignment;
      }
    }
    return Result(
      data: _assignments?[subjectId],
      statusCode: 200,
      hasError: false,
      message: "successful",
    );
  }

  static Future<Result<List<String>>> fetchFakeAssignmentsSubjects(
      {bool hardFetch = false}) async {
    if (_assignments != null && !hardFetch) {
      return Result(
        data: _assignments?.keys.toList() ?? [],
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    _assignments = {};
    for (String jsSubjectId in fakeAssignments.keys) {
      Subject? subject =
          await SubjectRepository.fetchSubject(id: jsSubjectId).then((e) {
        return e.data;
      });
      _assignments?[jsSubjectId] = {};
      for (Map<String, dynamic> jsAssignment
          in fakeAssignments[jsSubjectId] ?? []) {
        Assignment assignment =
            Assignment.fromJson(jsAssignment, subject: subject);
        _assignments?[jsSubjectId]?[assignment.id] = assignment;
      }
    }
    return Result(
      data: _assignments?.keys.toList() ?? [],
      statusCode: 200,
      hasError: false,
      message: "successful",
    );
  }

  static Map<String, List<Map<String, dynamic>>> fakeAssignments = {
    "acerbitas-": [
      {
        "id": 1,
        "subject_id": "acerbitas-",
        "doctor_id": 79,
        "title": "Renewable Energy Assignment 1",
        "assignment_day": "Monday",
        "assignment_date": "2024-02-01",
        "assignments_due_date": "2024-02-08",
        "attachment": "renewable_energy_intro.pdf"
      },
      {
        "id": 2,
        "subject_id": "acerbitas-",
        "doctor_id": 79,
        "title": "Renewable Energy Case Study",
        "assignment_day": "Tuesday",
        "assignment_date": "2024-02-02",
        "assignments_due_date": "2024-02-09",
        "attachment": "renewable_case_study.pdf"
      },
      {
        "id": 3,
        "subject_id": "acerbitas-",
        "doctor_id": 79,
        "title": "Renewable Energy Lab Task",
        "assignment_day": "Wednesday",
        "assignment_date": "2024-02-03",
        "assignments_due_date": "2024-02-10",
        "attachment": "renewable_lab_task.pdf"
      }
    ],
    "adiuvo-lab": [
      {
        "id": 4,
        "subject_id": "adiuvo-lab",
        "doctor_id": 54,
        "title": "Materials Science Homework",
        "assignment_day": "Thursday",
        "assignment_date": "2024-02-04",
        "assignments_due_date": "2024-02-11",
        "attachment": "materials_science_lab.docx"
      },
      {
        "id": 5,
        "subject_id": "adiuvo-lab",
        "doctor_id": 54,
        "title": "Materials Science Group Project",
        "assignment_day": "Saturday",
        "assignment_date": "2024-02-06",
        "assignments_due_date": "2024-02-13",
        "attachment": "materials_group_project.pdf"
      }
    ],
    "aegre-assu": [
      {
        "id": 6,
        "subject_id": "aegre-assu",
        "doctor_id": 11,
        "title": "Embedded Systems Design Task",
        "assignment_day": "Sunday",
        "assignment_date": "2024-02-07",
        "assignments_due_date": "2024-02-14",
        "attachment": "embedded_design_task.pdf"
      }
    ],
    "agnosco-vo": [
      {
        "id": 7,
        "subject_id": "agnosco-vo",
        "doctor_id": 0,
        "title": "Advanced Mechanics Problem Set",
        "assignment_day": "Monday",
        "assignment_date": "2024-02-08",
        "assignments_due_date": "2024-02-15",
        "attachment": "advanced_mechanics_set.docx"
      },
      {
        "id": 8,
        "subject_id": "agnosco-vo",
        "doctor_id": 0,
        "title": "Advanced Mechanics Lab Task",
        "assignment_day": "Tuesday",
        "assignment_date": "2024-02-09",
        "assignments_due_date": "2024-02-16",
        "attachment": "advanced_mechanics_lab_task.pdf"
      }
    ],
    "ambitus-ca": [
      {
        "id": 9,
        "subject_id": "ambitus-ca",
        "doctor_id": 64,
        "title": "Fluid Mechanics Case Study",
        "assignment_day": "Wednesday",
        "assignment_date": "2024-02-10",
        "assignments_due_date": "2024-02-17",
        "attachment": "fluid_mechanics_case.pdf"
      }
    ],
    "amplitudo-": [
      {
        "id": 10,
        "subject_id": "amplitudo-",
        "doctor_id": 32,
        "title": "Power Systems Analysis Report",
        "assignment_day": "Thursday",
        "assignment_date": "2024-02-11",
        "assignments_due_date": "2024-02-18",
        "attachment": "power_systems_report.pdf"
      },
      {
        "id": 11,
        "subject_id": "amplitudo-",
        "doctor_id": 32,
        "title": "Power Systems Simulation Task",
        "assignment_day": "Saturday",
        "assignment_date": "2024-02-12",
        "assignments_due_date": "2024-02-19",
        "attachment": "power_systems_simulation.pdf"
      }
    ],
    "apostolus-": [
      {
        "id": 12,
        "subject_id": "apostolus-",
        "doctor_id": 23,
        "title": "Introduction to CS Assignment",
        "assignment_day": "Sunday",
        "assignment_date": "2024-02-13",
        "assignments_due_date": "2024-02-20",
        "attachment": "cs101_assignment.pdf"
      },
      {
        "id": 13,
        "subject_id": "apostolus-",
        "doctor_id": 23,
        "title": "CS Group Discussion Task",
        "assignment_day": "Monday",
        "assignment_date": "2024-02-14",
        "assignments_due_date": "2024-02-21",
        "attachment": "cs_group_discussion.pdf"
      },
      {
        "id": 14,
        "subject_id": "apostolus-",
        "doctor_id": 23,
        "title": "CS Final Project",
        "assignment_day": "Tuesday",
        "assignment_date": "2024-02-15",
        "assignments_due_date": "2024-02-22",
        "attachment": "cs_final_project.pdf"
      }
    ]
  };
}

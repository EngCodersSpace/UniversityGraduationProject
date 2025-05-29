import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/academic_card_controller.dart';
import 'package:ibb_university_students_services/app/controllers/exam_table_controller.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/controllers/news_controller.dart';
import 'package:ibb_university_students_services/app/controllers/student_fees_controller.dart';
import 'package:ibb_university_students_services/app/controllers/student_result_controller.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/lecture_table_tab_view_controller.dart';
import 'package:ibb_university_students_services/app/models/data_sync/data_sync.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import 'package:ibb_university_students_services/app/repositories/assignments_repository.dart';
import 'package:ibb_university_students_services/app/repositories/data_sync_repository.dart';
import 'package:ibb_university_students_services/app/repositories/exam_repository.dart';
import 'package:ibb_university_students_services/app/repositories/grad_repository.dart';
import 'package:ibb_university_students_services/app/repositories/lecture_repository.dart';
import 'package:ibb_university_students_services/app/repositories/library_repository.dart';
import 'package:ibb_university_students_services/app/repositories/news_repository.dart';
import 'package:ibb_university_students_services/app/repositories/student_fee_repository.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';

import '../models/library_files_model/library_files_model.dart';

class DataSyncServices {
  static void startSync() async {
    Map<String, DataSync> lastDataSyncs =
        await DataSyncRepository.fetchLastDataSyncs().then((e) => e.data ?? {});
    await DataSyncRepository.openBox();
    for (DataSync dataSync in lastDataSyncs.values) {
      switch (dataSync.target) {
        case "book":
          await syncBooks(dataSync);
          break;
        case "assignment":
          await syncAssignments(dataSync);
          break;
        case "lecture":
          await syncLectures(dataSync);
          break;
        case "exam":
          await syncExams(dataSync);
          break;
        case "studentFees":
          await syncStudentFees(dataSync);
          break;
        case "studentGrades":
          await syncStudentDegrees(dataSync);
          break;
        case "news":
          await syncNews(dataSync);
          break;
      }
    }
    await DataSyncRepository.closeBox();
  }

  static Future<void> syncExams(DataSync dataSync) async {
    try {
      DataSync? oldDataSync =
          await DataSyncRepository.fetchCachedDataSyncRecord(id: dataSync.id)
              .then((e) => e.data);
      if (oldDataSync == null ||
          DateTimeUtils.stringDataIsAfter(
              dataSync.updatedAt ?? "", oldDataSync.updatedAt ?? "")) {
        if (dataSync.filters?["section_id"] == null ||
            dataSync.filters?["level_id"] == null) {
          return;
        }
        await ExamRepository.openBox();
        await ExamRepository.fetchExamsGroup(
            sectionId: dataSync.filters?["section_id"],
            levelId: dataSync.filters?["level_id"],
            hardFetch: true);
        if (Get.isRegistered<ExamTableController>()) {
          await Get.find<ExamTableController>().fetchExamsData();
        }
        await DataSyncRepository.cacheDataSyncRecord(state: dataSync);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<void> syncLectures(DataSync dataSync) async {
    try {
      DataSync? oldDataSync =
          await DataSyncRepository.fetchCachedDataSyncRecord(id: dataSync.id)
              .then((e) => e.data);
      if (oldDataSync == null ||
          DateTimeUtils.stringDataIsAfter(
              dataSync.updatedAt ?? "", oldDataSync.updatedAt ?? "")) {
        await DataSyncRepository.cacheDataSyncRecord(state: dataSync);
        if (dataSync.filters?["section_id"] == null ||
            dataSync.filters?["level_id"] == null) {
          return;
        }
        await LectureRepository.openBox();
        await LectureRepository.fetchTableTime(
            sectionId: dataSync.filters?["section_id"],
            levelId: dataSync.filters?["level_id"],
            hardFetch: true);
        if (Get.isRegistered<LectureController>()) {
          await Get.find<LectureController>().fetchTableData();
        }
        await DataSyncRepository.cacheDataSyncRecord(state: dataSync);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<void> syncAssignments(DataSync dataSync) async {
    try {
      DataSync? oldDataSync =
          await DataSyncRepository.fetchCachedDataSyncRecord(id: dataSync.id)
              .then((e) => e.data);
      if (oldDataSync == null ||
          DateTimeUtils.stringDataIsAfter(
              dataSync.updatedAt ?? "", oldDataSync.updatedAt ?? "")) {
        if (dataSync.filters?["section_id"] == null ||
            dataSync.filters?["level_id"] == null ||
            dataSync.filters?["subject_id"] == null ||
            dataSync.filters?["year"] == null) {
          return;
        }
        await AssignmentsRepository.openBox();
        await AssignmentsRepository.fetchAssignmentsGroup(
          sectionId: dataSync.filters?["section_id"],
          levelId: dataSync.filters?["level_id"],
          subjectId: dataSync.filters?["subject_id"],
          year: dataSync.filters?["year"],
          hardFetch: true,
        );
        if (Get.isRegistered<ExamTableController>()) {
          await Get.find<ExamTableController>().fetchExamsData();
        }
        await DataSyncRepository.cacheDataSyncRecord(state: dataSync);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<void> syncStudentDegrees(DataSync dataSync) async {
    try {
      DataSync? oldDataSync =
          await DataSyncRepository.fetchCachedDataSyncRecord(id: dataSync.id)
              .then((e) => e.data);
      if (oldDataSync == null ||
          DateTimeUtils.stringDataIsAfter(
              dataSync.updatedAt ?? "", oldDataSync.updatedAt ?? "")) {
        if (dataSync.filters?["student_id"] == null) {
          return;
        }
        await GradRepository.openBox();
        if (UserRepository.currentUserType() == Student) {
          await GradRepository.fetchStudentGrads(
            studentID: dataSync.filters?["student_id"],
            hardFetch: true,
            mode: 'self',
          );
        } else {
          await GradRepository.fetchStudentGrads(
            studentID: dataSync.filters?["student_id"],
            hardFetch: true,
            mode: 'doctor',
          );
        }
        if (Get.isRegistered<StudentResultController>()) {
          await Get.find<StudentResultController>().fetchStudentGrads();
        }
        await DataSyncRepository.cacheDataSyncRecord(state: dataSync);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<void> syncStudentFees(DataSync dataSync) async {
    try {
      DataSync? oldDataSync =
          await DataSyncRepository.fetchCachedDataSyncRecord(id: dataSync.id)
              .then((e) => e.data);
      if (oldDataSync == null ||
          DateTimeUtils.stringDataIsAfter(
              dataSync.updatedAt ?? "", oldDataSync.updatedAt ?? "")) {
        if (dataSync.filters?["student_id"] == null) {
          return;
        }
        await StudentFeeRepository.openBox();

        if (UserRepository.currentUserType() == Student) {
          await StudentFeeRepository.fetchStudentFees(
            studentId: dataSync.filters?["student_id"],
            hardFetch: true,
            mode: 'self',
          );
          await StudentFeeRepository.fetchLastStudentFee(
              studentId: dataSync.filters?["student_id"], hardFetch: true);
        } else {
          await StudentFeeRepository.fetchStudentFees(
            studentId: dataSync.filters?["student_id"],
            hardFetch: true,
            mode: 'doctor',
          );
        }
        if (Get.isRegistered<StudentFeeController>()) {
          await Get.find<StudentFeeController>().fetchStudentFees();
        }
        if (Get.isRegistered<AcademicCardController>()) {
          await Get.find<AcademicCardController>().refresh();
        }
        await DataSyncRepository.cacheDataSyncRecord(state: dataSync);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<void> syncBooks(DataSync dataSync) async {
    try {
      DataSync? oldDataSync =
          await DataSyncRepository.fetchCachedDataSyncRecord(id: dataSync.id)
              .then((e) => e.data);
      if (oldDataSync == null ||
          DateTimeUtils.stringDataIsAfter(
              dataSync.updatedAt ?? "", oldDataSync.updatedAt ?? "")) {
        await LibraryRepository.openBox();
        Map<String, RxMap<int, LibraryFile>> destination = {};
        await LibraryRepository.streamFetchLibraryFilesGroup(
          destination: destination,
          hardFetch: true,
        );
        if (Get.isRegistered<LibraryController>()) {
          await Get.find<LibraryController>().fetchLibraryData();
        }
        await DataSyncRepository.cacheDataSyncRecord(state: dataSync);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<void> syncNews(DataSync dataSync) async {
    try {
      DataSync? oldDataSync =
          await DataSyncRepository.fetchCachedDataSyncRecord(id: dataSync.id)
              .then((e) => e.data);
      if (oldDataSync == null ||
          DateTimeUtils.stringDataIsAfter(
              dataSync.updatedAt ?? "", oldDataSync.updatedAt ?? "")) {
        await NewsRepository.openBox();
        await NewsRepository.fetchNews();
        if (Get.isRegistered<NewsController>()) {
          await Get.find<NewsController>().fetchNews();
        }
        await DataSyncRepository.cacheDataSyncRecord(state: dataSync);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

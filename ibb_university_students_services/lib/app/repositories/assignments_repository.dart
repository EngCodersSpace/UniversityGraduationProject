import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart' as get_x;
import 'package:ibb_university_students_services/app/models/attachment_file_model/attachment_file_model.dart';
import 'package:ibb_university_students_services/app/models/helper_models/student_assignment_state/student_assignment_state.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/utils/file_utils.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/assignment_model/assignment_model.dart';
import '../models/doctor_model/doctor.dart';
import '../models/helper_models/assignments_cache/assignments_cache.dart';
import '../models/helper_models/result.dart';
import '../models/student_assignments_file_model/student_assignments_file_model.dart';
import '../models/subject_model/subject_model.dart';
import '../services/http_provider.dart';
import '../services/notification_services.dart';
import '../utils/internet_connection_cheker.dart';

class AssignmentsRepository {
  static const int _fetchAllError = 621;
  static const int _fetchError = 622;
  static const int _createError = 623;
  static const int _updateError = 624;
  static const int _deleteError = 625;

  static Box<AssignmentsCache>? _assignmentsGroupsBox;
  static Box<Assignment>? _assignmentsBox;
  static Box<List<String>>? _assignmentsYearsBox;

  static Future<void> openBox() async {
    _assignmentsGroupsBox =
        await Hive.openBox<AssignmentsCache>("assignmentsGroupsBox");
    _assignmentsBox = await Hive.openBox<Assignment>("assignmentsBox");
    _assignmentsYearsBox = await Hive.openBox<List<String>>("assignmentsYearsBox");
  }

  static Future<void> clearBox() async {
    _assignmentsGroupsBox =
        await Hive.openBox<AssignmentsCache>("assignmentsGroupsBox");
    await _assignmentsGroupsBox?.clear();
    _assignmentsBox = await Hive.openBox<Assignment>("assignmentsBox");
    await _assignmentsBox?.clear();
  }

  static Future<void> closeBox() async {
    if (_assignmentsGroupsBox?.isOpen ?? false) {
      await _assignmentsGroupsBox?.close();
    }
    if (_assignmentsGroupsBox?.isOpen ?? false) {
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
    AssignmentsCache? cachedAssignments = _assignmentsGroupsBox
        ?.get("${sectionId}_${levelId}_${year}_${subjectId}_Assignments");
    Map<int, Assignment> assignments = {};
    if ((cachedAssignments != null) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      for (int id in cachedAssignments.data) {
        Assignment? assignment =
            await fetchAssignment(assignmentId: id).then((e) => e.data);
        if (assignment != null) {
          assignments[assignment.id] = assignment;
        }
      }
      return Result(data: assignments, hasError: false, statusCode: 200);
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          (UserRepository.currentUserType() == Doctor)?"get-assignments-subject-doctor?subject_id=$subjectId-th&level_id=$levelId&section_id=$sectionId&year=$year":"get-assignments-subject-student?subject_id=$subjectId-th&level_id=$levelId&section_id=$sectionId");
      if (response?.statusCode == 200) {
        cachedAssignments = AssignmentsCache(
            key: "${sectionId}_${levelId}_${year}_${subjectId}_Assignments",
            data: []);
        for (Map<String, dynamic> jsAssignments in response?.data["data"]) {
          {
            Subject? subject = await SubjectRepository.fetchSubject(
                    id: jsAssignments["subject_id"])
                .then((e) => e.data);
            Assignment assignment =
                Assignment.fromJson(jsAssignments, subject: subject);

            assignments[assignment.id] = assignment;
            await _assignmentsBox?.put(
              assignment.id,
              assignment,
            );
            cachedAssignments.data.add(assignment.id);
          }
          await _assignmentsGroupsBox?.put(
            "${sectionId}_${levelId}_${year}_${subjectId}_Assignments",
            cachedAssignments,
          );
        }
        return Result(
            data: assignments,
            hasError: false,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }

      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode ?? _fetchAllError,
          message: response?.statusMessage ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchAllError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<Assignment>> fetchAssignment({
    required int assignmentId,
    bool hardFetch = false,
  }) async {
    if ((_assignmentsBox?.get(assignmentId) != null) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      Assignment? assignment = _assignmentsBox?.get(assignmentId);
      return Result(data: assignment, hasError: false, statusCode: 200);
    }
    Response? response;
    try {
      response = await HttpProvider.get("");
      if (response?.statusCode == 200) {
        Assignment assignment =
            Assignment.fromJson(response?.data["assignment"]);
        await _assignmentsBox?.put(
          assignment.id,
          assignment,
        );
        return Result(
            data: assignment,
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

  static Future<Result<List<String>>> fetchAssignmentYears({
    bool hardFetch = false,
    bool withCache = true,
  }) async {
    if ((_assignmentsYearsBox?.isNotEmpty??false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      if(withCache){

      }
      return Result(data: [], hasError: false, statusCode: 200);
    }
    Response? response;
    try {
      response = await HttpProvider.get("");
      if (response?.statusCode == 200) {
        await _assignmentsYearsBox?.put("years",[]
        );
        return Result(
            data: [],
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

  static Future<Result<List<StudentAssignmentState>>> fetchAssignmentStudents({
    required int assignmentId,
    bool hardFetch = false,
  }) async {
    if ((_assignmentsBox?.get(assignmentId)?.studentsStatus?.isNotEmpty ??
            false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
          data: _assignmentsBox
              ?.get(assignmentId)
              ?.studentsStatus
              ?.values
              .toList(),
          hasError: false,
          statusCode: 200);
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-all-students-assignment?assignment_id=$assignmentId");
      Map<int, StudentAssignmentState> state = {};
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsState in response?.data["data"]) {
          state[jsState["id"]] = StudentAssignmentState.fromJson(jsState);
        }
        _assignmentsBox?.get(assignmentId)?.studentsStatus = state;

        return Result(
            data: _assignmentsBox
                ?.get(assignmentId)
                ?.studentsStatus
                ?.values
                .toList(),
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

  static Future<Result<Assignment>> createAssignment(
      {required int sectionId,
      required int levelId,
      required String subjectId,
      required String title,
      required String assignmentDate,
      required String assignmentsDueDate,
      required List<Map<String, int>> sectionsAndLevels,
      bool withCache = true,
      String year = ""}) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response = await HttpProvider.post("upload-assignment-doctor", data: {
        "subject_id": subjectId,
        "title": title,
        "assignment_due_day": "Sun",
        "assignment_date": assignmentDate,
        "assignments_due_date": assignmentsDueDate,
        "sectionsAndLevels": sectionsAndLevels
      });
      Assignment? newAssignment;
      if (response?.statusCode == 201) {
        int i = 0;
        for (Map group in sectionsAndLevels) {
          Assignment assignment =
              Assignment.fromJson(response?.data["data"][i]);
          if (group["section_id"] == sectionId &&
              group["level_id"] == levelId) {
            newAssignment = assignment;
          }
          if (withCache) {
            AssignmentsCache? cachedAssignmentsGroups = _assignmentsGroupsBox?.get(
                "${group["section_id"]}_${group["level_id"]}_${year}_${subjectId}_Assignments");
            cachedAssignmentsGroups ??
                AssignmentsCache(
                    key:
                        "${sectionId}_${levelId}_${year}_${subjectId}_Assignments",
                    data: []);
            await _assignmentsBox?.put(
              assignment.id,
              assignment,
            );
            cachedAssignmentsGroups?.data.add(assignment.id);
            if (cachedAssignmentsGroups != null) {
              await _assignmentsGroupsBox?.put(
                  "${sectionId}_${levelId}_${year}_${subjectId}_Assignments",
                  cachedAssignmentsGroups);
            }
          }
          i++;
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

  static Future<Result<Assignment>> updateAssignment(
      {required int id,
      required int sectionId,
      required int levelId,
      required String subjectId,
      required String title,
      required String assignmentDate,
      required String assignmentsDueDate,
      required List<Map<String, int>> sectionsAndLevels,
      bool withCache = true,
      String year = ""}) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response =
          await HttpProvider.put("update-assignment?assignment_id=$id", data: {
        "subject_id": subjectId,
        "title": title,
        "assignment_due_day": "Sun",
        "assignment_date": assignmentDate,
        "assignments_due_date": assignmentsDueDate,
        "sectionsAndLevels": sectionsAndLevels
      });
      if (response?.statusCode == 200) {
        if(withCache){
          _assignmentsBox?.get(id)?.updateFromJson(response?.data["data"]);
          return Result(
              data: _assignmentsBox?.get(id),
              hasError: true,
              statusCode: response?.statusCode ?? _createError,
              message: response?.data["message"] ?? "error");
        }
        return Result(
            data: Assignment.fromJson(response?.data["data"]),
            hasError: true,
            statusCode: response?.statusCode ?? _createError,
            message: response?.data["message"] ?? "error");

      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: null,
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

  static Future<Result<void>> deleteAssignment({
    required id,
    String year = "",
    bool withCache = true,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response =
          await HttpProvider.delete("delete-assignment?assignment_id=$id");
      if (response?.statusCode == 200 && withCache) {
        Assignment? assignment = _assignmentsBox?.get(id);
        if (assignment != null) {
          _assignmentsGroupsBox
              ?.get(
                  "${assignment.sectionId}_${assignment.levelId}_${year}_${assignment.subject?.id}_Assignments")
              ?.data
              .remove(id);
        }
        _assignmentsBox?.delete(id);
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

  static Future<Result<int>> uploadAttachmentFiles({
    required AttachmentFile attachment,
    required int sectionId,
    required int levelId,
  }) async {
    late Response? response;
    try {
      File file = File(attachment.path ?? "");
      int fileSize = await file.length();
      response = await HttpProvider.post("check-files", data: {
        "originalname": attachment.path?.split("/").last,
        "size": fileSize.toString(),
        "mimetype": "text/plain",
        "section_id": sectionId,
        "level_id": levelId
      });

      if (response?.statusCode == 200) {
        attachment.progress = get_x.RxInt(0);
        attachment.status?.value = "Uploading";
        response = null;
        response = await HttpProvider.uploadFile(
          uploadUrl:
              "upload-files-assignment-doctor?assignment_id=${attachment.assignmentId}",
          file: file,
          onSendProgress: (sent, total) {
            double progress = (sent / total) * 100;
            attachment.progress?.value = progress.toInt();
            NotificationHandler.showProgressNotification(
                uniqueId: attachment.id.hashCode,
                progress: progress.toInt(),
                title: "Uploading",
                message: " ${file.path.split("/").last}");
          },
        );
        if (response?.statusCode == 201) {
          attachment.path = response?.data["file"]["path"];
          await FileUtils.saveFiles(
              fileRelativePath: attachment.path, file: file);
          NotificationHandler.showProgressNotification(
              uniqueId: attachment.id.hashCode,
              title: "successful upload ",
              message: attachment.originName);
          attachment.id = response?.data["file"]["id"];
          attachment.status?.value = "Uploaded";
        } else {
          NotificationHandler.showProgressNotification(
              uniqueId: attachment.id.hashCode,
              title: "failed upload ",
              message: attachment.originName);
        }
        return Result(
            data: attachment.id,
            hasError: false,
            statusCode: response?.statusCode ?? _createError,
            message: response?.data["message"] ?? "error");
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      showSnakeBar(message: "Failed Upload");
      return Result(
          hasError: true,
          statusCode: response?.statusCode ?? _createError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          statusCode: _createError, message: error.toString(), data: null);
    }
  }

  static Future<Result<void>> downloadAttachmentFiles({
    required AttachmentFile file,
  }) async {
    late Response? response;
    try {
      file.progress = get_x.RxInt(0);
      file.status ??= get_x.RxString("");
      file.status?.value = "Downloading";
      response = await HttpProvider.downloadFile(
        downloadUrl: "download-files-doctor?id=${file.id}",
        savePath: "${FileUtils.defaultBaseFolderPath}/${file.path}",
        onReceiveProgress: (sent, total) {
          double progress = (sent / total) * 100;
          file.progress?.value = progress.toInt();
          NotificationHandler.showProgressNotification(
              uniqueId: file.id.hashCode,
              progress: progress.toInt(),
              title: "Downloading",
              message: " ${file.originName}");
        },
      );
      if (response?.statusCode == 200) {
        await file.checkDownloaded();
        if (file.downloaded.value) {
          await NotificationHandler.showProgressNotification(
              uniqueId: file.id.hashCode,
              title: "Successful Downloaded ",
              message: file.originName);
          showSnakeBar(
              title: "Download Successful",
              message: "Downloading ${file.originName} Successful");
        } else {
          NotificationHandler.showProgressNotification(
              uniqueId: file.id.hashCode,
              title: "Download Failed ",
              message: file.originName);
          showSnakeBar(message: "Downloading ${file.originName} Failed");
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      } else {
        file.status?.value = "Download Failed";
        NotificationHandler.showProgressNotification(
            uniqueId: file.id.hashCode,
            title: "Download Failed ",
            message: file.originName);
        showSnakeBar(message: "Downloading ${file.originName} Failed");
      }
      file.status?.value = "None";
      return Result(
          hasError: false, statusCode: response?.statusCode ?? _createError);
    } catch (error) {
      return Result(
          statusCode: _createError, message: error.toString(), data: null);
    }
  }

  static Future<Result<int>> uploadStudentAssignmentsFiles({
    required StudentAssignmentsFile files,
    required int sectionId,
    required int levelId,
    required int assignmentId,
  }) async {
    late Response? response;
    try {
      File file = File(files.path ?? "");
      int fileSize = await file.length();
      response = await HttpProvider.post("check-files", data: {
        "originalname": files.path?.split("/").last,
        "size": fileSize.toString(),
        "mimetype": "text/plain",
        "section_id": sectionId,
        "level_id": levelId
      });

      if (response?.statusCode == 200) {
        files.progress = get_x.RxInt(0);
        files.status?.value = "Uploading";
        response = null;
        response = await HttpProvider.uploadFile(
          uploadUrl:
              "upload-files-assignment-student?assignment_id=$assignmentId&section_id=$sectionId&level_id=$levelId",
          file: file,
          onSendProgress: (sent, total) {
            double progress = (sent / total) * 100;
            files.progress?.value = progress.toInt();
            NotificationHandler.showProgressNotification(
                uniqueId: files.id.hashCode,
                progress: progress.toInt(),
                title: "Uploading",
                message: " ${file.path.split("/").last}");
          },
        );
        if (response?.statusCode == 201) {
          files.path = response?.data["file"]["path"];
          await FileUtils.saveFiles(fileRelativePath: files.path, file: file);
          await NotificationHandler.showProgressNotification(
              uniqueId: files.id.hashCode,
              title: "successful upload ",
              message: files.originName);
          files.id = response?.data["file"]["id"];
          files.status?.value = "Uploaded";
        } else {
          files.status?.value = "Failed";
          NotificationHandler.showProgressNotification(
              uniqueId: files.id.hashCode,
              title: "failed upload ",
              message: files.originName);
        }
        return Result(
            data: files.id,
            hasError: false,
            statusCode: response?.statusCode ?? _createError,
            message: response?.data["message"] ?? "error");
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      showSnakeBar(message: "Failed Upload");
      return Result(
          hasError: true,
          statusCode: response?.statusCode ?? _createError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          statusCode: _createError, message: error.toString(), data: null);
    }
  }

  static Future<Result<int>> downloadStudentAssignmentsFiles({
    required StudentAssignmentsFile file,
    required int sectionId,
    required int levelId,
  }) async {
    late Response? response;
    try {
      file.progress = get_x.RxInt(0);
      file.status?.value = "Downloading";
      response = await HttpProvider.downloadFile(
        downloadUrl: "download-assignment-files?id=${file.id}",
        savePath: "${FileUtils.defaultBaseFolderPath}/${file.path}",
        onReceiveProgress: (sent, total) {
          double progress = (sent / total) * 100;
          file.progress?.value = progress.toInt();
          NotificationHandler.showProgressNotification(
              uniqueId: file.id.hashCode,
              progress: progress.toInt(),
              title: "Downloading",
              message: " ${file.originName}");
        },
      );
      if (response?.statusCode == 200) {
        await file.checkDownloaded();
        if (file.downloaded.value) {
          await NotificationHandler.showProgressNotification(
              uniqueId: file.id.hashCode,
              title: "Successful Downloaded ",
              message: file.originName);
          showSnakeBar(
              title: "Download Successful",
              message: "Downloading ${file.originName} Successful");
        } else {
          NotificationHandler.showProgressNotification(
              uniqueId: file.id.hashCode,
              title: "Download Failed ",
              message: file.originName);
          showSnakeBar(message: "Downloading ${file.originName} Failed");
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      } else {
        file.status?.value = "Download Failed";
        NotificationHandler.showProgressNotification(
            uniqueId: file.id.hashCode,
            title: "Failed Downloaded ",
            message: file.originName);
        showSnakeBar(message: "Downloading ${file.originName} Failed");
      }
      file.status?.value = "None";
      return Result(
          data: file.id,
          hasError: false,
          statusCode: response?.statusCode ?? _createError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          statusCode: _createError, message: error.toString(), data: null);
    }
  }

  static Future<Result<void>> deleteAssignmentFile({
    required int assignmentId,
    required id,
    bool withCache = true,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.delete(
          "delete-assignment-files?assignment_id=$id");
      if (response?.statusCode == 200 && withCache) {
        _assignmentsBox?.get(assignmentId)?.attachments?.remove(id);
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

  static Future<Result<void>> deleteStudentAssignmentFile({
    required int assignmentId,
    required id,
    bool withCache = true,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.delete(
          "delete-attachment-files?assignment_id=$id");
      if (response?.statusCode == 200 && withCache) {
        _assignmentsBox?.get(assignmentId)?.attachments?.remove(id);
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

  static Future<Result<void>> changeStudentState({
    required int id,
    required int studentId,
    required int stateId,
    required String state,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response = await HttpProvider.put(
          "update-student-assignment-status?id=$stateId&student_id=$studentId&status=$state");
      if (response?.statusCode == 200) {
        _assignmentsBox?.get(id)?.studentsStatus?[studentId]?.state =
            response?.data["data"]["status"];
        return Result(
            hasError: true,
            statusCode: response?.statusCode ?? _createError,
            message: response?.data["message"] ?? "error");
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: null,
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

  static Future<Result<void>> changeStudentCompletion({
    required int id,
    required int studentId,
    required int stateId,
    required bool state,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response = await HttpProvider.put(
          "update-student-assignment-complete?id=$stateId&student_id=$studentId&is_completed=$state");
      if (response?.statusCode == 200) {
        _assignmentsBox?.get(id)?.studentsStatus?[studentId]?.isCompleted =
            response?.data["data"]["is_completed"];
        return Result(
            hasError: true,
            statusCode: response?.statusCode ?? _createError,
            message: response?.data["message"] ?? "error");
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: null,
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
}

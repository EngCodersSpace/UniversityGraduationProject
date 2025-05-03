import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/library_files_model/library_files_model.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../models/helper_models/library_files_cache/library_files_cache.dart';
import '../models/helper_models/result.dart';
import '../models/subject_model/subject_model.dart';
import '../services/http_provider.dart';
import '../services/notification_services.dart';
import '../utils/file_utils.dart';
import '../utils/internet_connection_cheker.dart';
import '../utils/snake_bar.dart';

class LibraryRepository {
  static const int _fetchAllError = 621;
  static const int _fetchError = 622;

  // static const int _createError = 623;
  // static const int _updateError = 624;
  // static const int _deleteError = 625;
  static const int _uploadError = 626;

  static Box<LibraryFilesCache>? _libraryFilesGroupsBox;
  static Box<LibraryFile>? _libraryFilesBox;

  static Future<void> openBox() async {
    _libraryFilesGroupsBox =
        await Hive.openBox<LibraryFilesCache>("libraryFilesGroupsBox");
    _libraryFilesBox = await Hive.openBox<LibraryFile>("libraryFilesBox");
  }

  static Future<void> clearBox() async {
    _libraryFilesGroupsBox =
        await Hive.openBox<LibraryFilesCache>("libraryFilesGroupsBox");
    await _libraryFilesGroupsBox?.clear();
    _libraryFilesBox = await Hive.openBox<LibraryFile>("libraryFilesBox");
    await _libraryFilesBox?.clear();
  }

  static Future<void> closeBox() async {
    if (_libraryFilesGroupsBox?.isOpen ?? false) {
      await _libraryFilesGroupsBox?.close();
    }
    if (_libraryFilesGroupsBox?.isOpen ?? false) {
      await _libraryFilesBox?.close();
    }
  }

  static Future<Result<void>> streamFetchLibraryFilesGroup({
    required int sectionId,
    required int levelId,
    required String category,
    required get_x.RxMap<int, LibraryFile> destination,
    bool hardFetch = false,
  }) async {
    LibraryFilesCache? cachedLibrary = _libraryFilesGroupsBox
        ?.get("${sectionId}_${levelId}_${category}_Library");

    if ((cachedLibrary?.data.isNotEmpty ?? false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      for (int fileId in cachedLibrary?.data ?? []) {
        Result res = await fetchLibraryFile(id: fileId);
        if (res.statusCode == 200 && res.data != null) {
          destination[res.data.id] = res.data!;
        }
      }
      return Result(hasError: false, statusCode: 200);
    }

    try {
      Response? response = await HttpProvider.get(
        "/get-all-books-stream",
        options: Options(responseType: ResponseType.stream),
      );

      if (response?.data == null) {
        return Result(
          hasError: true,
          statusCode: response?.statusCode ?? _fetchAllError,
          message: "No data received",
        );
      }

      StringBuffer buffer = StringBuffer();

      await for (List<int> chunk in response?.data!.stream) {
        buffer.write(utf8.decode(chunk, allowMalformed: true));

        // Process all complete JSON objects
        List<String> parts = buffer.toString().split("\n---\n");

        for (int i = 0; i < parts.length - 1; i++) {
          String jsonChunk = parts[i].trim(); // Clean up whitespace

          if (jsonChunk.isNotEmpty) {
            try {
              final Map<String, dynamic> jsLibrary = jsonDecode(jsonChunk);

              Subject? subject = await SubjectRepository.fetchSubject(
                      id: jsLibrary["subject_id"])
                  .then((e) => e.data);

              LibraryFile libraryFile =
                  LibraryFile.fromJson(jsLibrary, subject: subject);
              destination[libraryFile.id] = libraryFile;
              await _libraryFilesBox?.put(libraryFile.id, libraryFile);
            } catch (e) {
              if (kDebugMode) {
                print("Error parsing JSON chunk: $e. Chunk: $jsonChunk");
              }
            }
          }
        }

        // Keep the last part (which may be incomplete) in the buffer
        buffer.clear();
        buffer.write(parts.last);
      }

      // Store the final cache
      LibraryFilesCache cachedLibrary = LibraryFilesCache(
          key: "${sectionId}_${levelId}_${category}_Library",
          data: destination.keys.toList());

      await _libraryFilesGroupsBox?.put(cachedLibrary.key, cachedLibrary);

      return Result(hasError: false, statusCode: response?.statusCode);
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchAllError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<LibraryFile>> fetchLibraryFile({
    required int id,
    bool hardFetch = false,
  }) async {
    if ((_libraryFilesBox?.get(id) != null) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
        data: _libraryFilesBox?.get(id),
        hasError: false,
        statusCode: 200,
      );
    }
    Response? response;
    try {
      response = await HttpProvider.get("");
      if (response?.statusCode == 200) {
        LibraryFile libraryFile =
            LibraryFile.fromJson(response?.data["assignment"]);
        await _libraryFilesBox?.put(
          libraryFile.id,
          libraryFile,
        );
        return Result(
            data: libraryFile,
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

  static Future<Result<Map>> fetchDashboardLibrary({
    bool hardFetch = false,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.get("url"); //get the url from bachend
      Map<int, LibraryFile> library = {};
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsLib in response?.data['data']) {
          library[jsLib["library_id"]] =
              LibraryFile.fromJson(jsLib); //get the name of id from backend
        }
        return Result(
          data: {
            "library": library,
            "totalbooks": response?.data["pagination"]
                ["totalbooks"], //get the name of id from backend
          },
          hasError: false,
          statusCode: response?.statusCode,
          message: response?.data["message"] ?? "error",
        );
      }
      return Result(
        data: {
          "library": library,
          "totalbooks": 0,
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
        data: null,
      );
    }
  }

//
// static Future<Result<Assignment>> createAssignment(
//     {required int sectionId,
//       required int levelId,
//       required String subjectId,
//       required String title,
//       required String assignmentDate,
//       required String assignmentsDueDate,
//       required List<Map<String, int>> sectionsAndLevels,
//       String year = ""}) async {
//   get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
//   late Response? response;
//   try {
//     response = await HttpProvider.post("upload-assignment-doctor", data: {
//       "subject_id": subjectId,
//       "title": title,
//       "assignment_due_day": "Sun",
//       "assignment_date": assignmentDate,
//       "assignments_due_date": assignmentsDueDate,
//       "sectionsAndLevels": sectionsAndLevels
//     });
//     Assignment? newAssignment;
//     if (response?.statusCode == 201) {
//       int i = 0;
//       for (Map group in sectionsAndLevels) {
//         Assignment assignment =
//         Assignment.fromJson(response?.data["data"][i]);
//         if (group["section_id"] == sectionId &&
//             group["level_id"] == levelId) {
//           newAssignment = assignment;
//         }
//         LibraryCache? cachedLibrary = _libraryFilesGroupsBox?.get(
//             "${group["section_id"]}_${group["level_id"]}_${year}_${subjectId}_Library");
//         cachedLibrary ??
//             LibraryCache(
//                 key:
//                 "${sectionId}_${levelId}_${year}_${subjectId}_Library",
//                 data: []);
//         await _libraryFilesBox?.put(
//           assignment.id,
//           assignment,
//         );
//         cachedLibrary?.data.add(assignment.id);
//         if (cachedLibrary != null) {
//           await _libraryFilesGroupsBox?.put(
//               "${sectionId}_${levelId}_${year}_${subjectId}_Library",
//               cachedLibrary);
//         }
//         i++;
//       }
//     } else if (response?.statusCode == 403) {
//       await get_x.Get.dialog(PopUpAlertCard(
//           response?.data["message"] ?? "UnAuthorized Action", Icons.block));
//     }
//     return Result(
//         data: newAssignment,
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
  static Future<Result<LibraryFile>> uploadLibraryFile({
    required PlatformFile file,
    required String category,
    required List<Map<String, int>> groups,
  }) async {
    late Response? response;
    try {
      File fileData = File(file.path ?? "");
      int fileSize = await fileData.length();
      response = await HttpProvider.post("checkFileDuplicate", data: {
        "originalname": file.path?.split("/").last,
        "size": fileSize.toString(),
        "mimetype": "text/plain",
        "section_id": groups.first["section_id"],
        "level_id": groups.first["level_id"]
      });

      if (response?.statusCode == 200) {
        response = null;
        response = await HttpProvider.uploadFile(
          uploadUrl:
              "upload?category=$category&section_id=${groups.first["section_id"]}&level_id=${groups.first["level_id"]}",
          file: fileData,
          onSendProgress: (sent, total) {
            double progress = (sent / total) * 100;
            NotificationHandler.showProgressNotification(
                uniqueId: file.path.hashCode,
                progress: progress.toInt(),
                title: "Uploading",
                message: " ${file.path?.split("/").last}");
          },
        );
        if (response?.statusCode == 201) {
          LibraryFile resFile = LibraryFile.fromJson(response?.data["books"]);
          await FileUtils.saveFiles(
              fileRelativePath: resFile.filePath, file: file);
          NotificationHandler.showProgressNotification(
            uniqueId: file.path.hashCode,
            title: "successful upload ",
            message: file.path?.split("/").last,
          );
          return Result(
              data: resFile,
              hasError: false,
              statusCode: response?.statusCode ?? _uploadError,
              message: response?.data["message"] ?? "error");
        } else {
          NotificationHandler.showProgressNotification(
            uniqueId: file.path.hashCode,
            title: "failed upload ",
            message: file.path?.split("/").last,
          );
        }
        return Result(
            data: null,
            hasError: false,
            statusCode: response?.statusCode ?? _uploadError,
            message: response?.data["message"] ?? "error");
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      showSnakeBar(message: "Failed Upload");
      return Result(
          hasError: true,
          statusCode: response?.statusCode ?? _uploadError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          statusCode: _uploadError, message: error.toString(), data: null);
    }
  }

// static Future<Result<Assignment>> updateAssignment(
//     {required int id,
//       required int sectionId,
//       required int levelId,
//       required String subjectId,
//       required String title,
//       required String assignmentDate,
//       required String assignmentsDueDate,
//       required List<Map<String, int>> sectionsAndLevels,
//       String year = ""}) async {
//   get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
//   late Response? response;
//   try {
//     response =
//     await HttpProvider.put("update-assignment?assignment_id=$id", data: {
//       "subject_id": subjectId,
//       "title": title,
//       "assignment_due_day": "Sun",
//       "assignment_date": assignmentDate,
//       "assignments_due_date": assignmentsDueDate,
//       "sectionsAndLevels": sectionsAndLevels
//     });
//     if (response?.statusCode == 200) {
//       _libraryFilesBox?.get(id)?.updateFromJson(response?.data["data"]);
//
//       return Result(
//           data: _libraryFilesBox?.get(id),
//           hasError: true,
//           statusCode: response?.statusCode ?? _createError,
//           message: response?.data["message"] ?? "error");
//     } else if (response?.statusCode == 403) {
//       await get_x.Get.dialog(PopUpAlertCard(
//           response?.data["message"] ?? "UnAuthorized Action", Icons.block));
//     }
//     return Result(
//         data: null,
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
// static Future<Result<void>> deleteAssignment({
//   required id,
//   String year = "",
//   bool hardFetch = false,
//   bool withCache = true,
// }) async {
//   get_x.Get.dialog(const PopUpLoadingCard(),
//       barrierDismissible: false, name: "loadingDialog");
//   late Response? response;
//   try {
//     response =
//     await HttpProvider.delete("delete-assignment?assignment_id=$id");
//     if (response?.statusCode == 200 && withCache) {
//       Assignment? assignment = _libraryFilesBox?.get(id);
//       if (assignment != null) {
//         _libraryFilesGroupsBox
//             ?.get(
//             "${assignment.sectionId}_${assignment.levelId}_${year}_${assignment.subject?.id}_Library")
//             ?.data
//             .remove(id);
//       }
//       _libraryFilesBox?.delete(id);
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
// static Future<Result<void>> deleteAssignmentFile({
//   required int assignmentId,
//   required id,
// }) async {
//   get_x.Get.dialog(const PopUpLoadingCard(),
//       barrierDismissible: false, name: "loadingDialog");
//   late Response? response;
//   try {
//     response = await HttpProvider.delete(
//         "delete-assignment-files?assignment_id=$id");
//     if (response?.statusCode == 200) {
//       _libraryFilesBox?.get(assignmentId)?.attachments?.remove(id);
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
// static Future<Result<void>> deleteStudentAssignmentFile({
//   required int assignmentId,
//   required id,
// }) async {
//   get_x.Get.dialog(const PopUpLoadingCard(),
//       barrierDismissible: false, name: "loadingDialog");
//   late Response? response;
//   try {
//     response = await HttpProvider.delete(
//         "delete-attachment-files?assignment_id=$id");
//     if (response?.statusCode == 200) {
//       _libraryFilesBox?.get(assignmentId)?.attachments?.remove(id);
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
// static Future<Result<void>> changeStudentState({
//   required int id,
//   required int studentId,
//   required int stateId,
//   required String state,
// }) async {
//   get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
//   late Response? response;
//   try {
//     response = await HttpProvider.put(
//         "update-student-assignment-status?id=$stateId&student_id=$studentId&status=$state");
//     if (response?.statusCode == 200) {
//       _libraryFilesBox?.get(id)?.studentsStatus?[studentId]?.state =
//       response?.data["data"]["status"];
//       return Result(
//           hasError: true,
//           statusCode: response?.statusCode ?? _createError,
//           message: response?.data["message"] ?? "error");
//     } else if (response?.statusCode == 403) {
//       await get_x.Get.dialog(PopUpAlertCard(
//           response?.data["message"] ?? "UnAuthorized Action", Icons.block));
//     }
//     return Result(
//         data: null,
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
// static Future<Result<void>> changeStudentCompletion({
//   required int id,
//   required int studentId,
//   required int stateId,
//   required bool state,
// }) async {
//   get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
//   late Response? response;
//   try {
//     response = await HttpProvider.put(
//         "update-student-assignment-complete?id=$stateId&student_id=$studentId&is_completed=$state");
//     if (response?.statusCode == 200) {
//       _libraryFilesBox?.get(id)?.studentsStatus?[studentId]?.isCompleted =
//       response?.data["data"]["is_completed"];
//       return Result(
//           hasError: true,
//           statusCode: response?.statusCode ?? _createError,
//           message: response?.data["message"] ?? "error");
//     } else if (response?.statusCode == 403) {
//       await get_x.Get.dialog(PopUpAlertCard(
//           response?.data["message"] ?? "UnAuthorized Action", Icons.block));
//     }
//     return Result(
//         data: null,
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
}

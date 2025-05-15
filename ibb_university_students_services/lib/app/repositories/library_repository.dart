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
import '../components/pop_up_cards/loading_card.dart';
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
  static const int _createError = 623;
  static const int _uploadError = 626;
  static const int _deleteError = 627;

  // static Box<LibraryFilesCache>? _libraryFilesGroupsBox;
  static Box<LibraryFile>? _libraryFilesBox;

  static Future<void> openBox() async {
    // _libraryFilesGroupsBox =
    //     await Hive.openBox<LibraryFilesCache>("libraryFilesGroupsBox");
    _libraryFilesBox = await Hive.openBox<LibraryFile>("libraryFilesBox");
  }

  static Future<void> clearBox() async {
    // _libraryFilesGroupsBox =
    //     await Hive.openBox<LibraryFilesCache>("libraryFilesGroupsBox");
    // await _libraryFilesGroupsBox?.clear();
    _libraryFilesBox = await Hive.openBox<LibraryFile>("libraryFilesBox");
    await _libraryFilesBox?.clear();
  }

  static Future<void> closeBox() async {
    // if (_libraryFilesGroupsBox?.isOpen ?? false) {
    //   await _libraryFilesGroupsBox?.close();
    // }
    if (_libraryFilesBox?.isOpen ?? false) {
      await _libraryFilesBox?.close();
    }
  }

  static Future<Result<void>> streamFetchLibraryFilesGroup({
    required int sectionId,
    required int levelId,
    required String category,
    required get_x.RxMap<String, get_x.RxMap<int, LibraryFile>> destination,
    bool hardFetch = false,
  }) async {
    // LibraryFilesCache? cachedLibrary = _libraryFilesGroupsBox
    //     ?.get("${sectionId}_${levelId}_${category}_Library");

    destination.value = {};
    if ((_libraryFilesBox?.isNotEmpty ?? false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      for (LibraryFile file in (_libraryFilesBox?.values ?? [])) {
        destination[file.category] ??= get_x.RxMap({});
        destination[file.category]?[file.id] = file;
      }
      return Result(hasError: false, statusCode: 200);
    }

    try {
      await _libraryFilesBox?.clear();
      Response? response = await HttpProvider.get(
        "/get-all-books-stream",
        options: Options(responseType: ResponseType.stream),
      );

      if (response?.statusCode == 204) {
        return Result(
          hasError: false,
          statusCode: response?.statusCode ?? _fetchAllError,
          message: "No data received",
        );
      } else if (response?.data == null) {
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

              Subject? subject;
              if (jsLibrary["subject_id"] != null) {
                subject = await SubjectRepository.fetchSubject(
                        id: jsLibrary["subject_id"])
                    .then((e) => e.data);
              }
              LibraryFile libraryFile =
                  LibraryFile.fromJson(jsLibrary, subject: subject);
              destination[libraryFile.category] ??= get_x.RxMap({});
              destination[libraryFile.category]?[libraryFile.id] = libraryFile;
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
      // LibraryFilesCache cachedLibrary = LibraryFilesCache(
      //     key: "${sectionId}_${levelId}_${category}_Library",
      //     data: destination.keys.toList());

      // await _libraryFilesGroupsBox?.put(cachedLibrary.key, cachedLibrary);

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
    int? levelId,
    int? sectionId,
    int? addedby,
    String? author,
    String? edition,
    String? category,
    String? order,
    String? sort,
    String? search,
    int? limit,
    int? page,
    bool hardFetch = false,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-bookPanel?level_id=${levelId ?? ''}&section_id=${sectionId ?? ''}&author=${author ?? ''}&edition=${edition ?? ''}&category=${category ?? ''}&added_by=${addedby ?? ''}&orderBy=${order ?? ''}&sort==${sort ?? ''}&limit=$limit&search=$search&page=$page"); //get the url from backend
      Map<int, LibraryFile> library = {};
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsLib in response?.data['data']) {
          library[jsLib["id"]] =
              LibraryFile.fromJson(jsLib); //get the name of id from backend
        }
        return Result(
          data: {
            "library": library,
            "totalbooks": response?.data["pagination"]
                ["totalBooks"], //get the name of total from backend
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

  static Future<Result<List<LibraryFile>>> uploadLibraryFile({
    required PlatformFile file,
    required String category,
    required List<Map<String, int>> groups,
    String? subjectId,
    bool withCache = true,
  }) async {
    Response? response;
    try {
      File fileData = File(file.path ?? "");
      int fileSize = await fileData.length();
      response = await HttpProvider.post("checkFileDuplicate", data: {
        "originalname": file.path?.split("/").last,
        "size": fileSize.toString(),
        "sectionsAndLevels": groups,
      });
      if (response?.statusCode == 200) {
        response = null;
        response = await HttpProvider.uploadFile(
          uploadUrl:
              "upload?category=$category&subject_id=$subjectId&sectionsAndLevels=${json.encode(groups)}",
          file: fileData,
          fileSize: fileSize,
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
          List<LibraryFile> libFiles = [];
          for (Map<String, dynamic> book in (response?.data["books"] ?? [])) {
            LibraryFile resFile = LibraryFile.fromJson(book);
            libFiles.add(resFile);
          }
          if (withCache && file.path != null) {
            await FileUtils.saveFiles(
                fileRelativePath: response?.data["file_info"]["path"],
                file: File(file.path!));
          }
          NotificationHandler.showProgressNotification(
            uniqueId: file.path.hashCode,
            title: "successful upload ",
            message: file.path?.split("/").last,
          );
          return Result(
              data: libFiles,
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
      if (response?.data != null) {
        showSnakeBar(
            title: "Failed Upload", message: response?.data["message"] ?? "");
      } else {
        showSnakeBar(title: "Failed Upload", message: "");
      }

      return Result(
          hasError: true,
          statusCode: response?.statusCode ?? _uploadError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          statusCode: _uploadError, message: error.toString(), data: null);
    }
  }

  static Future<Result<int>> downloadLibraryFile({
    required LibraryFile file,
  }) async {
    late Response? response;
    try {
      file.progress = get_x.RxInt(0);
      file.status?.value = "Downloading";
      response = await HttpProvider.downloadFile(
        downloadUrl: "download?id=${file.id}",
        savePath: "${FileUtils.defaultBaseFolderPath}/${file.filePath}",
        onReceiveProgress: (sent, total) {
          double progress = (sent / total) * 100;
          file.progress?.value = progress.toInt();
          NotificationHandler.showProgressNotification(
              uniqueId: file.id,
              progress: progress.toInt(),
              title: "Downloading",
              message: " ${file.title}");
        },
      );
      if (response?.statusCode == 200) {
        await file.checkDownloaded();
        if (file.downloaded.value) {
          await NotificationHandler.showProgressNotification(
              uniqueId: file.id,
              title: "Successful Downloaded ",
              message: file.title);
          showSnakeBar(
              title: "Download Successful",
              message: "Downloading ${file.title} Successful");
        } else {
          NotificationHandler.showProgressNotification(
              uniqueId: file.id,
              title: "Download Failed ",
              message: file.title);
          showSnakeBar(message: "Downloading ${file.title} Failed");
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      } else {
        file.status?.value = "Download Failed";
        NotificationHandler.showProgressNotification(
            uniqueId: file.id,
            title: "Failed Downloaded ",
            message: file.title);
        showSnakeBar(message: "Downloading ${file.title} Failed");
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

  static Future<Result<void>> deleteLibraryBook({
    required int bookId,
    bool withCache = true,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.delete("delete?id=$bookId");
      if (response?.statusCode == 200 && withCache) {
        _libraryFilesBox?.delete(bookId);
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

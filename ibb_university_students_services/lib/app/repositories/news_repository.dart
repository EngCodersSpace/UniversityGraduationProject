import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/helper_models/result.dart';
import '../models/news_model/news.dart';
import '../services/http_provider.dart';
import '../utils/internet_connection_cheker.dart';

class NewsRepository {
  static const int _fetchError = 622;
  static const int _createError = 623;
  static const int _uploadError = 626;

  static Box<News>? _newsBox;

  static Future<void> openBox() async {
    _newsBox = await Hive.openBox<News>("NewsBox");
  }

  static Future<void> clearBox() async {
    if(!(_newsBox?.isOpen??false)) {
      _newsBox = await Hive.openBox<News>("NewsBox");
    }
    _newsBox?.clear();
  }

  static Future<void> closeBox() async {
    if (_newsBox?.isOpen ?? false) {
      await _newsBox?.close();
    }
  }




  // static Future<Result<void>> streamFetchLibraryFilesGroup({
  //   required int sectionId,
  //   required int levelId,
  //   required String category,
  //   required get_x.RxMap<String, get_x.RxMap<int, LibraryFile>> destination,
  //   bool hardFetch = false,
  // }) async {
  //   // LibraryFilesCache? cachedLibrary = _libraryFilesGroupsBox
  //   //     ?.get("${sectionId}_${levelId}_${category}_Library");
  //
  //   destination.value = {};
  //   if ((_libraryFilesBox?.isNotEmpty ?? false) &&
  //       (!hardFetch || !(await checkInternetConnection()))) {
  //     for (LibraryFile file in (_libraryFilesBox?.values ?? [])) {
  //       destination[file.category] ??= get_x.RxMap({});
  //       destination[file.category]?[file.id] = file;
  //     }
  //     return Result(hasError: false, statusCode: 200);
  //   }
  //
  //   try {
  //     await _libraryFilesBox?.clear();
  //     Response? response = await HttpProvider.get(
  //       "/get-all-books-stream",
  //       options: Options(responseType: ResponseType.stream),
  //     );
  //
  //     if (response?.statusCode == 204) {
  //       return Result(
  //         hasError: false,
  //         statusCode: response?.statusCode ?? _fetchAllError,
  //         message: "No data received",
  //       );
  //     } else if (response?.data == null) {
  //       return Result(
  //         hasError: true,
  //         statusCode: response?.statusCode ?? _fetchAllError,
  //         message: "No data received",
  //       );
  //     }
  //
  //     StringBuffer buffer = StringBuffer();
  //
  //     await for (List<int> chunk in response?.data!.stream) {
  //       buffer.write(utf8.decode(chunk, allowMalformed: true));
  //
  //       // Process all complete JSON objects
  //       List<String> parts = buffer.toString().split("\n---\n");
  //
  //       for (int i = 0; i < parts.length - 1; i++) {
  //         String jsonChunk = parts[i].trim(); // Clean up whitespace
  //
  //         if (jsonChunk.isNotEmpty) {
  //           try {
  //             final Map<String, dynamic> jsLibrary = jsonDecode(jsonChunk);
  //
  //             Subject? subject;
  //             if (jsLibrary["subject_id"] != null) {
  //               subject = await SubjectRepository.fetchSubject(
  //                   id: jsLibrary["subject_id"])
  //                   .then((e) => e.data);
  //             }
  //             LibraryFile libraryFile =
  //             LibraryFile.fromJson(jsLibrary, subject: subject);
  //             destination[libraryFile.category] ??= get_x.RxMap({});
  //             destination[libraryFile.category]?[libraryFile.id] = libraryFile;
  //             await _libraryFilesBox?.put(libraryFile.id, libraryFile);
  //           } catch (e) {
  //             if (kDebugMode) {
  //               print("Error parsing JSON chunk: $e. Chunk: $jsonChunk");
  //             }
  //           }
  //         }
  //       }
  //
  //       // Keep the last part (which may be incomplete) in the buffer
  //       buffer.clear();
  //       buffer.write(parts.last);
  //     }
  //
  //     // Store the final cache
  //     // LibraryFilesCache cachedLibrary = LibraryFilesCache(
  //     //     key: "${sectionId}_${levelId}_${category}_Library",
  //     //     data: destination.keys.toList());
  //
  //     // await _libraryFilesGroupsBox?.put(cachedLibrary.key, cachedLibrary);
  //
  //     return Result(hasError: false, statusCode: response?.statusCode);
  //   } catch (error) {
  //     return Result(
  //         hasError: true,
  //         statusCode: _fetchAllError,
  //         message: error.toString(),
  //         data: null);
  //   }
  // }

  static Future<Result<Map<int, News>>> fetchNews({
    int? limit,
    bool hardFetch = false,
  }) async {
    if ((_newsBox?.isNotEmpty??false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      if(limit!=null){
        Map<int,News> news = {};
        for(int i = 0; (i < limit &&i<(_newsBox?.length??0));i++){
          news[i] = _newsBox!.toMap().cast<int,News>().values.toList()[i];
        }

        return Result(
          data:news,
          statusCode: 200,
          hasError: false,
          message: "successful",
        );
      }
      return Result(
        data: _newsBox?.toMap().cast<int,News>()??{},
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get(
          "Get-AllNews?limit=${limit??''}");
      if (response?.statusCode == 200) {
        await clearBox();
        for (Map<String, dynamic> jsNews in response?.data["data"]) {
          News news = News.fromJson(jsNews);
          await _newsBox?.put(news.id, news);
        }
        print(_newsBox?.values);
        return Result(
            data: _newsBox?.toMap().cast<int,News>()??{},
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



  static Future<Result<News>> createNews({
    required PlatformFile? file,
    required String title,
    required String content,
    required get_x.RxDouble progress,
    bool withCache = true,
  }) async {
    Response? response;
    try {
      get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
      response = await HttpProvider.post(
        "New-With-Photo",
        data: FormData.fromMap({
          'file': (file != null)
              ? await MultipartFile.fromFile(file.path!, filename: file.name)
              : null,
          'title': title,
          'content': content
        }),
        onSendProgress: (sent, total) {
           progress.value = (sent / total) * 100;
        },
      );

      if (response?.statusCode == 201) {
        News news = News.fromJson(response?.data["data"]);
        if(withCache){
        await _newsBox?.put(news.id, news);
        }
        return Result(
            data: news,
            hasError: false,
            statusCode: response?.statusCode ?? _uploadError,
            message: response?.data["message"] ?? "error");
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          hasError: true,
          statusCode: response?.statusCode ?? _createError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          statusCode: _createError, message: error.toString(), data: null);
    }
  }


  static Future<Result> updateNews({
    required int id,
    PlatformFile? file,
    String? title,
    String? content,
    required get_x.RxDouble progress,
    bool withCache = true,
  }) async {
    Response? response;
    try {
      get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
      response = await HttpProvider.put(
        "Update-New/$id",
        data: FormData.fromMap({
          'file': (file != null)
              ? await MultipartFile.fromFile(file.path!, filename: file.name)
              : null,
          'title': title,
          'content': content
        }),
        onSendProgress: (sent, total) {
          progress.value = (sent / total) * 100;
        },
      );

      if (response?.statusCode == 201) {
        News news = News.fromJson(response?.data["data"]);
        if(withCache){
          await _newsBox?.put(news.id, news);
        }
        return Result(
            data: news,
            hasError: false,
            statusCode: response?.statusCode ?? _uploadError,
            message: response?.data["message"] ?? "error");
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
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




}

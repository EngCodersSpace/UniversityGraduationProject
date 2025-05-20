import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../models/helper_models/result.dart';
import '../services/http_provider.dart';

class NewsRepository {
  // static const int _fetchError = 622;
  // static const int _createError = 623;
  static const int _uploadError = 626;

  // static const int _deleteError = 627;

  static Future<Result> createNews({
    required PlatformFile? file,
    required String title,
    required String content,
    required get_x.RxDouble progress,
    bool withCache = true,
  }) async {
    Response? response;
    try {
      response = null;
      response = await HttpProvider.post(
        "New-With-Photo",
        data: FormData.fromMap({
          'file': (file != null)
              ? await MultipartFile.fromFile(file.path!, filename: file.name)
              : "",
          'title': title,
          'content': content
        }),
        onSendProgress: (sent, total) {
           progress.value = (sent / total) * 100;
        },
      );

      if (response?.statusCode == 201) {
        return Result(
            data: null,
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

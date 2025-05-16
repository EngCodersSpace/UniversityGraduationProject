import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart'as get_x;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../models/helper_models/result.dart';
import '../services/http_provider.dart';
import '../services/notification_services.dart';
import '../utils/snake_bar.dart';

class NewsRepository{

  static const int _fetchAllError = 621;
  static const int _fetchError = 622;
  static const int _createError = 623;
  static const int _uploadError = 626;
  static const int _deleteError = 627;


  static Future<Result> uploadImageToServer({
    required PlatformFile file,
    required int newsId,
    bool withCache = true,
  }) async {
    Response? response;
    try {
      File fileData = File(file.path ?? "");
      int fileSize = await fileData.length();
        response = null;
        response = await HttpProvider.uploadFile(
          uploadUrl:
          "upload",
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
          NotificationHandler.showProgressNotification(
            uniqueId: file.path.hashCode,
            title: "successful upload ",
            message: file.path?.split("/").last,
          );

          return Result(
              data: null,
              hasError: false,
              statusCode: response?.statusCode ?? _uploadError,
              message: response?.data["message"] ?? "error");
        }
       else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      NotificationHandler.showProgressNotification(
        uniqueId: file.path.hashCode,
        title: "failed upload ",
        message: file.path?.split("/").last,
      );
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


}
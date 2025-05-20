import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/notification_model/notification_model.dart' as model;
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/helper_models/result.dart';
import '../services/http_provider.dart';
import '../utils/internet_connection_cheker.dart';
import 'package:get/get.dart' as get_x;

class NotificationRepository {
  static const int _fetchError = 611;
  static const int _createError = 612;
  // static const int _updateError = 612;
  // static const int _deleteError = 612;

  static Box<model.Notification>? _notificationsBox;

  static Future<void> openBox() async {
    _notificationsBox = await Hive.openBox<model.Notification>("notificationsBox");
  }

  static Future<void> clearBox() async {
    _notificationsBox ?? await Hive.openBox<model.Notification>("notificationsBox");
    _notificationsBox?.clear();
  }

  static Future<void> closeBox() async {
    if (_notificationsBox?.isOpen ?? false) {
      await _notificationsBox?.close();
    }
  }

  static Future<Result<Map<int, model.Notification>>> fetchNotifications(
      {bool hardFetch = false}) async {
    if ((_notificationsBox?.isNotEmpty ?? false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
        data: _notificationsBox?.toMap().cast<int, model.Notification>(),
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }

    // ignore: unused_local_variable
    late Response? response;
    try {
      int? userId = await UserRepository.fetchUser().then((e)=>e.data?.id);
      response = await HttpProvider.get(
          "Get-noti-recieved",data: {
        "receiver_id":userId,
        "topic_name": UserRepository.getUserTopics()
      });
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsNotification in response?.data["Data"]) {
          model.Notification notification = model.Notification.fromJson(jsNotification);
          _notificationsBox?.put(notification.id, notification);
        }
        return Result(
            data: _notificationsBox?.toMap().cast<int, model.Notification>()??{},
            hasError: true,
            statusCode: response?.statusCode ?? _fetchError,
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
          statusCode: 611,
          message: error.toString(),
          data: null);
    }
  }



  static Future<Result<void>> pushNotification({
    required String title,
    required String message,
    String? topic,
    int? receiverId,
    bool withCache = true,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.post("send-info-noti", data: {
        "title": title,
        "message": message,
        "topic_name": topic,
        "receiver_id":receiverId
      });
      if (response?.statusCode == 200) {

      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: null,
          hasError: false,
          statusCode: response?.statusCode ?? _createError,
          message: response?.data?["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _createError,
          message: error.toString(),
          data: null);
    }
  }
  static Future<void> setNotificationsReadState() async {
    // for (String key in _notifications.keys) {
    //   for (int i = 0; i < (_notifications[key]?.length ?? 0); i++) {
    //     if (_notifications[key]?[i].readState?.value == false) {
    //       _notifications[key]?[i].readState = RxBool(true);
    //     }
    //   }
    // }
  }

  static Future<Result<Map>> fetchDashboardNotifications({
    int? senderID,
    int? reciverID,
    int? limit,
    int? page,
    String? topicName,
    String? type,
    String? order,
    String? sort,
    String? search,
    bool hardFetch = false,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-all-noti-panel?sender_id=${senderID ?? ''}&receiver_id=${reciverID ?? ''}&type=${type ?? ''}&topic_name=${topicName ?? ''}&orderBy=${order ?? ''}&limit=$limit&sort=${sort ?? ''}&search=$search&page=$page");
      Map<int, Notification> notification = {};
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsNoti in response?.data["data"]) {
          notification[jsNoti["message_id"]] = Notification.fromJson(jsNoti);
        }
        return Result(
          data: {
            "notifications": notification,
            "totalnotifications": response?.data["pagination"]
                ["totalNotifications"],
          },
          hasError: false,
          statusCode: response?.statusCode,
          message: response?.data["message"] ?? "error",
        );
      }
      return Result(
        data: {
          "notifications": notification,
          "totalnotifications": 0,
        },
        hasError: false,
        statusCode: response?.statusCode,
        message: response?.data["message"] ?? "error",
      );
    } catch (error) {
      return Result(
        hasError: true,
        statusCode: response?.statusCode,
        message: error.toString(),
        data: null,
      );
    }
  }
}

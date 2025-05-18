import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/notification_model/notification_model.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import '../models/helper_models/result.dart';
import '../services/http_provider.dart';
import '../utils/internet_connection_cheker.dart';

class NotificationRepository {
  static const int _fetchError = 611;
  // static const int _createError = 612;
  // static const int _updateError = 612;
  // static const int _deleteError = 612;

  static Box<Notification>? _notificationsBox;

  static Future<void> openBox() async {
    _notificationsBox = await Hive.openBox<Notification>("notificationsBox");
  }

  static Future<void> clearBox() async {
    _notificationsBox ?? await Hive.openBox<Notification>("notificationsBox");
    _notificationsBox?.clear();
  }

  static Future<void> closeBox() async {
    if (_notificationsBox?.isOpen ?? false) {
      await _notificationsBox?.close();
    }
  }

  static Future<Result<Map<int, Notification>>> fetchNotifications(
      {bool hardFetch = false}) async {
    if ((_notificationsBox?.isNotEmpty ?? false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
        data: _notificationsBox?.toMap().cast<int, Notification>(),
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
          Notification notification = Notification.fromJson(jsNotification);
          _notificationsBox?.put(notification.id, notification);
        }
        return Result(
            data: _notificationsBox?.toMap().cast<int, Notification>()??{},
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

  static Future<void> setNotificationsReadState() async {
    // for (String key in _notifications.keys) {
    //   for (int i = 0; i < (_notifications[key]?.length ?? 0); i++) {
    //     if (_notifications[key]?[i].readState?.value == false) {
    //       _notifications[key]?[i].readState = RxBool(true);
    //     }
    //   }
    // }
  }
}

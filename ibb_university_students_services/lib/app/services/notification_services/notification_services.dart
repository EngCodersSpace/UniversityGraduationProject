import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static String? token;

  static Future<void> initialize() async {
    // Request notification permissions
    await _firebaseMessaging.requestPermission();
    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (res) {
      // ignore: avoid_print
      print(res.notificationResponseType);
      // ignore: avoid_print
      print(res.id);
      // ignore: avoid_print
      print(res.actionId);
    });

    await FirebaseMessaging.instance.getToken().then((val) {
      token = val;
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Handle background/terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Handle background messages (important for when the app is in the background)
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    //Testing
    // _showNotification(title: "Test", body: "Just test notifications");
    // Future.delayed(const Duration(seconds: 10), () {
    //   _showNotification(
    //     title: "Test Notification",
    //     body: "This is a test notification sent after 10 seconds.",
    //   );
    // });
  }

  static void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'info') {
      showNotification(
        title: message.notification?.title ?? "Info",
        body: message.notification?.body ?? "Notification received",
      );
    } else if (message.data['type'] == 'command') {
      // Handle silent command notification
      _processCommand(message.data);
    }
  }

  static void _processCommand(Map<String, dynamic> data) {
    String action = data['action'] ?? '';
    if (action == 'refresh_data') {
      // String module = data['module'] ?? '';
      // Add logic to refresh data (e.g., call a service to update cache)
    }
  }

  static Future<void> showNotification(
      {required String title, String? body, int? uniqueId}) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel',
        'Default Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await _localNotificationsPlugin.show(
      uniqueId ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  // Show progress for an upload
  static Future<void> showProgressNotification(
      {required int uniqueId,
      int? progress,
      String? message,
      String? title}) async {
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails('upload_channel', 'Upload Progress',
          importance: Importance.max,
          priority: Priority.high,
          progress: progress ?? 0,
          maxProgress: 100,
          fullScreenIntent: true,
          playSound: false,
          silent: true,
          styleInformation: InboxStyleInformation(
              [(progress != null) ? "$progress%" : ""],
              summaryText: (progress != null) ? "$progress%" : "",
              htmlFormatLines: true,
              htmlFormatTitle: true,
              htmlFormatContent: true),
          // icon: "upload",
          showProgress: (progress != null),
          actions: (progress != null)
              ? [
                  const AndroidNotificationAction(
                    "1",
                    "Cancel",
                    titleColor: Colors.red,
                  ),
                ]
              : null),
    );

    // Update the progress in the notification
    await _localNotificationsPlugin.show(
      uniqueId.hashCode,
      '<p>$title $message</p>',
      '',
      notificationDetails,
    );
  }
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  // print("Handling background message: ${message.notification?.title}");

  if (message.data['type'] == 'info') {
    NotificationHandler.showNotification(
      title: message.notification?.title ?? "Info",
      body: message.notification?.body ?? "Background Notification",
    );
  } else if (message.data['type'] == 'command') {
    NotificationHandler._processCommand(message.data);
  }
}

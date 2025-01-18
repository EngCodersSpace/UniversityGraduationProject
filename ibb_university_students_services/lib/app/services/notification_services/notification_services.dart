import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? token ;

  Future<void> initialize() async {
    // Request notification permissions
    await _firebaseMessaging.requestPermission();
    // Initialize local notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings);


    await FirebaseMessaging.instance.getToken().then((token) {
      this.token = token;
      print("Device Token: $token");
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
    _showNotification(title: "Test", body: "Just test notifications");
    Future.delayed(const Duration(seconds: 10), () {
      _showNotification(
        title: "Test Notification",
        body: "This is a test notification sent after 10 seconds.",
      );
    });
  }


  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'info') {
      _showNotification(
        title: message.notification?.title ?? "Info",
        body: message.notification?.body ?? "Notification received",
      );
    } else if (message.data['type'] == 'command') {
      // Handle silent command notification
      _processCommand(message.data);
    }
  }

  Future<void> _showNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );
    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  static void _processCommand(Map<String, dynamic> data) {
    String action = data['action'] ?? '';
    if (action == 'refresh_data') {
      String module = data['module'] ?? '';
      print("Refreshing data for module: $module");
      // Add logic to refresh data (e.g., call a service to update cache)
    }
  }

  // Background message handler
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    print("Handling background message: ${message.notification?.title}");
    // Similar to the foreground handler, process the message here
    if (message.data['type'] == 'info') {
      // Process info notification in the background
      // You could also show a notification or update data in the background if needed
    } else if (message.data['type'] == 'command') {
      // Handle silent command notification
      _processCommand(message.data);
    }
  }
}

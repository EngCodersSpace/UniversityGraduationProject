import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../firebase_options.dart';
import '../services/hive_services.dart';
import '../services/http_provider.dart';
import '../services/notification_services.dart';
import '../repositories/user_repository.dart';

class InitAppController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {

      } else {

      }
    });
    try {
      await HttpProvider.init(baseUrl: "http://192.168.0.31:3000/");
      // await HttpProvider.init(baseUrl: "http://127.0.0.1:3000/");
      await Hive.initFlutter();
      await HiveServices.registerAdapters();
      await HiveServices.openGlobalBoxes();
      try {
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
      } catch (e) {
        if (kDebugMode) {
          print('Initialization error: $e');
        }
      }
      await NotificationHandler.initialize();
      // Set initialization complete
    } catch (e) {
      // Handle errors if needed
      if (kDebugMode) {
        print('Initialization error: $e');
      }
    }
    if (await UserRepository.isCredentialsCached()) {
      Get.offNamed("/main");
    } else {
      Get.offNamed("/login");
    }
  }
}

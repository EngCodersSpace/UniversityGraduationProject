import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../firebase_options.dart';
import '../services/downloder/download_manager.dart';
import '../services/hive_services/hive_services.dart';
import '../services/http_provider/http_provider.dart';
import '../services/notification_services/notification_services.dart';
import '../repositories/user_repository.dart';

class InitAppController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
<<<<<<< Updated upstream
      await HttpProvider.init(baseUrl: "http://192.168.0.31:3000/");
      // await HttpProvider.init(baseUrl: "http://127.0.0.1:3000/");
=======
>>>>>>> Stashed changes
      await Hive.initFlutter();
      await HiveServices.registerAdapters();
      await HiveServices.openGlobalBoxes();
      // await AppDataServices.fetchAppData();
      await DownloadManager.initialize();
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      await NotificationHandler().initialize();
      // Set initialization complete
    } catch (e) {
      // Handle errors if needed
      if (kDebugMode) {
        print('Initialization error: $e');
      }
    }
    print(await UserRepository.isCredentialsCached());
    if (await UserRepository.isCredentialsCached()) {
      Get.offNamed("/main");
    } else {
      Get.offNamed("/login");
    }
  }
}

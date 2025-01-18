import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../firebase_options.dart';
import '../services/app_data_services.dart';
import '../services/downloder/download_manager.dart';
import '../services/hive_services/hive_services.dart';
import '../services/http_provider/http_provider.dart';
import '../services/notification_services/notification_services.dart';
import '../services/user_services.dart';

class InitAppController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      await NotificationService().initialize();
      await HttpProvider.init(baseUrl: "http://192.168.0.31:3000/");
      await Hive.initFlutter();
      await HiveServices.registerAdapters();
      await AppDataServices.fetchAppData();
      await HiveServices.openGlobalBoxes();
      await DownloadManager.initialize();
      // Set initialization complete
    } catch (e) {
      // Handle errors if needed
      print('Initialization error: $e');
    }
    if (await UserServices.isCredentialsCached()) {
      Get.offNamed("/main");
    } else {
      Get.offNamed("/login");
    }
  }
}

import 'dart:ui';

import 'package:get/get.dart';
import '../../models/structuers/user_structure.dart';
import '../../models/user_model.dart';
import '../main_controller.dart';

class ProfileController extends GetxController {
  User user = UserModel.fetchUser();
  RxString language = (Get.locale?.languageCode ?? "en").obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void changeLang(String lang) {
  Get.updateLocale(Locale(lang));
  Get.find<MainController>().changeTabIndex(4);
  }

  @override
  void onClose() {}
}

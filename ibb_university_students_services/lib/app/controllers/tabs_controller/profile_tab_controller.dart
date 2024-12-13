import 'dart:ui';

import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';
import 'package:ibb_university_students_services/app/services/user_services.dart';
import '../../models/result.dart';
import '../main_controller.dart';

class ProfileController extends GetxController {
  late User user;
  RxString language = (Get.locale?.languageCode ?? "en").obs;
  RxBool initState = false.obs;
  @override
  void onInit() async {
    Result res = await UserServices.fetchUser();
    if (res.statusCode == 200) {
      user = res.data;
    }
    initState.value = true;
    super.onInit();
  }

  void changeLang(String lang) {
    Get.updateLocale(Locale(lang));
    language.value = lang;
    Get.find<MainController>().changeTabIndex(4);
  }

  void logout() {
    Get.offAllNamed("/login");
  }

  @override
  void onClose() {}
}

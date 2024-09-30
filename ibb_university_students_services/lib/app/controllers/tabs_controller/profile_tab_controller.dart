import 'dart:ui';

import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/student_model.dart';
import 'package:ibb_university_students_services/app/services/user_services.dart';
import '../../models/result.dart';
import '../main_controller.dart';

class ProfileController extends GetxController {
  late Student user;
  RxString language = (Get.locale?.languageCode ?? "en").obs;
  @override
  void onInit() async{
    // TODO: implement onInit
    Result res = await UserServices.fetchUser();
    if(res.statusCode == 200){
      user = res.data;
    }
    super.onInit();
  }

  void changeLang(String lang) {
  Get.updateLocale(Locale(lang));
  Get.find<MainController>().changeTabIndex(4);
  }

  @override
  void onClose() {}
}

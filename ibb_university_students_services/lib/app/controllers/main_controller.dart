import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_float_action_button_location.dart';
import 'package:ibb_university_students_services/app/globals.dart';
import 'package:ibb_university_students_services/app/models/result.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';
import 'package:ibb_university_students_services/app/services/user_services.dart';

class MainController extends GetxController {
  RxInt selectedIndex = 2.obs;
  late CustomFloatActionButtonLocation currentPos;
  User? user;

  @override
  void onInit() async {
    Result res = await UserServices.fetchUser();
    if (res.statusCode == 200) {
      user = res.data;
    }
    currentPos = CustomFloatActionButtonLocation(
        x: (Get.width * 0.45), y: Get.height - (Get.height * 0.1));

    super.onInit();
  }

  // Method to change the selected index
  void changeTabIndex(int index) {
    if (index == 0) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.1) - 16, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.9) - 28, y: Get.height - (Get.height * 0.1));
    } else if (index == 1) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.32) - 23, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.71) - 28, y: Get.height - (Get.height * 0.1));
    } else if (index == 2) {
      currentPos = CustomFloatActionButtonLocation(
          x: (Get.width * 0.45), y: Get.height - (Get.height * 0.1));
    } else if (index == 3) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.71) - 28, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.32) - 23, y: Get.height - (Get.height * 0.1));
    } else if (index == 4) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.9) - 28, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.1) - 16, y: Get.height - (Get.height * 0.1));
    }

    selectedIndex.value = index;
  }


  @override
  void onClose() {}
}

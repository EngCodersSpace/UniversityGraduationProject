import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_float_action_button_location.dart';
import '../models/result.dart';
import '../models/user_model.dart';
import '../services/user_services.dart';
import 'academic_card_controller.dart';
import 'exam_table_controller.dart';
import 'library_controller.dart';
import 'student_result_controller.dart';

class MainController extends GetxController {
  RxInt selectedIndex = 2.obs;
  User? user;
  late CustomFloatActionButtonLocation currentPos;
  RxBool loading = true.obs;
  @override
  void onInit() async {
    changeTabIndex(selectedIndex.value);
    super.onInit();
    loading.value = false;
    Result res = await UserServices.fetchUser();
    if (res.statusCode == 200) {
      user = res.data;
    }
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
              x: (Get.width * 0.71) - 8, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.32) - 23, y: Get.height - (Get.height * 0.1));
    } else if (index == 4) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.9) - 28, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.1) - 16, y: Get.height - (Get.height * 0.1));
    }

    if (!(Get.width <= 768 && Get.height <= 1025)) {
      putControllers(index);
    }

    selectedIndex.value = index;
  }

  void putControllers(int index) {
    GetxController? controller;
    switch (index) {
      case 5:
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<LibraryController>(
          LibraryController(),
        );
        break;
      case 6:
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<ExamTableController>(
          ExamTableController(),
        );
        break;
      case 7:
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<StudentResultController>(
          StudentResultController(),
        );
        break;
      case 8:
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<AcademicCardController>(
          AcademicCardController(),
        );
        break;
    }
  }

  @override
  void onClose() {}
}

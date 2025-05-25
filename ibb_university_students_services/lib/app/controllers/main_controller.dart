// ignore_for_file: unnecessary_null_comparison
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/views/main_view/main_view_components/custom_float_action_button_location.dart';
import 'package:ibb_university_students_services/app/utils/internet_connection_cheker.dart';
import '../models/helper_models/result.dart';
import '../models/user_model/user.dart';
import '../repositories/user_repository.dart';
import '../utils/screen_utils.dart';
import 'academic_card_controller.dart';
import 'exam_table_controller.dart';
import 'library_controller.dart';
import 'student_result_controller.dart';

class MainController extends GetxController {
  RxInt selectedIndex = 2.obs;
  User? user;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late CustomFloatActionButtonLocation currentPos;
  RxBool loading = true.obs;
  RxBool isConnect = false.obs;
  RxBool logging = false.obs; // Indicates active login process
  RxBool loggingFiled = false.obs; // Whether login failed
  RxString loggingFiledMessage = "".obs;
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode passwordFocus = FocusNode();
  @override
  void onInit() async {
    isConnect.value = await checkInternetConnection();
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {
        isConnect.value = false;
      } else {
        isConnect.value = true;
      }
    });
    changeTabIndex(selectedIndex.value);
    super.onInit();
    loading.value = false;
    if (kIsWeb) {
      Result res = await UserRepository.fetchUser();
      if (res.statusCode == 200) {
        user = res.data;
      }
    }
  }

  Future<void> onLogin() async {
    logging.value = true;

    if (formKey.currentState!.validate()) {
      Result res = await UserRepository.userLogin(
        id.text,
        password.text,
      );

      // Handle various login outcomes based on status code
      if (res.statusCode == 200) {
        Get.offNamed("/main"); // Navigate to main screen on success
      } else if (res.statusCode == 900) {
        loggingFiledMessage.value =
            "no internet connection \n please check your connection ";
        loggingFiled.value = true;
      } else if (res.statusCode == 401) {
        loggingFiledMessage.value = "password or id is wrong";
        loggingFiled.value = true;
      } else if (res.statusCode == 404) {
        loggingFiledMessage.value = "no such user exist";
        loggingFiled.value = true;
      } else {
        loggingFiledMessage.value =
            "something get wrong \n please check your connection ";
        loggingFiled.value = true;
      }
    }

    logging.value = false;
  }

  // Method to change the selected index
  void changeTabIndex(int index) {
    if (index == 0) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.1) - 23, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.85) - 28, y: Get.height - (Get.height * 0.1));
    } else if (index == 1) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.32) - 36, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.71) - 36, y: Get.height - (Get.height * 0.1));
    } else if (index == 2) {
      currentPos = CustomFloatActionButtonLocation(
          x: (Get.width * 0.45) - 12, y: Get.height - (Get.height * 0.1));
    } else if (index == 3) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.71) - 32, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.31) - 28, y: Get.height - (Get.height * 0.1));
    } else if (index == 4) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.9) - 48, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.1) - 23, y: Get.height - (Get.height * 0.1));
    }

    if (ScreenUtils.isWebScreen()) {
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

  void routeAdmainPanel() {
    Get.offNamed(
      "/dashboard_main_view",
    );
  }

  @override
  void onClose() {}
}

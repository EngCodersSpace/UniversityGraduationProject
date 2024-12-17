import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/student_model.dart';
import '../components/custom_text.dart';
import '../models/result.dart';
import '../models/user_model.dart';
import '../services/user_services.dart';
import '../styles/app_colors.dart';
import '../models/exam_model.dart';
import '../models/level_model.dart';
import '../services/level_services.dart';

class PaymentsController extends GetxController {
  RxBool loadingState = true.obs;
  Rx<User>? user;
  @override
  void onInit() async {
    // TODO: implement onInit
    Result res = await UserServices.fetchUser();
    if (res.statusCode == 200) {
      user = Rx(res.data);
    }
    loadingState.value = false;
  }

  @override
  void refresh() {
    super.refresh();
  }

  @override
  void onClose() {}
}

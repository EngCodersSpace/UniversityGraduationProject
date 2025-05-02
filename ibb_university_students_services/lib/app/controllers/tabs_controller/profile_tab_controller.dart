import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/user_model/user.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import '../../models/helper_models/result.dart';
import '../../views/login_view/login_view_components/change_password_card.dart';

class ProfileController extends GetxController {
  User? user;
  RxBool initState = false.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController passwordConfirmation = TextEditingController();
  FocusNode oldPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();
  FocusNode passwordConfirmationFocus = FocusNode();

  @override
  void onInit() async {
    Result res = await UserRepository.fetchUser();
    if (res.statusCode == 200) {
      user = res.data;
    }
    initState.value = true;
    super.onInit();
  }

  @override
  void refresh() async {
    initState.value = false;
    Result res = await UserRepository.fetchUser();
    if (res.statusCode == 200) {
      user = res.data;
    }
    initState.value = true;
  }

  void changedPasswordClick() {
    Get.dialog(PopUpChangePasswordCard());
  }

  void changePassword() {
    if (formKey.currentState!.validate()) {
      UserRepository.changePassword(
          oldPassword: oldPassword.text,
          newPassword: newPassword.text,
          passwordConfirmation: passwordConfirmation.text);
    }
  }

  void logout() async {
    await UserRepository.userLogout();
  }

  @override
  void onClose() {}
}

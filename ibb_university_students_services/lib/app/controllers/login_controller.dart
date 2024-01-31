
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController ID = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String logWith = "ID";
  RxBool logging = false.obs;

  @override
  void onClose() {
    ID.dispose();
    password.dispose();
  }

  String? validateID(String? ID) {
    bool valide = false;
    if (ID == "" || ID == null) {
      return "required ID";
    } else if (GetUtils.isNumericOnly(ID)) {
      logWith = "ID";
      valide = true;
    }
    else if (GetUtils.isEmail(ID)) {
      logWith = "Email";
      valide = true;
    }
    return (valide)?null:"Invalid ID";
  }

  String? validatePassword(String? password) {
    if (GetUtils.isNullOrBlank(password ?? "") == null) {
      return "Password required";
    } else if (password!.length < 8) {
      return "Password must be at least 8 characters  long";
    } else {
      return null;
    }
  }

  Future<void> onLogin() async {
    if (formKey.currentState!.validate()) {
      logging.value = true;
      await Future.delayed(const Duration(seconds: 3));
      if (ID.text == "2070093" && password.text == "123456789") {
        if (Get.locale.toString() == "en_US") {
          Get.updateLocale(const Locale('ar'));
        } else {
          Get.updateLocale(const Locale('en_US'));
        }
      }
      logging.value = false;
    }

  }
}

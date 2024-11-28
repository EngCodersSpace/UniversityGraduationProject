import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/result.dart';
import 'package:ibb_university_students_services/app/services/user_services.dart';

class LoginController extends GetxController {
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode idFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  String logWith = "ID";
  RxBool logging = false.obs;
  RxBool loggingFiled = false.obs;
  RxString loggingFiledMessage = "".obs;
  RxDouble heightScale = 0.6.obs;
  RxBool rememberMe = false.obs;


  @override
  void onClose() {
    id.dispose();
    password.dispose();
    idFocus.dispose();
    passwordFocus.dispose();
  }
  @override
  void onInit() {
    id.text = "1";
    password.text = "12345678";

    super.onInit();
  }
  @override
  void onReady() {
    //onLogin();
    super.onReady();
  }

  String? validateID(String? id) {
    bool valid = false;
    if (id == "" || id == null) {
      return "required ID";
    } else if (GetUtils.isNumericOnly(id)) {
      logWith = "ID";
      valid = true;
    }
    else if (GetUtils.isEmail(id)) {
      logWith = "Email";
      valid = true;
    }
    return (valid)?null:"Invalid ID";
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

  void forgotPassword(){
    Get.toNamed("/forgotPassword");
  }

  Future<void> onLogin() async {
    logging.value = true;
    if (formKey.currentState!.validate()) {
      Result res = await UserServices.userLogin(id.text, password.text,rememberMe: rememberMe.value);
      if (res.statusCode == 200) {
        Get.offNamed("/main");
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

  void toggleRememberMe(bool? val) {
    rememberMe.value = val ?? false;
  }

  void changeLang(String lang){
    Get.updateLocale(Locale(lang));
  }
}

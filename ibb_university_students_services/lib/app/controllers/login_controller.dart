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
  RxDouble heightScale = 0.6.obs;


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
    if (formKey.currentState!.validate()) {
      logging.value = true;
      await Future.delayed(const Duration(seconds: 1));
      Result res = await UserServices.userLogin(id.text, password.text);
      if (res.data) {
        Get.offNamed("/main");
      }else{
       loggingFiled.value = true;
      }
      logging.value = false;
    }
  }
  void changeLang(String lang){
    Get.updateLocale(Locale(lang));
  }
}

import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/login_controller.dart';

class LoginViewBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
  }


}
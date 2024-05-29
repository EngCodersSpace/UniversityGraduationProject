import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/login_controller.dart';
import 'package:ibb_university_students_services/app/controllers/main_controller.dart';

class MainViewBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<MainController>(MainController());
  }


}
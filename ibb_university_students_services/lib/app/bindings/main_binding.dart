import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/main_controller.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/home_tab_controller.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/profile_tab_controller.dart';

class MainViewBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<MainController>(MainController());
    Get.lazyPut<MainTabController>(() =>MainTabController());
    Get.lazyPut<ProfileController>(() =>ProfileController());
  }
}
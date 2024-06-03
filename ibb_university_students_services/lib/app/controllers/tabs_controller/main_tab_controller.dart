import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/globals.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';

class MainTabController extends GetxController {
  User user = User();


  @override
  void onClose() {}

  @override
  void onInit() {
    user = AppData.user;
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}

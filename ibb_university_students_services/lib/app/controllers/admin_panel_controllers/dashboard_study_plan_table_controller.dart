import 'package:flutter/src/widgets/editable_text.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';

class DashboardStudyPlanTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void export() {}

  @override
  void import() {}

  @override
  void onSearch() {}

  @override
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void onClose() {}
}

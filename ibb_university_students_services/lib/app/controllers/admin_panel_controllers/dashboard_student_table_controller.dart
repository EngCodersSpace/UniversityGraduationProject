// ignore: implementation_imports
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';

class DashboardStudentTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  @override
  void onInit() {
    //
    super.onInit();
  }

  @override
  void onClose() {
    //
    super.onClose();
  }

  @override
  void export() {}

  @override
  void import() {}

  @override
  void onSearch() {}

  @override
  TextEditingController get searchController => throw UnimplementedError();
}

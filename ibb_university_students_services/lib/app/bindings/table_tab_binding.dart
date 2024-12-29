import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/table_tab_view_controller.dart';

class TableTabBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TableTabController>(TableTabController());
  }
}

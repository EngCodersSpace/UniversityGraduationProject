import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/structuers/table_time_structure.dart';
import 'package:ibb_university_students_services/app/models/table_time_model.dart';


class TableTabController extends GetxController {
  TableTime? tableTime = TableTimeModel.fetchTable();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  @override
  void onClose() {}
}

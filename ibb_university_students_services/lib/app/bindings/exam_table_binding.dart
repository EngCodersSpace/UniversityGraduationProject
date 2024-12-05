import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/exam_table_controller.dart';

class ExamTableBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<ExamTableController>(ExamTableController());
  }


}
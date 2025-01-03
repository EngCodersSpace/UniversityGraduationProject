import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/academic_card_controller.dart';

class AcademicCardBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<AcademicCardController>(AcademicCardController());
  }


}
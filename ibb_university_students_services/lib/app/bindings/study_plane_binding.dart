import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/study_plane_controller.dart';

class StudyPlaneBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<StudyPlaneController>(StudyPlaneController());
  }


}
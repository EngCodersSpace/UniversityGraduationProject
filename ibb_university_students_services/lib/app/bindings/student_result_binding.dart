import 'package:get/get.dart';
import '../controllers/stydent_result_controller.dart';

class StudentResultBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<StudentResultController>(StudentResultController());
  }


}
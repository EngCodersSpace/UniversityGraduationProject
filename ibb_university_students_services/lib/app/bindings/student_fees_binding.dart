import 'package:get/get.dart';
import '../controllers/student_fees_controller.dart';
class StudentFeesBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<StudentFeeController>(StudentFeeController());
  }


}
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/pepper_transactions_controller.dart';

class PepperTransactionsBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<PepperTransactionsController>(PepperTransactionsController());
  }


}
import 'package:get/get.dart';
import '../controllers/payments_controller.dart';
class PaymentsBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<PaymentsController>(PaymentsController());
  }


}
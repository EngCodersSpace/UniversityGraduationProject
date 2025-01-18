import 'package:get/get.dart';
import '../controllers/init_app_controller.dart';

class InitAppBinding implements Bindings{
  @override
  void dependencies() async{
    Get.put(InitAppController());
  }
}
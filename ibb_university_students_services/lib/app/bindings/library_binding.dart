import 'package:get/get.dart';
import '../controllers/library_controller.dart';

class LibraryBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<LibraryController>(LibraryController());
  }


}
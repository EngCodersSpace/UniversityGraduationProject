import 'package:get/get.dart';

class ScreenUtils{

  static bool isWebScreen(){
    return (Get.width > 768 && Get.height > 1025);
  }
  static bool isPhoneScreen(){
    return (Get.width <= 768 && Get.height <= 1025);
  }
}
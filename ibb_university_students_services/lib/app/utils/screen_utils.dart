import 'package:get/get.dart';

class ScreenUtils{

  static bool isWebScreen(){
    return ( Get.width >768);
  }
  static bool isPhoneScreen(){
    return (Get.width <= 768);
  }
}
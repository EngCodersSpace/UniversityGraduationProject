import 'package:get/get.dart';

class Responsivity {
  static double fontSizeScale(double fontSize) {
    // double screenRatio = Get.width / Get.height;
    // double designRatio = 411 / 891;
    // double ratio = (screenRatio>designRatio)?designRatio/screenRatio:screenRatio / designRatio;
    if (Get.width <= 768 && Get.height <= 1025) {
      double ratio = Get.width / 411;
      if(ratio > 1.2) ratio = 1.2;
      if(ratio < 0.6) ratio = 0.6;
      return fontSize * ratio;
    } else {
      double ratio = Get.width / 411;
      if(ratio > 1.2) ratio = 1.2;
      if(ratio < 0.6) ratio = 0.6;
      return fontSize * ratio;
    }
  }
}
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomGetUtils{
  static void closeDialogByName(String dialogName) {
    Navigator.of(Get.overlayContext!).popUntil((route) {
      if (route.settings.name == dialogName) {
        Navigator.of(Get.overlayContext!).pop(); // Close the targeted dialog
        return false; // Stop further popping
      }
      return true; // Keep iterating through routes
    });
  }

}
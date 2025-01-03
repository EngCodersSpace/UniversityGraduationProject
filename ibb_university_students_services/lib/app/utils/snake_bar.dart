import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles/app_colors.dart';

void showSnakeBar({String? title, required String message}) {
  Get.snackbar(
    title ?? "",
    message,
    snackPosition: SnackPosition.BOTTOM,
    overlayBlur: 0,
    backgroundColor: AppColors.inverseCardColor.withOpacity(0.8),
    colorText: AppColors.mainTextColor,
    margin: const EdgeInsets.all(16),
    overlayColor: Colors.transparent,
    isDismissible: true,
    snackStyle: SnackStyle.FLOATING,
  );
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles/app_colors.dart';
import 'custom_text.dart';

class DayCard extends StatelessWidget {
  double heightScale;
  String text;
  bool selected;
  VoidCallback? onPress;

  DayCard({
    super.key,
    this.heightScale = 0.085,
    required this.text,
    this.selected = false,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * heightScale,
      padding: EdgeInsets.symmetric(horizontal: Get.height * heightScale*0.11),
      decoration: BoxDecoration(
        color: (selected) ? AppColors.inverseCardColor : null,
        borderRadius: BorderRadius.all(Radius.circular(Get.height * heightScale * 0.2)),
      ),
      child: Center(
        child: InkWell(
            onTap: onPress,
            child: SecText(
              text,
              fontWeight: FontWeight.bold,
              fontSize: (Get.locale?.languageCode == "ar")?12:16,
              textColor:
              (selected) ? AppColors.mainTextColor : AppColors.secTextColor,
            )),
      ),
    );
  }
}

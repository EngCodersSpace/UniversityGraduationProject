// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import 'custom_text.dart';

class DayCard extends StatelessWidget {
  double height;
  String text;
  bool selected;
  VoidCallback? onPress;

  DayCard({
    super.key,
    required this.height,
    required this.text,
    this.selected = false,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: height*0.12),
      decoration: BoxDecoration(
        color: (selected) ? AppColors.inverseCardColor : null,
        borderRadius: BorderRadius.all(Radius.circular(height * 0.2)),
      ),
      child: Center(
        child: InkWell(
            onTap: onPress,
            child: SecText(
              text,
              fontWeight: FontWeight.bold,
              fontSize: (Get.locale?.languageCode == "ar")?12:18,
              textColor:
              (selected) ? AppColors.mainTextColor : AppColors.secTextColor,
            )),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/globals.dart';

class MainText extends StatelessWidget {
  MainText(
    this.text, {
    super.key,
    this.textColor,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    this.height,
  }) {
    textColor ??= AppColors.mainTextColor;
  }

  String text;
  Color? textColor;
  double fontSize;
  double? height;
  FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize*Get.textScaleFactor,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

class SecText extends MainText {
  SecText(
    String text, {
    super.key,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
  }) : super(text,
            textColor: textColor ?? AppColors.secTextColor,
            fontSize: fontSize ?? 14*Get.textScaleFactor,
            fontWeight: fontWeight ?? FontWeight.normal);
}

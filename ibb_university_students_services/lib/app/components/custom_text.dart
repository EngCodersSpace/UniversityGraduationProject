// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
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
    fontSize = Utils.fontSizeScale(fontSize);
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
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

class SecText extends MainText {
  SecText(
    super.text, {
    super.key,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
  }) : super(textColor: textColor ?? AppColors.secTextColor,
            fontSize: fontSize ?? 14,
            fontWeight: fontWeight ?? FontWeight.normal);
}

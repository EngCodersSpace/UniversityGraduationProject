// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ibb_university_students_services/app/globals.dart';

class MainText extends StatelessWidget {
  MainText(
    this.text, {
    super.key,
    this.textColor,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
  }) {
    textColor ??= AppColors.mainTextColor;
  }

  String text;
  Color? textColor;
  double? fontSize;
  FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: textColor, fontSize: fontSize, fontWeight: fontWeight),
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
            textColor: AppColors.secTextColor,
            fontSize: fontSize??16,
            fontWeight: fontWeight??FontWeight.normal);
}

// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

import '../globals.dart';

class MainText extends StatelessWidget {
  MainText(
    this.text, {
    super.key,
    this.textColor,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    this.textAlign = TextAlign.center,
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
  TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: height,
          overflow: TextOverflow.clip),
      textAlign: textAlign,
    );
  }
}

class SecText extends MainText {
  SecText(
    super.text, {
    super.key,
    Color? textColor,
    super.height,
    super.fontSize = 14,
    super.fontWeight = FontWeight.normal,
    super.textAlign,
  }) : super(
          textColor: textColor ?? AppColors.secTextColor,
        );
}

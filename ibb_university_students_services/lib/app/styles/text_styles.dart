import 'package:flutter/material.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/utils/responsivity.dart';

class TextHeaders{
  TextHeaders({
    required this.fontSize,
    required this.fontWeight
});
  double fontSize;
  FontWeight fontWeight;
}


class AppTextStyles {
  static TextHeaders h1 = TextHeaders(fontSize: 24, fontWeight: FontWeight.bold);
  static TextHeaders h2 = TextHeaders(fontSize: 18, fontWeight: FontWeight.bold);
  static TextHeaders h3 = TextHeaders(fontSize: 14, fontWeight: FontWeight.bold);
  static TextHeaders h4 = TextHeaders(fontSize: 14, fontWeight: FontWeight.normal);

  static TextStyle mainStyle({
    TextHeaders? textHeader,
    double? height
  }) {
    textHeader ??= h2;
    return TextStyle(
      fontSize: Responsivity.fontSizeScale(textHeader.fontSize),
      fontWeight: textHeader.fontWeight,
      color: AppColors.mainTextColor,
      height: height,
    );
  }

  static TextStyle secStyle({
    TextHeaders? textHeader,
    double? height
  }) {
    textHeader ??= h4;
    return TextStyle(
      fontSize: Responsivity.fontSizeScale(textHeader.fontSize),
      fontWeight: textHeader.fontWeight,
      color: AppColors.mainTextColor,
      height: height,
    );
  }

  static TextStyle highlightStyle({
    TextHeaders? textHeader,
    double? height
  }) {
    textHeader ??= h4;
    return TextStyle(
      fontSize: Responsivity.fontSizeScale(textHeader.fontSize),
      fontWeight: textHeader.fontWeight,
      color: AppColors.highlightTextColor,
      height: height,
    );
  }

}

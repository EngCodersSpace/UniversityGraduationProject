// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../styles/text_styles.dart';

class CustomText extends StatelessWidget {
  CustomText(
      this.text, {
        super.key,
        this.style ,
        this.textAlign = TextAlign.center,
        this.softWrap = true,
      }){
    style?? AppTextStyles.mainStyle();
  }
  String text;
  TextStyle? style;
  TextAlign textAlign;
  bool softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      overflow: (!softWrap)?TextOverflow.ellipsis:null,
      softWrap: softWrap,
    );
  }
}
import 'package:flutter/material.dart';

class AppColors {
  static ButtonColors buttonColors = ButtonColors();
  static Color mainTextColor = Colors.white;
  static Color secTextColor = Colors.black;
  static Color color0 = Color(int.parse("FFFFFF",radix: 16));
  static Color color1 = Color(int.parse("0D3976",radix: 16));
  static Color color2 = Color(int.parse("EDF1FD",radix: 16));

}

class ButtonColors {
  ButtonColors({
    this.color = Colors.blueAccent,
    this.pressedColor = Colors.blueGrey,
    this.disableColor = Colors.grey,
  });

  final Color color;
  final Color pressedColor;
  final Color disableColor;
}
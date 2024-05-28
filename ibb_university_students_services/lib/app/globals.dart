import 'package:flutter/material.dart';

class AppColors {
  static ButtonColors buttonColors = ButtonColors(color:Color(int.parse("FF0D3976",radix: 16)));
  static Color mainTextColor = Colors.white;
  static Color secTextColor = Colors.black;
  static Color backColor = Color(int.parse("FFFFFFFF",radix: 16));
  static Color iconColor = Color(int.parse("FF0D3976",radix: 16));
  static Color color2 = Color(int.parse("FFEDF1FD",radix: 16));

}

// structure for Buttons Coloring
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
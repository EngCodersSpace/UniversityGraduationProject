import 'package:flutter/material.dart';

class AppColors {
  static ButtonColors buttonColors =
      ButtonColors(color: Color(int.parse("FF0D3976", radix: 16)));

  static Color mainTextColor = Colors.white;
  static Color inverseMainTextColor = const Color(0xDF0D3976);
  static Color secTextColor = const Color(0xFF0D3976);
  static Color highlightTextColor = const Color(0x5F0D3976);

  static Color linkTextColor = Colors.blueAccent;
  static Color coverColor = const Color.fromRGBO(0, 191, 255, 0.25);

  // static Color backColor = const Color(0xFFF5F5F5);
  static Color backColor = const Color(0xFFFFFFFF);
  static Color tabBackColor = const Color.fromRGBO(235, 241, 253, 1);
  static Color inverseTabBackColor = const Color(0xFF0D3976);

  static Color mainIconColor =  const Color(0xFFFFFFFF);
  static Color inverseIconColor = const Color(0xFF0D3976);

  static Color mainCardColor =  const Color(0xFFFFFFFF);
  static Color inverseCardColor = const Color(0xFF0D3976);
}

// structure for Buttons Coloring
class ButtonColors {
  ButtonColors({
    this.color = Colors.blueAccent,
    this.pressedColor = Colors.blueGrey,
    this.disableColor = Colors.grey,
  });

  Color color;
  Color pressedColor;
  Color disableColor;
}

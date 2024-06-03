import 'package:flutter/material.dart';

import 'models/user_model.dart';


class AppData{
   static late User user;
}


class AppColors {
  static ButtonColors buttonColors = ButtonColors(color:Color(int.parse("DF0D3976",radix: 16)));
  static Color mainTextColor = Colors.white;
  static Color inverseMainTextColor = Color(int.parse("DF0D3976",radix: 16));
  static Color secTextColor = Colors.black;
  static Color inverseSecTextColor = Color(int.parse("5F0D3976",radix: 16));
  static Color linkTextColor = Colors.blueAccent;
  static Color backColor = Color(int.parse("FFFFFFFF",radix: 16));
  static Color tabBackColor = Color(int.parse("EFFFFFFF",radix: 16));
  static Color iconColor = Color(int.parse("FF0D3976",radix: 16));
  static Color mainIconColor = Color(int.parse("FFFFFFFF",radix: 16));
  static Color inverseIconColor = Color(int.parse("5F0D3976",radix: 16));
  static Color cardColor = Color(int.parse("FF0D3976",radix: 16));
  static Color inverseCardColor = const Color.fromRGBO(235, 241, 253, 1);
  static Color mainCardColor = Color(int.parse("FFFFFFFF",radix: 16));

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
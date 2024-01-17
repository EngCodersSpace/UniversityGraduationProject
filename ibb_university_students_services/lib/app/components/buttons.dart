// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ibb_university_students_services/app/globals.dart';

class BasicButton extends StatelessWidget {
  BasicButton({
    super.key,
    required this.onPress,
    this.size ,
    this.text = "",
    this.textColor,
    this.pressedColor,
    this.disableColor,
    this.borderRadius = 10,
  }) {
    textColor = AppColors.mainTextColor;
    color = AppColors.buttonColors.color;
    pressedColor = AppColors.buttonColors.pressedColor;
    disableColor = AppColors.buttonColors.disableColor;
  }

  VoidCallback onPress;
  Size? size;
  String text;
  Color? textColor;
  Color? color;
  Color? pressedColor;
  Color? disableColor;
  double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size?.width,
      height: size?.height,
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(

            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return pressedColor!;
              } else if (states.contains(MaterialState.disabled)) {
                return disableColor!;
              }
              return color!;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius)))),
        child: Text(text, style: TextStyle(color: textColor)),
      ),
    );

  }
}

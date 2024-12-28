import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import 'formatter.dart';

void datePiker(BuildContext context, TextEditingController controller) async {
  DateTime? pikeDate = await showDatePicker(
    context: context,
    builder: (BuildContext context, Widget? child) {
      return Theme(
          data: ThemeData().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.inverseCardColor,
              onPrimary: AppColors.mainCardColor,
              surface: AppColors.mainCardColor,
              onSurface: AppColors.inverseCardColor,
            ),
          ),
          child: child!);
    },
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (pikeDate != null) {
    controller.text = pikeDate.toString().split(" ")[0];
  }
}


void timePiker(BuildContext context,TextEditingController controller) async {
  TimeOfDay? pikeTime = await showTimePicker(
    context: context,
    builder: (BuildContext context, Widget? child) {
      return Theme(
          data: ThemeData().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.inverseCardColor,
              onPrimary: AppColors.mainCardColor,
              surface: AppColors.mainCardColor,
              onSurface: AppColors.inverseCardColor,
            ),
          ),
          child: child!);
    },
    initialTime: TimeOfDay.now(),
  );
  if (pikeTime != null) {
    controller.text = Formatter.formatTimeOfDay(pikeTime);
  }
}
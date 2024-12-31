import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../styles/app_colors.dart';

enum TimeOfDayFormat {
  s_24("hh:mm"),
  s_12("hh:mm a");

  final String value;

  const TimeOfDayFormat(this.value);
}

class DateTimeUtils {
  static String addToStringTime(
      {required String time,
      required Duration duration,
      TimeOfDayFormat format = TimeOfDayFormat.s_12}) {
    DateTime newTime = DateFormat("hh:mm:ss").parse(time).add(duration);
    return DateFormat(format.value).format(newTime);
  }

  static String formatStringTime(
      {required String time, TimeOfDayFormat format = TimeOfDayFormat.s_12}) {
    return DateFormat(format.value).format(DateFormat("hh:mm:ss").parse(time));
  }

  static formatTimeOfDay(
      {required TimeOfDay time,
      TimeOfDayFormat format = TimeOfDayFormat.s_12}) {
    return DateFormat(format.value)
        .format(DateTime(2000, 1, 1, time.hour, time.minute));
  }

  static TimeOfDay timeOfDayFromString(
      {required String time, TimeOfDayFormat format = TimeOfDayFormat.s_12}) {
    return TimeOfDay.fromDateTime(DateFormat("hh:mm:ss").parse(time));
  }

  static DateTime dateTimeFromString(String time) {
    return DateFormat("yyyy-mm-dd").parse(time);
  }

  static void datePiker(
      BuildContext context, TextEditingController controller) async {
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

  static void timePiker(
      BuildContext context, TextEditingController controller) async {
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
      controller.text = DateTimeUtils.formatTimeOfDay(time: pikeTime);
    }
  }
}

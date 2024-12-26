import 'package:flutter/material.dart';

class Formatter{

  static formatTimeOfDay(TimeOfDay time) {
    final hours =
    time.hourOfPeriod.toString().padLeft(2, '0'); // 12-hour format
    final minutes = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM'; // AM/PM
    return '$hours:$minutes $period';
  }

}
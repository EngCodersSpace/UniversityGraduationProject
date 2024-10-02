// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/globals.dart';

class NotificationCard extends StatelessWidget {
  NotificationCard(
      {
        required this.message,
        required this.author,
        required this.time,
        super.key});

  String message;
  String author;
  String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.inverseCardColor,
      elevation: 6,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(12),
        child: Column(
            children: [
            MainText(message, fontSize: Utils.fontSizeScale(18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SecText("by: $author", textColor: AppColors.mainTextColor),
            const SizedBox(),
            SecText(time, textColor: AppColors.mainTextColor),
          ],
        ),
        ],
      ),
    ));
  }
}

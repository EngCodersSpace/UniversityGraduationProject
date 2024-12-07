// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';

class NotificationCard extends StatelessWidget {
  NotificationCard(
      {required this.message,
      required this.author,
      required this.time,
      this.readState = true,
      super.key});

  String message;
  String author;
  String time;
  bool readState;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
            color: AppColors.inverseCardColor.withOpacity(0.95),
            elevation: 6,
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  MainText(message,
                      fontSize: 18,
                      textColor: AppColors.mainCardColor),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SecText("By: $author",
                          textColor: AppColors.mainTextColor),
                      const SizedBox(),
                      SecText("At: $time", textColor: AppColors.mainTextColor),
                    ],
                  ),
                ],
              ),
            )),
        if(!readState)
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(16),
          ),
        )
      ],
    );
  }
}

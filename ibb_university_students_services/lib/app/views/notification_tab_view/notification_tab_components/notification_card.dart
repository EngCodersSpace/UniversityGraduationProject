// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

import '../../../components/custom_text_v2.dart';

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
            color: AppColors.inverseCardColor.withOpacity(0.93),
            elevation: 6,
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: CustomText(
                      " the title:",
                      style: AppTextStyles.mainStyle(
                          textHeader: AppTextHeaders.h1),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: CustomText(
                      message,
                      style: AppTextStyles.mainStyle(
                        textHeader: AppTextHeaders.h3,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: ((Get.width - 32) * 4) / 7,
                        decoration: BoxDecoration(
                          color: AppColors.mainCardColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
                        ),
                        child: CustomText(
                          "By: $author",
                          style: AppTextStyles.secStyle(
                              textHeader: AppTextHeaders.h5),
                        ),
                      ),
                      Container(
                        width: ((Get.width - 32) * 2) / 7,
                        decoration: BoxDecoration(
                          color: AppColors.mainCardColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32)),
                        ),
                        child: CustomText(
                          "At: $time",
                          style: AppTextStyles.secStyle(
                              textHeader: AppTextHeaders.h5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        if (!readState)
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

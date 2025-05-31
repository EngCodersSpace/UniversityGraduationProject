// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';
import 'package:ibb_university_students_services/app/utils/screen_utils.dart';

import '../../../components/custom_text_v2.dart';

class NotificationCard extends StatelessWidget {
  NotificationCard(
      {required this.title,
      required this.message,
      required this.author,
      required this.time,
      this.readState = true,
      super.key});

  String title;
  String message;
  String author;
  String time;
  bool readState;

  @override
  Widget build(BuildContext context) {
    return (ScreenUtils.isPhoneScreen())
        ? Stack(
            alignment: Alignment.topRight,
            children: [
              Card(
                  color: AppColors.inverseCardColor.withValues(alpha: 0.93),
                  elevation: 6,
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          child: CustomText(
                            " $title:",
                            style: AppTextStyles.mainStyle(
                                textHeader: AppTextHeaders.h1Bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: CustomText(
                            message,
                            style: AppTextStyles.mainStyle(
                              textHeader: AppTextHeaders.h3Normal,
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
                                    textHeader: AppTextHeaders.h5Bold),
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
                                "At: ${DateTimeUtils.formatStringTime(time: time)}",
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h5Bold),
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
          )
        : Stack(
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                width: Get.width * 0.3,
                child: Card(
                    color: AppColors.inverseCardColor.withValues(alpha: 0.93),
                    elevation: 6,
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: CustomText(
                              " $title:",
                              style: AppTextStyles.mainStyle(
                                  textHeader: AppTextHeaders.h1Bold),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: CustomText(
                              message,
                              style: AppTextStyles.mainStyle(
                                textHeader: AppTextHeaders.h3Normal,
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
                                width: (Get.width * 0.6) / 4,
                                decoration: BoxDecoration(
                                  color: AppColors.mainCardColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32)),
                                ),
                                child: CustomText(
                                  "By: $author",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h5Bold),
                                ),
                              ),
                              Container(
                                width: (Get.width * 0.5) / 4,
                                decoration: BoxDecoration(
                                  color: AppColors.mainCardColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32)),
                                ),
                                child: CustomText(
                                  "At: ${DateTimeUtils.formatStringTime(time: time)}",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h5Bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
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

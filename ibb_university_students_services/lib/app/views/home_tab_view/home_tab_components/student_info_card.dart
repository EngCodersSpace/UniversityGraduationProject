import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/home_tab_controller.dart';

import '../../../components/custom_text.dart';
import '../../../styles/app_colors.dart';
import '../../../models/student_model.dart';

class StudentInfoCard extends GetView<HomeTabController> {
  const StudentInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      surfaceTintColor: AppColors.mainCardColor,
      color: AppColors.mainCardColor,
      child: Row(
        children: [
          SizedBox(
            width: (Get.width - 2) * 0.05,
          ),
          SizedBox(
            width: (Get.width - 2) * 0.3,
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                SecText("Department".tr,
                    textColor: AppColors
                        .highlightTextColor),
                Row(
                  children: [
                    Icon(Icons.groups_sharp,
                        color:
                        AppColors.secTextColor),
                    SizedBox(
                      width: Get.width * 0.025,
                    ),
                    Flexible(
                      child: MainText(
                          (controller.user
                          as Student)
                              .section
                              ?.name ??
                              "Unknown".tr,
                          textColor: AppColors
                              .secTextColor,
                          fontSize: 14,
                          height: 0),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: Get.height * 0.06,
            width: 1,
            color: AppColors.highlightTextColor,
          ),
          SizedBox(
            width: (Get.width - 2) * 0.04,
          ),
          SizedBox(
            width: (Get.width - 2) * 0.25,
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                SecText("Level".tr,
                    textColor: AppColors
                        .highlightTextColor),
                Row(
                  children: [
                    Icon(Icons.school,
                        color:
                        AppColors.secTextColor),
                    SizedBox(
                      width: Get.width * 0.025,
                    ),
                    MainText(
                      (controller.user as Student)
                          .level
                          ?.name ??
                          "??".tr,
                      textColor:
                      AppColors.secTextColor,
                      fontSize: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: Get.height * 0.06,
            width: 1,
            color: AppColors.highlightTextColor,
          ),
          SizedBox(
            width: (Get.width - 2) * 0.03,
          ),
          SizedBox(
            width: (Get.width - 2) * 0.2,
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                SecText("Level".tr,
                    textColor: AppColors
                        .highlightTextColor),
                Row(
                  children: [
                    Icon(Icons.school,
                        color:
                        AppColors.secTextColor),
                    SizedBox(
                      width: Get.width * 0.025,
                    ),
                    MainText(
                      (controller.user as Student)
                          .level
                          ?.name ??
                          "??".tr,
                      textColor:
                      AppColors.secTextColor,
                      fontSize: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

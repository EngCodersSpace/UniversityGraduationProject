import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/home_tab_controller.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../models/student_model/student.dart';

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
            width: (Get.width - 2) * 0.04,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: (Get.width - 2) * 0.34,
              minWidth: (Get.width - 2) * 0.23,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText("Section".tr,
                    style: AppTextStyles.highlightStyle(
                        textHeader: AppTextHeaders.h5Bold)),
                Row(
                  children: [
                    Icon(Icons.groups_sharp, color: AppColors.secTextColor),
                    SizedBox(
                      width: Get.width * 0.025,
                    ),
                    Flexible(
                        child: CustomText(
                      (controller.user as Student).section?.name ??
                          "Unknown".tr,
                          style: AppTextStyles.secStyle(
                              textHeader: AppTextHeaders.h5Bold,height: 0),
                    ))
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText("Level".tr,
                    style: AppTextStyles.highlightStyle(
                        textHeader: AppTextHeaders.h5Bold)),
                Row(
                  children: [
                    Icon(Icons.school, color: AppColors.secTextColor),
                    SizedBox(
                      width: Get.width * 0.025,
                    ),
                    CustomText(
                        "${"Level".tr} ${(controller.user as Student).level?.name ?? "??".tr}",
                        style: AppTextStyles.secStyle(
                            textHeader: AppTextHeaders.h5Bold,height: 0)),
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Assignments".tr,
                  style: AppTextStyles.highlightStyle(
                      textHeader: AppTextHeaders.h5Bold),
                ),
                Row(
                  children: [
                    Icon(Icons.assignment, color: AppColors.secTextColor),
                    SizedBox(
                      width: Get.width * 0.025,
                    ),
                    CustomText("0/0",
                        style: AppTextStyles.secStyle(
                            textHeader: AppTextHeaders.h5Bold,height: 0)),
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

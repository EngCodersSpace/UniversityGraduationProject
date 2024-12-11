import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/home_tab_controller.dart';

import '../../../components/custom_text.dart';
import '../../../styles/app_colors.dart';
import '../../../models/doctor_model.dart';

class DoctorInfoCard extends GetView<HomeTabController> {
  const DoctorInfoCard({super.key});


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      surfaceTintColor: AppColors.mainCardColor,
      color: AppColors.mainCardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:(Get.width - 2) * 0.31,
              minWidth: (Get.width - 2) * 0.23,
            ),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                SecText("Department".tr,
                    textColor: AppColors
                        .highlightTextColor,fontSize: 12,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.groups_sharp,
                        color:
                        AppColors.secTextColor,
                    ),
                    SizedBox(
                      width: Get.width * 0.025,
                    ),
                    Flexible(
                      child: MainText(
                          (controller.user
                          as Doctor)
                              .section
                              ?.name ??
                              "Unknown".tr,
                          textColor: AppColors
                              .secTextColor,
                          fontSize: 12 ,
                          height: 0),
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
            width: (Get.width - 2) * 0.02,
          ),
          SizedBox(
            width: (Get.width - 2) * 0.26,
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                SecText("Academic Degree".tr,
                    textColor: AppColors
                        .highlightTextColor,
                  fontSize: 12,
                ),
                Row(
                  children: [
                    Icon(Icons.card_membership,
                        color:
                        AppColors.secTextColor),
                    SizedBox(
                      width: Get.width * 0.025,
                    ),
                    MainText(
                        (controller.user as Doctor)
                            .academicDegree ??
                            "Unknown".tr,
                        textColor:
                        AppColors.secTextColor,
                        fontSize: 12,
                        height: 0),
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
            width: (Get.width - 2) * 0.02,
          ),
          SizedBox(
            width: (Get.width - 2) * 0.26,
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                SecText(
                  "Academic Position".tr,
                  textColor:
                  AppColors.highlightTextColor,
                  fontSize:
                  12,
                ),
                Row(
                  children: [
                    Icon(Icons.manage_accounts,
                        color:
                        AppColors.secTextColor),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    MainText(
                        (controller.user as Doctor)
                            .administrativePosition ??
                            "Unknown".tr,
                        textColor:
                        AppColors.secTextColor,
                        fontSize: 12,
                        height: 0),
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

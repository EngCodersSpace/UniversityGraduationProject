import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/profile_tab_controller.dart';
import 'package:ibb_university_students_services/app/globals.dart';
import 'package:ibb_university_students_services/app/models/doctor_model.dart';
import 'package:ibb_university_students_services/app/models/student_model.dart';

import '../../components/buttons.dart';

class WebProfileView extends GetView<ProfileController> {
  const WebProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.initState.value)
        ? Container(
            padding: const EdgeInsets.only(top: 18.0),
            width: Get.width,
            height: Get.height,
            color: AppColors.tabBackColor,
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Container(
                    width: Get.width * 0.5,
                    height: Get.height * 0.8,
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.03,
                        vertical: Get.height * 0.03),
                    decoration: BoxDecoration(
                      // gradient: SweepGradient(
                      //   colors: [
                      //     AppColors.linkTextColor.withOpacity(0.4),
                      //     AppColors.linkTextColor.withOpacity(0.3),
                      //     AppColors.inverseCardColor.withOpacity(0.3),
                      //     AppColors.inverseCardColor.withOpacity(0.2),
                      //     AppColors.inverseCardColor.withOpacity(0.3),
                      //     AppColors.linkTextColor.withOpacity(0.3),
                      //     AppColors.linkTextColor.withOpacity(0.4),
                      //   ],
                      // ),
                      color: AppColors.inverseCardColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                  radius: Get.width * 0.07,
                                  backgroundColor: AppColors.inverseCardColor),
                              CircleAvatar(
                                backgroundColor:
                                    (controller.user.profileImage) != null
                                        ? AppColors.inverseCardColor
                                        : AppColors.inverseMainTextColor,
                                maxRadius: Get.width * 0.07 - 2,
                                backgroundImage:
                                    (controller.user.profileImage) != null
                                        ? AssetImage(
                                            controller.user.profileImage ?? "")
                                        : null,
                                child: (controller.user.profileImage) != ""
                                    ? null
                                    : MainText(controller.user.name?[0] ??
                                        "".toUpperCase()),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SecText(controller.user.name!),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SecText(controller.user.id.toString()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SecText(
                                        controller.user.email ?? "Unknown".tr),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SecText(controller.user.phones?.first ??
                                        "Unknown".tr),
                                  ],
                                ),
                                if (controller.user is Student) ...[
                                  Row(
                                    children: [
                                      SecText((controller.user as Student)
                                              .section
                                              ?.name
                                              ?.tr ??
                                          "Unknown".tr),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SecText((controller.user as Student)
                                              .level
                                              ?.name
                                              ?.tr ??
                                          "Unknown".tr),
                                    ],
                                  ),
                                ] else ...[
                                  Row(
                                    children: [
                                      SecText((controller.user as Doctor)
                                              .academicDegree
                                              ?.tr ??
                                          "Unknown".tr),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SecText((controller.user as Doctor)
                                              .administrativePosition
                                              ?.tr ??
                                          "Unknown".tr),
                                    ],
                                  ),
                                ],
                                CustomButton(
                                  onPress: controller.logout,
                                  text: "Logout".tr,
                                  size:
                                      Size(Get.width * 0.18, Get.height * 0.05),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          ));
  }
}

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
            alignment: Alignment.center,
            width: Get.width,
            height: Get.height,
            color: AppColors.inverseIconColor,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: Get.height * 0.16,
                  width: Get.width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 3, color: AppColors.tabBackColor),
                    image: DecorationImage(
                        image: AssetImage(controller.user.profileImage!),
                        fit: BoxFit.fill),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: Get.width * 0.6,
                  height: Get.height * 0.6,
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  decoration: BoxDecoration(
                    color: AppColors.tabBackColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.2,
                              ),
                              SecText(
                                "User Name".tr,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                width: Get.width * 0.4,
                              ),
                              SecText(controller.user.name!),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.2,
                              ),
                              SecText(
                                "ID".tr,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                width: Get.width * 0.5,
                              ),
                              SecText(controller.user.id as String),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.2,
                              ),
                              SecText(
                                "Email".tr,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                width: Get.width * 0.4,
                              ),
                              SecText(controller.user.email ?? "Unknown".tr),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.2,
                              ),
                              SecText(
                                "Phone".tr,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                width: Get.width * 0.4,
                              ),
                              SecText(controller.user.phones?.first ??
                                  "Unknown".tr),
                            ],
                          ),
                          if (controller.user is Student) ...[
                            Row(
                              children: [
                                SizedBox(
                                  width: Get.width * 0.2,
                                ),
                                SecText(
                                  "Department".tr,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  width: Get.width * 0.4,
                                ),
                                SecText((controller.user as Student)
                                        .section
                                        ?.name
                                        ?.tr ??
                                    "Unknown".tr),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: Get.width * 0.2,
                                ),
                                SecText(
                                  "Level".tr,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  width: Get.width * 0.4,
                                ),
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
                                SizedBox(
                                  width: Get.width * 0.2,
                                ),
                                SecText(
                                  "Academic Degree".tr,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  width: Get.width * 0.4,
                                ),
                                SecText((controller.user as Doctor)
                                        .academicDegree
                                        ?.tr ??
                                    "Unknown".tr),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: Get.width * 0.2,
                                ),
                                SecText(
                                  "administrative Position".tr,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  width: Get.width * 0.4,
                                ),
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
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          ));
  }
}

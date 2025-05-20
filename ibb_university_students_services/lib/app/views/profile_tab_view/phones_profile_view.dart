// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/profile_tab_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

import '../../components/custom_text_v2.dart';

class PhoneProfileView extends GetView<ProfileController> {
  PhoneProfileView({
    super.key,
  });

  double height = Get.height;
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.initState.value)
        ? Container(
            color: AppColors.tabBackColor,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    Container(
                      height: height * 0.5,
                      width: width,
                      color: AppColors.inverseTabBackColor,
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.06,
                          ),
                          Container(
                            height: height * 0.2,
                            width: width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  width: 3, color: AppColors.tabBackColor),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: controller.user?.profileImage ?? "",
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Center(
                                  child: CustomText(
                                      controller.user?.name?[0] ??
                                          "".toUpperCase(),
                                      style: AppTextStyles.mainStyle(
                                          textHeader: TextHeaders(
                                              fontSize: 80,
                                              fontWeight: FontWeight.bold),
                                          height: 0)),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  height: height * 0.63,
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                  decoration: BoxDecoration(
                    color: AppColors.tabBackColor,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(width * 0.07)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.4,
                            child: Row(
                              children: [
                                const Icon(Icons.numbers),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Flexible(
                                  child: CustomText(
                                    "User Identifier".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomText(
                            controller.user?.id.toString() ?? "Unknown",
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Normal),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.4,
                            child: Row(
                              children: [
                                const Icon(Icons.account_circle),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Flexible(
                                  child: CustomText(
                                    "UserName".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomText(
                            controller.user?.name ?? "Unknown",
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Normal),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.4,
                            child: Row(
                              children: [
                                const Icon(Icons.email_rounded),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                CustomText(
                                  "Email".tr,
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: CustomText(
                              controller.user?.email ?? "Unknown".tr,
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Normal),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.4,
                            child: Row(
                              children: [
                                const Icon(Icons.phone_android),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                CustomText(
                                  "Phone".tr,
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                ),
                              ],
                            ),
                          ),
                          CustomText(
                            ((controller.user?.phones?.isNotEmpty??false))?controller.user!.phones!.first:"Unknown".tr,
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Normal),
                          ),
                        ],
                      ),
                      if (controller.user != null &&
                          controller.user is Student) ...[
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.4,
                              child: Row(
                                children: [
                                  const Icon(Icons.groups),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  CustomText(
                                    "Section".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                ],
                              ),
                            ),
                            CustomText(
                              (controller.user as Student).section?.name?.tr ??
                                  "Unknown".tr,
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Normal),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.4,
                              child: Row(
                                children: [
                                  const Icon(Icons.stacked_bar_chart),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  CustomText(
                                    "Level".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                ],
                              ),
                            ),
                            CustomText(
                              (controller.user as Student).level?.name?.tr ??
                                  "Unknown".tr,
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Normal),
                            ),
                          ],
                        )
                      ] else ...[
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.4,
                              child: Row(
                                children: [
                                  const Icon(Icons.card_membership),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  CustomText(
                                    "Academic Degree".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                ],
                              ),
                            ),
                            CustomText(
                              (controller.user != null)
                                  ? (controller.user as Doctor)
                                          .academicDegree
                                          ?.tr ??
                                      "Unknown".tr
                                  : "Unknown".tr,
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Normal),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.4,
                              child: Row(
                                children: [
                                  const Icon(Icons.manage_accounts),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Flexible(
                                    child: CustomText(
                                      "Administrative Position".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            CustomText(
                              (controller.user != null)
                                  ? (controller.user as Doctor)
                                          .administrativePosition
                                          ?.tr ??
                                      "Unknown".tr
                                  : "Unknown".tr,
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Normal),
                            ),
                          ],
                        )
                      ],
                      Column(
                        children: [
                          CustomButton(
                            onPress: controller.changedPasswordClick,
                            text: "Change Password".tr,
                          ),
                          CustomButton(
                            onPress: controller.logout,
                            text: "Logout".tr,
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          ));
  }
}

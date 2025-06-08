import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/profile_tab_controller.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_v2.dart';
import '../../services/http_provider.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

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
                      color: AppColors.inverseCardColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircleAvatar(
                                          radius: Get.width * 0.045,
                                          backgroundColor:
                                              AppColors.mainCardColor),
                                      CircleAvatar(
                                          maxRadius: Get.width * 0.045 - 2,
                                          child: ClipOval(
                                            child: HttpProvider.httpImage(
                                                imageUrl:
                                                    "get-profile-image?user_id=${controller.user?.id}",
                                                secImageUrl: controller
                                                    .user?.profileImage,
                                                errorWidget: (ctx, s, o) =>
                                                    Icon(Icons.person),
                                                fit: BoxFit.fill),
                                          )),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      "Name: ",
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Normal,
                                      ),
                                    ),
                                    CustomText(
                                      controller.user?.name ?? "Unknown".tr,
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "ID: ",
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Normal,
                                      ),
                                    ),
                                    CustomText(
                                      controller.user?.id.toString() ??
                                          "Unknown".tr,
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "Email: ",
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Normal,
                                      ),
                                    ),
                                    CustomText(
                                      controller.user?.email ?? "Unknown".tr,
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "Phone Number: ",
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Normal,
                                      ),
                                    ),
                                    CustomText(
                                      (controller.user?.phones != null &&
                                              controller
                                                  .user!.phones!.isNotEmpty)
                                          ? controller.user!.phones!.first
                                          : "No phone number",
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Normal,
                                      ),
                                    ),
                                  ],
                                ),
                                if (controller.user is Student) ...[
                                  Row(
                                    children: [
                                      CustomText(
                                        "Section: ",
                                        style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Normal,
                                        ),
                                      ),
                                      CustomText(
                                        (controller.user as Student)
                                                .section
                                                ?.name
                                                ?.tr ??
                                            "Unknown".tr,
                                        style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        "Level: ",
                                        style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Normal,
                                        ),
                                      ),
                                      CustomText(
                                        (controller.user as Student)
                                                .level
                                                ?.name
                                                ?.tr ??
                                            "Unknown".tr,
                                        style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  Row(
                                    children: [
                                      CustomText(
                                        "Degree: ",
                                        style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Normal,
                                        ),
                                      ),
                                      CustomText(
                                        (controller.user as Doctor)
                                                .academicDegree
                                                ?.tr ??
                                            "Unknown".tr,
                                        style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        "Postion:",
                                        style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Normal,
                                        ),
                                      ),
                                      CustomText(
                                        (controller.user as Doctor)
                                                .administrativePosition
                                                ?.tr ??
                                            "Unknown".tr,
                                        style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                Column(
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: CustomButton(
                                        onPress:
                                            controller.changedPasswordClick,
                                        text: "Change Password".tr,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: CustomButton(
                                        onPress: controller.logout,
                                        text: "Logout".tr,
                                      ),
                                    )
                                  ],
                                )
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

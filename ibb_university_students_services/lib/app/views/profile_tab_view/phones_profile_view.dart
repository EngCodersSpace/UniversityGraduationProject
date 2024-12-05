// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/profile_tab_controller.dart';
import 'package:ibb_university_students_services/app/globals.dart';
import 'package:ibb_university_students_services/app/models/doctor_model.dart';
import 'package:ibb_university_students_services/app/models/student_model.dart';

class PhoneProfileView extends GetView<ProfileController> {
  PhoneProfileView({
    super.key,
  });

  double height = Get.height;
  double width = Get.width;
  List<DropdownMenuItem<String>> dropdownMenuItems = [
    DropdownMenuItem<String>(value: "en", child: SecText("English")),
    DropdownMenuItem<String>(value: "ar", child: SecText("العربية")),
  ];

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
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height * 0.16,
                                width: width * 0.6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      width: 3, color: AppColors.tabBackColor),
                                  image: ((controller.user.profileImage !=
                                              null) &&
                                          (controller.user.profileImage != ""))
                                      ? DecorationImage(
                                          image: AssetImage(
                                              controller.user.profileImage!),
                                          fit: BoxFit.fill)
                                      : null,
                                ),
                                child: ((controller.user.profileImage !=
                                    null) &&
                                    (controller.user.profileImage != ""))
                                    ? null
                                    : Center(child: MainText(
                                  controller.user.name?[0] ??
                                      "".toUpperCase(),
                                  fontSize: 50,
                                ),),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          MainText(controller.user.name??"Unknown".tr),
                          SecText(controller.user.email??"Unknown".tr,
                              textColor: AppColors.mainTextColor),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  height: height * 0.6,
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
                                const Icon(Icons.account_circle),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                SecText("UserName".tr,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                          ),
                          SecText(controller.user.name!),
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
                                SecText("Email".tr,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                          ),
                          SecText(controller.user.email ?? "Unknown".tr),
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
                                SecText("Phone".tr,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                          ),
                          SecText(
                              controller.user.phones?.first ?? "Unknown".tr),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.4,
                            child: Row(
                              children: [
                                const Icon(Icons.language),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                SecText("Language".tr,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                          ),
                          DropdownButton(
                            items: dropdownMenuItems,
                            onChanged: (val) {
                              controller.changeLang(val.toString());
                            },
                            value: controller.language.value,
                          ),
                        ],
                      ),
                      if (controller.user is Student) ...[
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
                                  SecText("Department".tr,
                                      fontWeight: FontWeight.bold),
                                ],
                              ),
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
                              width: width * 0.4,
                              child: Row(
                                children: [
                                  const Icon(Icons.stacked_bar_chart),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SecText("Level".tr,
                                      fontWeight: FontWeight.bold),
                                ],
                              ),
                            ),
                            SecText(
                                (controller.user as Student).level?.name?.tr ??
                                    "Unknown".tr),
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
                                  SecText("Academic Degree".tr,
                                      fontWeight: FontWeight.bold),
                                ],
                              ),
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
                              width: width * 0.4,
                              child: Row(
                                children: [
                                  const Icon(Icons.manage_accounts),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Flexible(
                                    child: SecText("administrative Position".tr,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            SecText((controller.user as Doctor)
                                    .administrativePosition
                                    ?.tr ??
                                "Unknown".tr),
                          ],
                        )
                      ],
                      CustomButton(
                        onPress: controller.logout,
                        text: "Logout".tr,
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

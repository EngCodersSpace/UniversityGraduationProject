// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/profile_tab_controller.dart';
import 'package:ibb_university_students_services/app/globals.dart';

import '../../controllers/main_controller.dart';

class PhoneProfileView extends GetView<ProfileController> {
  PhoneProfileView({
    super.key,
  });

  double height = Get.height;
  double width = Get.width;
  List<DropdownMenuItem<String>> dropdownMenuItems = [
    DropdownMenuItem<String>(
        value: "en", child: SecText("English")),
    DropdownMenuItem<String>(
        value: "ar", child: SecText("العربية")),
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: AppColors.tabBackColor,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
               Column(
                    children: [
                      Container(
                        height: height*0.6,
                        width: width,
                        color: AppColors.inverseTabBackColor,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.05,
                            ),
                            MainText("Profile".tr),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height*0.21,
                                  width: width*0.6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border:Border.all(width: 3,color: AppColors.tabBackColor) ,
                                    image: DecorationImage(
                                        image:AssetImage(controller.user.profileImage!.value),fit: BoxFit.fill
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: height*0.01,),
                            MainText(controller.user.name!.value),
                            SecText("shehab@gmail.com",textColor: AppColors.mainTextColor),
                          ],
                        ),
                      )
                    ],
                  ),
              Container(
                  height: height * 0.5,
                  width: width,
                  padding: EdgeInsets.all(width*0.05),
                  decoration: BoxDecoration(
                    color: AppColors.tabBackColor,
                    borderRadius:
                         BorderRadius.vertical(top: Radius.circular(width*0.07)),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(width*0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: width*0.35,
                              child: Row(
                                children: [
                                  const Icon(Icons.email_rounded),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SecText("Email".tr, fontWeight: FontWeight.bold),
                                ],
                              ),
                            ),
                            SecText("shehab@gmail.com"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width*0.35,
                              child: Row(
                                children: [
                                  const Icon(Icons.account_circle),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SecText("UserName".tr, fontWeight: FontWeight.bold),
                                ],
                              ),
                            ),
                            SecText(controller.user.name!.value),
                          ],
                        ),
                        Row(
                          children: [

                            SizedBox(
                              width: width*0.35,
                              child: Row(
                                children: [
                                  const Icon(Icons.phone_android),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SecText("Phone".tr, fontWeight: FontWeight.bold),
                                ],
                              ),
                            ),
                            SecText("772388461"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width*0.35,
                              child: Row(
                                children: [
                                  const Icon(Icons.language),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SecText("Language".tr, fontWeight: FontWeight.bold),
                                ],
                              ),
                            ),
                            DropdownButton(
                              items: dropdownMenuItems,
                              onChanged: (val) {
                                Get.updateLocale(Locale(val!));
                                Get.find<MainController>().changeTabIndex(4);
                              },
                              value: Get.locale?.languageCode ?? "en",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}

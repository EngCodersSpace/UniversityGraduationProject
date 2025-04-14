import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/controllers/setting_controller.dart';
import '../../../components/buttons.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

// ignore: must_be_immutable
class PopUpSettingsCard extends GetView<SettingController> {
  // ignore: prefer_const_constructors_in_immutables
  PopUpSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Hero(
              tag: "PupCard",
              child: Material(
                color: AppColors.tabBackColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.inverseCardColor, width: 4),
                      borderRadius: BorderRadius.circular(32)),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: AppColors.secTextColor,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                CustomText(
                                  "Settings".tr,
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h2Bold),
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: AppColors.secTextColor,
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: Get.width * 0.4,
                              child: Row(
                                children: [
                                   Icon(Icons.language,color: AppColors.inverseIconColor,),
                                  SizedBox(
                                    width: Get.width * 0.02,
                                  ),
                                  CustomText(
                                    "Language".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                ],
                              ),
                            ),
                            DropdownButton(
                              items: [
                                DropdownMenuItem<String>(
                                    value: "en",
                                    child: CustomText(
                                      "English",
                                      style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Normal),
                                    )),
                                DropdownMenuItem<String>(
                                    value: "ar",
                                    child: CustomText(
                                      "العربية",
                                      style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Normal),
                                    )),
                              ],
                              selectedItemBuilder: (ctx)=>[
                                DropdownMenuItem<String>(
                                    value: "en",
                                    child: CustomText(
                                      "English",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Normal),
                                    )),
                                DropdownMenuItem<String>(
                                    value: "ar",
                                    child: CustomText(
                                      "العربية",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Normal),
                                    )),
                              ],
                              underline: const SizedBox(),
                              dropdownColor: AppColors.inverseIconColor,
                              onChanged: (val) {
                                controller.changeLang(val.toString());
                              },
                              value: controller.language,
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ))),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/study_plane_controller.dart';
import 'package:ibb_university_students_services/app/utils/screen_utils.dart';
import '../../../components/buttons.dart';
import '../../../components/text_field.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class PopUpAddStudyPlanCard extends GetView<StudyPlaneController> {
  const PopUpAddStudyPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return (ScreenUtils.isPhoneScreen())
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Hero(
                tag: "PopUpInsertCard",
                child: Material(
                  color: AppColors.mainCardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                      side: BorderSide(
                        color: AppColors.inverseCardColor,
                        width: 3,
                      )),
                  child: SizedBox(
                      height: Get.height * 0.25,
                      width: Get.width,
                      child: SafeArea(
                          minimum: const EdgeInsets.all(12),
                          child: Form(
                            key: controller.formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomText("Add Study plan",
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.title,
                                          size: 40,
                                          color: AppColors.inverseIconColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CustomText("Name".tr,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                      ],
                                    ),
                                    CustomTextFormField(
                                      controller:
                                          controller.studyPlaneNameController,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold),
                                      // validator: controller.validateEntryYear,
                                      labelText: "Name".tr,
                                      focusNode: controller.studyPlaneNameFocus,
                                      onFieldSubmitted: (e) {
                                        controller.addStudyPlan();
                                      },
                                      width: (Get.width - 12) * 0.46,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomButton(
                                      onPress: controller.addStudyPlan,
                                      text: "Add",
                                    ),
                                    CustomButton(
                                      onPress: () => Get.back(result: null),
                                      text: "Close",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))),
                ),
              ),
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Hero(
                tag: "PopUpInsertCard",
                child: Material(
                  color: AppColors.mainCardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                      side: BorderSide(
                        color: AppColors.inverseCardColor,
                        width: 3,
                      )),
                  child: SizedBox(
                      height: Get.height * 0.25,
                      width: Get.width * 0.3,
                      child: SafeArea(
                          minimum: const EdgeInsets.all(12),
                          child: Form(
                            key: controller.formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomText("Add Study plan",
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText("Name".tr,
                                        style: AppTextStyles.secStyle(
                                            textHeader: AppTextHeaders.h3Bold)),
                                    CustomTextFormField(
                                      controller:
                                          controller.studyPlaneNameController,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold),
                                      // validator: controller.validateEntryYear,
                                      labelText: "Name".tr,
                                      focusNode: controller.studyPlaneNameFocus,
                                      onFieldSubmitted: (e) {
                                        controller.addStudyPlan();
                                      },
                                      width: (Get.width - 12) * 0.2,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomButton(
                                      onPress: controller.addStudyPlan,
                                      text: "Add",
                                    ),
                                    CustomButton(
                                      onPress: () => Get.back(result: null),
                                      text: "Close",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))),
                ),
              ),
            ),
          );
  }
}

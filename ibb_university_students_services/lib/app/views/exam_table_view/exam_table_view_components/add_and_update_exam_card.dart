import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/exam_table_controller.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/lecture_table_tab_view_controller.dart';
import '../../../components/buttons.dart';
import '../../../components/text_field.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class PopUpIAddAndUpdateExamCard extends GetView<ExamTableController> {
  const PopUpIAddAndUpdateExamCard({super.key});



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
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

                )
            ),
            child: SizedBox(
                height: Get.height * 0.6,
                width: Get.width,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText("${controller.mode} Exam",
                              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Subject".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.subjectController,
                                // validator:controller.validateName,
                                labelText: 'Subject'.tr,
                                focusNode: controller.subjectFocus,
                                  onFieldSubmitted: (e) {
                                  controller.timeFocus.requestFocus();
                                  controller.timePiker(context);
                                  },
                                width: (Get.width-12)*0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Date".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.dateController,
                                // validator: controller.validateDate,
                                labelText: 'Date'.tr,
                                focusNode: controller.dateFocus,
                                readOnly: true,
                                onTap: () => controller.datePiker(context),
                                onFieldSubmitted: (e) {
                                  controller.timeFocus.requestFocus();
                                },
                                width: (Get.width - 12) * 0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Time".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.timeController,
                                // validator: controller.validateTime,
                                labelText: "Time".tr,
                                focusNode: controller.timeFocus,
                                readOnly: true,
                                onTap: () => controller.timePiker(context),
                                onFieldSubmitted: (e) {
                                  controller.dayFocus.requestFocus();
                                },
                                width: (Get.width - 12) * 0.46,
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Day".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.dayController,
                                labelText: "Day".tr,
                                keyboardType: TextInputType.number,
                                focusNode: controller.dayFocus,
                                onFieldSubmitted: (e) {
                                  controller.hallFocus.requestFocus();
                                },
                                width: (Get.width-12)*0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_balance,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Hall".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.hallController,
                                // validator: controller.validateEntryYear,
                                keyboardType: TextInputType.datetime,
                                labelText: "Hall".tr,
                                focusNode: controller.hallFocus,
                                onFieldSubmitted: (e) {
                                  controller.dateFocus.requestFocus();
                                },
                                width: (Get.width-12)*0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                onPress: controller.submit,
                                text: controller.mode.value,
                              ),
                              CustomButton(
                                onPress: () => Get.back(result: null),
                                text: "Close",
                              ),
                            ],
                          )
                        ],
                      ),
                    ))),
          ),
        ),
      ),
    );
  }


}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/exam_table_controller.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/assignments_tab_controller.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';
import '../../../components/buttons.dart';
import '../../../components/text_field.dart';
import '../../../models/subject_model/subject_model.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class PopUpIAddAndUpdateAssignmentsCard extends GetView<AssignmentsTabController> {
  const PopUpIAddAndUpdateAssignmentsCard({super.key});



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
                          CustomText("${controller.mode} Assignment",
                              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  CustomText("Title".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.titleController,
                                style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
                                // validator: controller.validateEntryYear,
                                labelText: "Title".tr,
                                focusNode: controller.hallFocus,
                                onFieldSubmitted: (e) {
                                  controller.submit();
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
                                    Icons.calendar_month,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Due Date".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.dueDateController,
                                // validator: controller.validateDate,
                                style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
                                labelText: 'Date'.tr,
                                focusNode: controller.dueDateFocus,
                                readOnly: true,
                                onTap: () => DateTimeUtils.datePiker(context,controller.dueDateController),
                                onFieldSubmitted: (e) {
                                  // controller.timeFocus.requestFocus();
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
                                    Icons.person,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Doctor".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                // controller: controller.timeController,
                                style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
                                // validator: controller.validateTime,
                                labelText: "Doctor".tr,
                                // focusNode: controller.timeFocus,
                                readOnly: true,
                                onFieldSubmitted: (e) {
                                  controller.submit();
                                },
                                width: (Get.width - 12) * 0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                onPress: controller.submit,
                                text: controller.mode,
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

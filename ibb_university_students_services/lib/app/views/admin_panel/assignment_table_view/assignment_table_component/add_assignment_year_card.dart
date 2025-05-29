import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_assignment_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

class AddAssignmentYearCard
    extends GetView<DashboardAssignmentTableController> {
  const AddAssignmentYearCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText("Add Year",
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h2Bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText("Year".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.year,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                                labelText: "Year".tr,
                                focusNode: controller.yearFocus,
                                onFieldSubmitted: (e) {
                                  controller.addAssignment();
                                },
                                width: (Get.width - 12) * 0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                onPress: controller.addYear,
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/student_fees_controller.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/permission_checker.dart';

import '../../components/buttons.dart';
import '../../components/text_field.dart';
import '../../utils/validators.dart';
import 'student_fees_view_components/student_fees_card.dart';

class StudentFeesPhoneView extends GetView<StudentFeeController> {
  const StudentFeesPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.loadingState.value)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: AppColors.tabBackColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_outlined,
                            color: AppColors.inverseIconColor,
                            size: 30,
                          )),
                      const SizedBox(
                        width: 32,
                      ),
                      CustomText(
                        "Student Payments".tr,
                        style: AppTextStyles.secStyle(
                            textHeader: AppTextHeaders.h2Bold),
                      ),
                    ],
                  ),
                  if (PermissionUtils.checkPermission(
                      target: "Payments", action: "studentSearch")) ...[
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextFormField(
                          controller: controller.idController,
                          validator: (id) => Validators.validateID(id),
                          labelText: "Student ID".tr,
                          icon: Icons.account_circle_outlined,
                          color: AppColors.inverseIconColor,
                          width: Get.width * 0.65,
                          onFieldSubmitted: (e) {},
                        ),
                        CustomButton(
                          onPress: controller.findButtonClick,
                          text: "Find".tr,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Payments".tr,
                          style: AppTextStyles.highlightStyle(
                              textHeader: AppTextHeaders.h2Bold),
                        ),
                        if ((PermissionUtils.checkPermission(
                            target: "Exams", action: "add")))
                          CustomButton(
                            onPress: controller.addButtonClick,
                            text: "Add Exam".tr,
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => controller.refresh(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        clipBehavior: Clip.antiAlias,
                        child: Obx(
                          () => Column(
                            children: [
                              if (controller.studentFees.isEmpty) ...[
                                SizedBox(
                                  height: Get.height * 0.2,
                                ),
                                Center(
                                    child: CustomText(
                                  controller.fieldMessage.value,
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h2Bold),
                                )),
                                if(controller.studentId != null)
                                  IconButton(
                                      onPressed: () async => controller.refresh(),
                                      icon: const Icon(
                                        Icons.refresh,
                                        size: 40,
                                      ))
                              ],
                              for (int i = 0;
                                  i < (controller.studentFees.length);
                                  i++) ...[
                                StudentFeeCard(
                                    studentFee: Rx<StudentFee>(
                                        controller.studentFees.values.toList()[i])),
                                const SizedBox(
                                  height: 24,
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/student_fees_controller.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/validators.dart';
import 'package:ibb_university_students_services/app/views/student_fees_view/student_fees_view_components/student_fees_card.dart';

class StudentFeesWebView extends GetView<StudentFeeController> {
  const StudentFeesWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.tabBackColor,
        padding: const EdgeInsets.only(top: 22, left: 12, right: 12),
        child: Obx(
          () => (controller.loadingState.value)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    if (UserRepository.currentUserType() == Doctor) ...[
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextFormField(
                            controller: controller.idController,
                            validator: (id) => Validators.validateID(id),
                            labelText: "Student ID".tr,
                            keyboardType: TextInputType.number,
                            icon: Icons.account_circle_outlined,
                            color: AppColors.inverseIconColor,
                            width: Get.width * 0.4,
                            onFieldSubmitted: (e) {},
                          ),
                          CustomButton(
                            onPress: controller.findButtonClick,
                            text: "Find".tr,
                          ),
                          if ((UserRepository.checkPermission(
                              target: "student_fees", action: "write")))
                            SizedBox(
                              width: Get.width * 0.2,
                              child: CustomButton(
                                onPress: controller.addButtonClick,
                                text: "Add Payment".tr,
                              ),
                            ),
                        ],
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
                                  if (controller.studentId != null)
                                    IconButton(
                                        onPressed: () async =>
                                            controller.refresh(),
                                        icon: const Icon(
                                          Icons.refresh,
                                          size: 40,
                                        ))
                                ],
                                SizedBox(
                                  height: Get.width * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        for (int i = 0;
                                            i < (controller.studentFees.length);
                                            i += 2) ...[
                                          StudentFeeCard(
                                              studentFee: Rx<StudentFee>(
                                                  controller.studentFees.values
                                                      .toList()[i])),
                                          const SizedBox(
                                            height: 24,
                                          )
                                        ],
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        for (int i = 1;
                                            i < (controller.studentFees.length);
                                            i += 2) ...[
                                          StudentFeeCard(
                                              studentFee: Rx<StudentFee>(
                                                  controller.studentFees.values
                                                      .toList()[i])),
                                          const SizedBox(
                                            height: 24,
                                          )
                                        ]
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }
}

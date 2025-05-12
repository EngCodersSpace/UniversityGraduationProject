import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/validators.dart';

import '../../controllers/student_result_controller.dart';

class StudentResultsWebView extends GetView<StudentResultController> {
  const StudentResultsWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: AppColors.tabBackColor,
      child: Obx(
        () => (controller.loadingState.value)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: AppColors.mainCardColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 5),
                        )
                      ],
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(32)),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomText(
                              "Level",
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Bold),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.inverseCardColor,
                                  borderRadius: BorderRadius.circular(24)),
                              width: Get.width * 0.08,
                              child: Obx(() => Center(
                                    child: DropdownButton(
                                      items: controller.levels,
                                      onChanged: controller.changeLevel,
                                      value: controller.selectedLevel.value,
                                      underline: const SizedBox(),
                                      iconEnabledColor: AppColors.mainCardColor,
                                      dropdownColor: AppColors.inverseCardColor,
                                    ),
                                  )),
                            ),
                            CustomText(
                              "Term",
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Bold),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.inverseCardColor,
                                  borderRadius: BorderRadius.circular(24)),
                              width: Get.width * 0.1,
                              child: Obx(() => Center(
                                    child: DropdownButton(
                                      items: controller.terms,
                                      onChanged: controller.changeTerm,
                                      value: controller.selectedTerm.value,
                                      underline: const SizedBox(),
                                      iconEnabledColor: AppColors.mainCardColor,
                                      dropdownColor: AppColors.inverseCardColor,
                                    ),
                                  )),
                            ),
                            if (UserRepository.checkPermission(
                                target: "Payments",
                                action: "studentSearch")) ...[
                              CustomTextFormField(
                                controller: controller.idController,
                                validator: (id) => Validators.validateID(id),
                                labelText: "Student ID",
                                keyboardType: TextInputType.number,
                                color: AppColors.inverseIconColor,
                                width: Get.width * 0.5,
                                onFieldSubmitted: (e) =>
                                    controller.findButtonClick(),
                              ),
                              CustomButton(
                                onPress: controller.findButtonClick,
                                text: "Find".tr,
                              )
                            ],
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Sumation",
                              style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Bold,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Obx(() => CustomText(
                                  "${controller.summation.value}",
                                  style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold,
                                  ),
                                )),
                            SizedBox(
                              width: Get.width * 0.3,
                            ),
                            CustomText(
                              "Percentage",
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Bold),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Obx(() => CustomText(
                                  "${controller.gpa.value.toStringAsFixed(2)}%",
                                  style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold,
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/validators.dart';
import 'package:ibb_university_students_services/app/views/student_results_view/student_results_view_components/result_card.dart';
import 'package:ibb_university_students_services/app/views/student_results_view/student_results_view_components/result_header_card.dart';

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
                    height: Get.height * 0.17,
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
                    padding: EdgeInsets.only(top: 20, left: 12, right: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  "Level",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.inverseCardColor,
                                      borderRadius: BorderRadius.circular(24)),
                                  width: Get.width * 0.07,
                                  child: Obx(() => Center(
                                        child: DropdownButton(
                                          items: controller.levels,
                                          onChanged: controller.changeLevel,
                                          value: controller.selectedLevel.value,
                                          underline: const SizedBox(),
                                          iconEnabledColor:
                                              AppColors.mainCardColor,
                                          dropdownColor:
                                              AppColors.inverseCardColor,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CustomText(
                                  "Term",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.inverseCardColor,
                                      borderRadius: BorderRadius.circular(24)),
                                  width: Get.width * 0.08,
                                  child: Obx(() => Center(
                                        child: DropdownButton(
                                          items: controller.terms,
                                          onChanged: controller.changeTerm,
                                          value: controller.selectedTerm.value,
                                          underline: const SizedBox(),
                                          iconEnabledColor:
                                              AppColors.mainCardColor,
                                          dropdownColor:
                                              AppColors.inverseCardColor,
                                        ),
                                      )),
                                ),
                              ],
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
                                width: Get.width * 0.3,
                                onFieldSubmitted: (e) =>
                                    controller.findButtonClick(),
                              ),
                              CustomButton(
                                onPress: controller.findButtonClick,
                                text: "Find".tr,
                              )
                            ],
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Sumation :",
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
                              width: Get.width * 0.2,
                            ),
                            CustomText(
                              "Percentage :",
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
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 8, bottom: 32),
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          ResultHeaderCard(),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async => controller.refresh(),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Column(
                                  children: [
                                    SizedBox(height: 8),
                                    if ((controller.grads?.value.isEmpty ??
                                        true)) ...[
                                      SizedBox(
                                        height: Get.height * 0.2,
                                      ),
                                      Center(
                                          child: CustomText(
                                        controller.failedMessage.value,
                                        style: AppTextStyles.secStyle(
                                            textHeader: AppTextHeaders.h2Bold),
                                      )),
                                      IconButton(
                                          onPressed: () async =>
                                              controller.refresh(),
                                          icon: const Icon(
                                            Icons.refresh,
                                            size: 40,
                                          ))
                                    ],
                                    for (int i = 0;
                                        i <
                                            (controller.grads?.value.length ??
                                                0);
                                        i++) ...[
                                      (i % 2 == 0)
                                          ? ResultCard(
                                              grad: Rx(
                                                  controller.grads!.value[i]))
                                          : ResultCard(
                                              grad: Rx(
                                                  controller.grads!.value[i]),
                                              type: "odd",
                                            ),
                                      if (i <
                                          ((controller.grads?.value.length ??
                                                  0) -
                                              1))
                                        SizedBox(
                                          height: Get.height * 0.005,
                                        )
                                    ]
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

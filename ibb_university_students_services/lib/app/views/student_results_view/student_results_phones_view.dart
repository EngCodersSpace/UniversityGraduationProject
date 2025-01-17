// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/student_result_controller.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/student_results_view/student_results_view_components/result_card.dart';
import 'package:ibb_university_students_services/app/views/student_results_view/student_results_view_components/result_header_card.dart';
import '../../components/custom_text_v2.dart';
import '../../styles/app_colors.dart';

class PhoneStudentResultView extends GetView<StudentResultController> {
  PhoneStudentResultView({super.key});

  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tabBackColor,
      child: Obx(() => (controller.loadingState.value)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                    height: Get.height * 0.25,
                    width: width,
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 8,),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => Get.back(),
                                icon: Icon(
                                  Icons.arrow_back_outlined,
                                  color: AppColors.inverseIconColor,
                                )),
                            CustomText(
                              "Student Grads",
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h2Bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: ((Get.width - 16) / 7) * 3.1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        "Level:",
                                        style: AppTextStyles.secStyle(
                                            textHeader: AppTextHeaders.h3Bold),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.inverseCardColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      width: Get.width / 3.3,
                                      child: Center(
                                        child: Obx(
                                          () => DropdownButton(
                                            items: controller.levels,
                                            onChanged: controller.changeLevel,
                                            value:
                                                controller.selectedLevel.value,
                                            underline: const SizedBox(),
                                            iconEnabledColor:
                                                AppColors.mainCardColor,
                                            dropdownColor:
                                                AppColors.inverseCardColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              width: ((Get.width - 16) / 7) * 0.4,
                            ),
                            SizedBox(
                                width: ((Get.width - 16) / 7) * 3.1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        "Term:",
                                        style: AppTextStyles.secStyle(
                                            textHeader: AppTextHeaders.h3Bold),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.inverseCardColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      width: Get.width / 3.3,
                                      child: Center(
                                        child: Obx(
                                          () => DropdownButton(
                                            items: controller.terms,
                                            onChanged: controller.changeTerm,
                                            value:
                                                controller.selectedTerm.value,
                                            underline: const SizedBox(),
                                            iconEnabledColor:
                                                AppColors.mainCardColor,
                                            dropdownColor:
                                                AppColors.inverseCardColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  "GPA:",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Obx(()=>CustomText(
                                  "${controller.gpa.value.toStringAsFixed(2)}%",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                ),)
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  "Summation:",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Obx(()=>CustomText(
                                  "${controller.summation.value}",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                ),)
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(height: 32,),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: width,
                    height: Get.height * 0.65,
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const ResultHeaderCard(),
                        RefreshIndicator(
                          onRefresh: () async => controller.refresh(),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: Get.height * 0.015),
                                if((controller.grads?.value.isEmpty??true) )...[
                                  SizedBox(height: Get.height*0.2,),
                                  Center(child: CustomText(controller.failedMessage.value,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),)),
                                  IconButton(onPressed: ()async=>controller.refresh(), icon: const Icon(Icons.refresh,size: 40,))
                                ],
                                for (int i = 0;
                                i < (controller.grads?.value.length ?? 0);
                                i++) ...[
                                  (i % 2 == 0)
                                      ? ResultCard(
                                      grad:
                                      Rx(controller.grads!.value[i]))
                                      : ResultCard(
                                    grad:
                                    Rx(controller.grads!.value[i]),
                                    type: "odd",
                                  ),
                                  if (i <
                                      ((controller.grads?.value.length ?? 0) -
                                          1))
                                    SizedBox(
                                      height: Get.height * 0.005,
                                    )
                                ]
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
    );
  }
}

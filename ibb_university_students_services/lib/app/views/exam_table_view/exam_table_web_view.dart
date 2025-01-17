// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/exam_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/exam_table_view/exam_table_view_components/exam_card.dart';
import '../../components/custom_text_v2.dart';
import '../../styles/text_styles.dart';

class ExamTableWebView extends GetView<ExamTableController> {
  double width = Get.width;
  double height = Get.height;

  ExamTableWebView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ExamTableController());
    return Scaffold(
      body: Obx(
        () => (controller.loadingState.value)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: width,
                      height: height * 0.8,
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  "Exams ",
                                  style: AppTextStyles.highlightStyle(textHeader: AppTextHeaders.h2Bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            for (int i = 0;
                                i < controller.exams!.value.length;
                                i++) ...[
                              ExamCard(content: Rx(controller.exams?.value[i])),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    width: width,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      color: AppColors.mainTextColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 5),
                        )
                      ],
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomText(
                          "Section".tr,
                          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
                        ),
                        SizedBox(
                          width: width * 0.008,
                        ),
                        Container(
                          height: height * 0.1,
                          width: width * 0.15,
                          decoration: BoxDecoration(
                            color: AppColors.inverseIconColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Obx(
                              () => DropdownButton(
                                items: controller.sections,
                                onChanged: controller.changeDepartment,
                                value: controller.selectedSection.value,
                                underline: const SizedBox(),
                                iconEnabledColor: AppColors.mainCardColor,
                                dropdownColor: AppColors.inverseCardColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        CustomText(
                          "Level".tr,
                          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
                        ),
                        SizedBox(
                          width: width * 0.008,
                        ),
                        Container(
                          height: height * 0.1,
                          width: width * 0.15,
                          decoration: BoxDecoration(
                            color: AppColors.inverseIconColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Obx(() => DropdownButton(
                                  items: controller.levels,
                                  onChanged: controller.changeLevel,
                                  value: controller.selectedLevel.value,
                                  underline: const SizedBox(),
                                  iconEnabledColor: AppColors.mainCardColor,
                                  dropdownColor: AppColors.inverseCardColor,
                                )),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        CustomText(
                          "Term".tr,
                          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
                        ),
                        SizedBox(
                          width: width * 0.008,
                        ),
                        Container(
                          height: height * 0.1,
                          width: width * 0.16,
                          decoration: BoxDecoration(
                            color: AppColors.inverseIconColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Obx(() => DropdownButton(
                                  items: controller.terms,
                                  onChanged: controller.changeTerm,
                                  value: controller.selectedTerm.value,
                                  underline: const SizedBox(),
                                  iconEnabledColor: AppColors.mainCardColor,
                                  dropdownColor: AppColors.inverseCardColor,
                                )),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        CustomText(
                          "Year".tr,
                          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
                        ),
                        SizedBox(
                          width: width * 0.008,
                        ),
                        Container(
                          height: height * 0.1,
                          width: width * 0.15,
                          decoration: BoxDecoration(
                            color: AppColors.inverseIconColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Obx(() => DropdownButton(
                                  items: controller.years,
                                  onChanged: controller.changeYear,
                                  value: controller.selectedYear.value,
                                  underline: const SizedBox(),
                                  iconEnabledColor: AppColors.mainCardColor,
                                  dropdownColor: AppColors.inverseCardColor,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

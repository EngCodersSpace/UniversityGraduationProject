import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/exam_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';

import '../../components/custom_text.dart';

class ExamTableWebView extends GetView<ExamTableController> {
  double width = Get.width;
  double height = Get.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => (controller.loadingState.value)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Stack(
                  children: [
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
                          SecText(
                            "Section".tr,
                            fontWeight: FontWeight.bold,
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
                                  items: controller.departments,
                                  onChanged: controller.changeDepartment,
                                  value: controller.selectedDepartment.value,
                                  underline: const SizedBox(),
                                  iconEnabledColor: AppColors.mainCardColor,
                                  dropdownColor: AppColors.inverseCardColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                          SecText(
                            "Level".tr,
                            fontWeight: FontWeight.bold,
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
                            width: width * 0.05,
                          ),
                          SecText(
                            "Term".tr,
                            fontWeight: FontWeight.bold,
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
                            width: width * 0.05,
                          ),
                          SecText(
                            "Year".tr,
                            fontWeight: FontWeight.bold,
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
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      width: width,
                      height: height * 0.5,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SecText(
                                "Exams ",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                textColor: AppColors.highlightTextColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

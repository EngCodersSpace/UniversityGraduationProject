// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/exam_table_controller.dart';
import '../../globals.dart';

class PhoneExamTableView extends GetView<ExamTableController> {
  PhoneExamTableView({super.key});

  double height = Get.height * (1 - 0.09);
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainCardColor,
        foregroundColor: AppColors.inverseCardColor,
        // toolbarHeight: 35,
      ),
      body: Obx(() =>(controller.loadingState.value)?const Center(child: CircularProgressIndicator(),):Container(
        color: AppColors.tabBackColor,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                  width: width,
                  height: height * 0.78,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.03),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SecText("Exams".tr,
                                textColor: AppColors.inverseSecTextColor),
                          ],
                        ),
                        SizedBox(height: height * 0.03),
                        for (int i = 0;
                        i <  0;
                        i++)...[]
                      ],
                    ),
                  )),
            ),
            Container(
                height: height * 0.15,
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
                  borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: ((Get.width-16) / 7)*3.5,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SecText(
                                    "Section:",
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.bold,
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
                                        items: controller.departments,
                                        onChanged: controller.changeDepartment,
                                        value:
                                        controller.selectedDepartment.value,
                                        underline: const SizedBox(),
                                        iconEnabledColor: AppColors.mainCardColor,
                                        dropdownColor:
                                        AppColors.inverseCardColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ((Get.width-16) / 7)*0.1,),
                              ],
                            )),
                        SizedBox(width: ((Get.width-16) / 7)*0.4,),
                        SizedBox(
                            width: ((Get.width-16) / 7)*3.1,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SecText(
                                    "Level:",
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.start,
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
                                        iconEnabledColor: AppColors.mainCardColor,
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
                      height: height * 0.004,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: ((Get.width-16) / 7)*3.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SecText(
                                    "     Year:",
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.start,
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
                                        items: controller.years,
                                        onChanged: controller.changeYear,
                                        value:
                                        controller.selectedYear.value,
                                        underline: const SizedBox(),
                                        iconEnabledColor: AppColors.mainCardColor,
                                        dropdownColor:
                                        AppColors.inverseCardColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ((Get.width-16) / 7)*0.1,),
                              ],
                            )),
                        SizedBox(width: ((Get.width-16) / 7)*0.4,),
                        SizedBox(
                            width: ((Get.width-16) / 7)*3.1,
                            child: Row(
                              children: [
                                Expanded(child: SecText(
                                  "Term:",
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.bold,
                                ),),
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
                                        iconEnabledColor: AppColors.mainCardColor,
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
                  ],
                )),
          ],
        ),
      )),
    );
  }
}

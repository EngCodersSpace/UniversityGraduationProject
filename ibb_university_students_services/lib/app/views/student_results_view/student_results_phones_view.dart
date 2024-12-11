// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/stydent_result_controller.dart';
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
              child: Container(
                width: width,
                height: Get.height*0.7,
                padding: const EdgeInsets.only(top: 8,bottom: 32),
                margin: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ResultHeaderCard(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6),
                        child: Column(
                          children: [
                            SizedBox(height: Get.height * 0.015),
                            for (int i = 0;
                            i <  (10);
                            i++)...[
                              (i%2 == 0)?ResultCard():ResultCard(type: "odd",),
                              if (i < ((10) - 1))
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
            Container(
                height: Get.height * 0.15,
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
                            width: ((Get.width-16) / 7)*3.1,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    "Level:",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),
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
                        SizedBox(width: ((Get.width-16) / 7)*0.4,),
                        SizedBox(
                            width: ((Get.width-16) / 7)*3.1,
                            child: Row(
                              children: [
                                Expanded(child: CustomText(
                                  "Term:",
                                  style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),
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
                              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),
                            ),
                            const SizedBox(width: 4,),
                            CustomText(
                              "99%",
                              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              "Summation:",
                              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),
                            ),
                            const SizedBox(width: 4,),
                            CustomText(
                              "990",
                              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3),
                            ),
                          ],
                        ),
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

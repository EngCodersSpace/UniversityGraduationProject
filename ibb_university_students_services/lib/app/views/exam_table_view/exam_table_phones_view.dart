// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/exam_table_controller.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_v2.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';
import '../../utils/permission_checker.dart';
import 'exam_table_view_components/exam_card.dart';

class PhoneExamTableView extends GetView<ExamTableController> {
  PhoneExamTableView({super.key});

  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Obx(() =>(controller.loadingState.value)?const Center(child: CircularProgressIndicator(),):Container(
      color: AppColors.tabBackColor,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                  height: Get.height * 0.22,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.arrow_back_outlined,
                                color: AppColors.inverseIconColor,
                              )),
                          CustomText(
                            "Exams Table".tr,
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h2),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: ((Get.width-16) / 7)*3.5,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SecText(
                                      "${"Section".tr}:",
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
                                      "${"Level".tr}:",
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
                        height: Get.height * 0.04,
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //         width: ((Get.width-16) / 7)*3.5,
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Expanded(
                      //               child: SecText(
                      //                 "     Year:",
                      //                 fontWeight: FontWeight.bold,
                      //                 textAlign: TextAlign.start,
                      //               ),
                      //             ),
                      //             Container(
                      //               decoration: BoxDecoration(
                      //                 color: AppColors.inverseCardColor,
                      //                 borderRadius: BorderRadius.circular(24),
                      //               ),
                      //               width: Get.width / 3.3,
                      //               child: Center(
                      //                 child: Obx(
                      //                       () => DropdownButton(
                      //                     items: controller.years,
                      //                     onChanged: controller.changeYear,
                      //                     value:
                      //                     controller.selectedYear.value,
                      //                     underline: const SizedBox(),
                      //                     iconEnabledColor: AppColors.mainCardColor,
                      //                     dropdownColor:
                      //                     AppColors.inverseCardColor,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //             SizedBox(width: ((Get.width-16) / 7)*0.1,),
                      //           ],
                      //         )),
                      //     SizedBox(width: ((Get.width-16) / 7)*0.4,),
                      //     SizedBox(
                      //         width: ((Get.width-16) / 7)*3.1,
                      //         child: Row(
                      //           children: [
                      //             Expanded(child: SecText(
                      //               "Term:",
                      //               textAlign: TextAlign.start,
                      //               fontWeight: FontWeight.bold,
                      //             ),),
                      //             Container(
                      //               decoration: BoxDecoration(
                      //                 color: AppColors.inverseCardColor,
                      //                 borderRadius: BorderRadius.circular(24),
                      //               ),
                      //               width: Get.width / 3.3,
                      //               child: Center(
                      //                 child: Obx(
                      //                       () => DropdownButton(
                      //                     items: controller.terms,
                      //                     onChanged: controller.changeTerm,
                      //                     value:
                      //                     controller.selectedTerm.value,
                      //                     underline: const SizedBox(),
                      //                     iconEnabledColor: AppColors.mainCardColor,
                      //                     dropdownColor:
                      //                     AppColors.inverseCardColor,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         )),
                      //   ],
                      // ),
                    ],
                  )),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText("Exams".tr,
                      style: AppTextStyles.highlightStyle(textHeader: AppTextHeaders.h2),),
                    if((PermissionUtils.checkPermission(target: "Exams",action: "add")))
                      CustomButton(onPress: controller.addButtonClick,text: "Add Exam".tr,),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                width: width,
                height: (PermissionUtils.checkPermission(target: "Exams",action: "add"))?Get.height * 0.7:Get.height * 0.73,
                child: RefreshIndicator(
                  onRefresh: ()async=>controller.refresh()
                ,child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: Get.height * 0.01),
                  child: Obx(()=>Column(
                    children: [
                      SizedBox(height: Get.height * 0.01),
                      if(controller.exams?.value.isEmpty??true)...[
                        SizedBox(height: Get.height*0.2,),
                        Center(child: CustomText(controller.fieldMessage.value,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2),)),
                        IconButton(onPressed: ()async=>controller.refresh(), icon: const Icon(Icons.refresh))
                      ],
                      for (int i = 0;
                      i <  (controller.exams?.value.length??0);
                      i++)...[
                        ExamCard(
                          content: Rx(controller.exams?.value.values.toList()[i]),
                        ),
                        if (i < ((controller.exams?.value.length ?? 0) - 1))
                          SizedBox(
                            height: Get.height * 0.03,
                          )
                      ]
                    ],
                  ),)
                ),)),
          ),
        ],
      ),
    ));
  }
}

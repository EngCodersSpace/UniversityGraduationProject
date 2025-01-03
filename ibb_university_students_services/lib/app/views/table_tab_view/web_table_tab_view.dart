import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/lecture_table_tab_view_controller.dart';
import '../../styles/app_colors.dart';

// ignore: must_be_immutable
class WebTableTabView extends GetView<LectureController> {
  double width = Get.width;
  double height = Get.height;

  WebTableTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.loadState.value)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
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
                      width: width * 0.03,
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
                      width: width * 0.03,
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
                      width: width * 0.03,
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
              // SingleChildScrollView(
              //   padding: const EdgeInsets.all(10),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       SizedBox(
              //         width: width * 0.6,
              //         child: Table(
              //           border: TableBorder.all(
              //               width: 1,
              //               color: Colors.black,
              //               style: BorderStyle.solid),
              //           defaultVerticalAlignment:
              //               TableCellVerticalAlignment.middle,
              //           children: [
              //             TableRow(
              //                 decoration: BoxDecoration(
              //                     color: AppColors.inverseCardColor
              //                         .withOpacity(0.2)),
              //                 children: [
              //                   TableCell(
              //                     verticalAlignment:
              //                         TableCellVerticalAlignment.middle,
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8),
              //                       child: SecText("Level 1".tr),
              //                     ),
              //                   ),
              //                   TableCell(
              //                     verticalAlignment:
              //                         TableCellVerticalAlignment.middle,
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8),
              //                       child: SecText("Level 2".tr),
              //                     ),
              //                   ),
              //                   TableCell(
              //                     verticalAlignment:
              //                         TableCellVerticalAlignment.middle,
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8),
              //                       child: SecText("Level 3".tr),
              //                     ),
              //                   ),
              //                   TableCell(
              //                     verticalAlignment:
              //                         TableCellVerticalAlignment.middle,
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8),
              //                       child: SecText("Level 4".tr),
              //                     ),
              //                   ),
              //                   TableCell(
              //                     verticalAlignment:
              //                         TableCellVerticalAlignment.middle,
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8),
              //                       child: SecText("Level 5".tr),
              //                     ),
              //                   ),
              //                 ]),
              //             TableRow(
              //                 decoration: BoxDecoration(
              //                   color: AppColors.tabBackColor,
              //                 ),
              //                 children: [
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText("Saterday".tr),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 1)
              //                             ? (controller.tableTime?.sat)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 2)
              //                             ? (controller.tableTime?.sat)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 3)
              //                             ? (controller.tableTime?.sat)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 4)
              //                             ? (controller.tableTime?.sat)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 5)
              //                             ? (controller.tableTime?.sat)
              //                             : null) as String),
              //                   )),
              //                 ]),
              //             TableRow(
              //                 decoration: BoxDecoration(
              //                   color: AppColors.tabBackColor,
              //                 ),
              //                 children: [
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText("Sunday".tr),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 1)
              //                             ? (controller.tableTime?.sun)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 2)
              //                             ? (controller.tableTime?.sun)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 3)
              //                             ? (controller.tableTime?.sun)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 4)
              //                             ? (controller.tableTime?.sun)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 5)
              //                             ? (controller.tableTime?.sun)
              //                             : null) as String),
              //                   )),
              //                 ]),
              //             TableRow(
              //                 decoration: BoxDecoration(
              //                   color: AppColors.tabBackColor,
              //                 ),
              //                 children: [
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText("Monday".tr),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 1)
              //                             ? (controller.tableTime?.mon)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 2)
              //                             ? (controller.tableTime?.mon)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 3)
              //                             ? (controller.tableTime?.mon)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 4)
              //                             ? (controller.tableTime?.mon)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 5)
              //                             ? (controller.tableTime?.mon)
              //                             : null) as String),
              //                   )),
              //                 ]),
              //             TableRow(
              //                 decoration: BoxDecoration(
              //                   color: AppColors.tabBackColor,
              //                 ),
              //                 children: [
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText("Tuseday".tr),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 1)
              //                             ? (controller.tableTime?.tue)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 2)
              //                             ? (controller.tableTime?.tue)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 3)
              //                             ? (controller.tableTime?.tue)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 4)
              //                             ? (controller.tableTime?.tue)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 5)
              //                             ? (controller.tableTime?.tue)
              //                             : null) as String),
              //                   )),
              //                 ]),
              //             TableRow(
              //                 decoration: BoxDecoration(
              //                   color: AppColors.tabBackColor,
              //                 ),
              //                 children: [
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText("Wednesday".tr),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 1)
              //                             ? (controller.tableTime?.wed)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 2)
              //                             ? (controller.tableTime?.wed)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 3)
              //                             ? (controller.tableTime?.wed)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 4)
              //                             ? (controller.tableTime?.wed)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 5)
              //                             ? (controller.tableTime?.wed)
              //                             : null) as String),
              //                   )),
              //                 ]),
              //             TableRow(
              //                 decoration: BoxDecoration(
              //                   color: AppColors.tabBackColor,
              //                 ),
              //                 children: [
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText("Thursday".tr),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 1)
              //                             ? (controller.tableTime?.thu)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 2)
              //                             ? (controller.tableTime?.thu)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 3)
              //                             ? (controller.tableTime?.thu)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 4)
              //                             ? (controller.tableTime?.thu)
              //                             : null) as String),
              //                   )),
              //                   TableCell(
              //                       child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: SecText(
              //                         ((controller.selectedLevel.value == 5)
              //                             ? (controller.tableTime?.thu)
              //                             : null) as String),
              //                   )),
              //                 ]),
              //           ],
              //         ),
              //       ),
              //       Container(
              //         width: width * 0.2,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ));
  }
}

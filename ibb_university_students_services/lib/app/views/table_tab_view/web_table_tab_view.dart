import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/table_tab_view_controller.dart';

import '../../styles/app_colors.dart';

// ignore: must_be_immutable
class WebTableTabView extends GetView<TableTabController> {
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
                height: height,
                color: AppColors.tabBackColor,
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SecText(
                      "Section",
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.inverseIconColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Obx(() => DropdownButton(
                              items: controller.departments,
                              onChanged: controller.changeDepartment,
                              value: controller.selectedDepartment.value,
                              underline: const SizedBox(),
                              iconEnabledColor: AppColors.mainCardColor,
                              dropdownColor: AppColors.inverseCardColor,
                            )),
                      ),
                    ),
                    // SizedBox(
                    //   width: width * 0.1,
                    // ),
                    // SecText(
                    //   "Level",
                    //   fontWeight: FontWeight.bold,
                    // ),
                    // SizedBox(
                    //   width: width * 0.02,
                    // ),
                    // Container(
                    //   width: width * 0.2,
                    //   decoration: BoxDecoration(
                    //     color: AppColors.inverseIconColor,
                    //     borderRadius: BorderRadius.circular(24),
                    //   ),
                    //   child: Center(
                    //     child: Obx(() => DropdownButton(
                    //           items: controller.levels,
                    //           onChanged: controller.changeLevel,
                    //           value: controller.selectedLevel.value,
                    //           underline: const SizedBox(),
                    //           iconEnabledColor: AppColors.mainCardColor,
                    //           dropdownColor: AppColors.inverseCardColor,
                    //         )),
                    //   ),
                    // ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    SecText(
                      "Term",
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      width: width * 0.2,
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
                      width: width * 0.1,
                    ),
                    SecText(
                      "Year",
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      width: width * 0.2,
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
                    SizedBox(
                      width: width * 0.1,
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * 0.6,
                      child: Table(
                        border: TableBorder.all(
                            width: 1,
                            color: Colors.black,
                            style: BorderStyle.solid),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                              decoration: BoxDecoration(
                                  color: AppColors.inverseCardColor
                                      .withOpacity(0.2)),
                              children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SecText("Level 1"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SecText("Level 2"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SecText("Level 3"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SecText("Level 4"),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SecText("Level 5"),
                                  ),
                                ),
                              ]),
                          TableRow(
                              decoration: BoxDecoration(
                                color: AppColors.tabBackColor,
                              ),
                              children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SecText("Saterday"),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SecText(
                                      "${controller.selectedDay.value}"),
                                ))
                              ]),
                        ],
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                    ),
                  ],
                ),
              ),
            ],
          ));
  }
}

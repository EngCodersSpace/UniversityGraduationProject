import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/lecture_table_tab_view_controller.dart';
import '../../components/custom_text.dart';
import '../../styles/app_colors.dart';

// ignore: must_be_immutable
class WebLectureTableTabView extends GetView<LectureController> {
  double width = Get.width;
  double height = Get.height;

  WebLectureTableTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.loadState.value)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            color: AppColors.tabBackColor,
            child: Column(
              children: [
                Container(
                  width: width,
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    color: AppColors.backColor,
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
                        width: width * 0.002,
                      ),
                      Container(
                        height: height * 0.1,
                        width: width * 0.14,
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
                        width: width * 0.002,
                      ),
                      Container(
                        height: height * 0.1,
                        width: width * 0.1,
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
                        width: width * 0.002,
                      ),
                      Container(
                        height: height * 0.1,
                        width: width * 0.13,
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
                        width: width * 0.002,
                      ),
                      Container(
                        height: height * 0.1,
                        width: width * 0.13,
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
                  height: height * 0.05,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Table(

                        //   border: TableBorder.all(
                        //     width: 1,
                        //     color: Colors.black,
                        //     style: BorderStyle.solid,
                        //   ),
                        //   children: [
                        //     TableRow(
                        //         decoration: BoxDecoration(
                        //             color: AppColors.inverseCardColor
                        //                 .withOpacity(0.2)),
                        //         children: [
                        //           SizedBox(
                        //             width: width * 0.2,
                        //             child: TableCell(
                        //               child: SecText(
                        //                 "Day \\ Level",
                        //                 fontSize: 18,
                        //               ),
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: width * 0.2,
                        //             child: TableCell(
                        //               child: SecText(
                        //                 "Level 1",
                        //                 fontSize: 18,
                        //               ),
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: width * 0.2,
                        //             child: TableCell(
                        //               child: SecText(
                        //                 "Level   2",
                        //                 fontSize: 18,
                        //               ),
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: width * 0.2,
                        //             child: TableCell(
                        //               child: SecText(
                        //                 "Level 3",
                        //                 fontSize: 18,
                        //               ),
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: width * 0.2,
                        //             child: TableCell(
                        //               child: SecText(
                        //                 "Level 4",
                        //                 fontSize: 18,
                        //               ),
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: width * 0.2,
                        //             child: TableCell(
                        //               child: SecText(
                        //                 "Level 5",
                        //                 fontSize: 18,
                        //               ),
                        //             ),
                        //           ),
                        //         ])
                        //   ],
                        // ),
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  AppColors.inverseCardColor.withValues(alpha:0.2),
                              border: Border.all(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SecText(
                                    "time ".tr,
                                    fontSize: 16,
                                  ),
                                  const Text(
                                    "\\",
                                    style: TextStyle(
                                      fontSize: 40,
                                    ),
                                  ),
                                  SecText(
                                    "Day".tr,
                                    fontSize: 16,
                                  ),
                                  SizedBox(
                                    width: width * 0.06,
                                  ),
                                  SecText(
                                    "Saturday".tr,
                                    fontSize: 18,
                                  ),
                                  SizedBox(
                                    width: width * 0.06,
                                  ),
                                  SecText(
                                    "Sunday".tr,
                                    fontSize: 18,
                                  ),
                                  SizedBox(
                                    width: width * 0.06,
                                  ),
                                  SecText(
                                    "Monday".tr,
                                    fontSize: 18,
                                  ),
                                  SizedBox(
                                    width: width * 0.06,
                                  ),
                                  SecText(
                                    "Tuesday".tr,
                                    fontSize: 18,
                                  ),
                                  SizedBox(
                                    width: width * 0.06,
                                  ),
                                  SecText(
                                    "Wednesday".tr,
                                    fontSize: 18,
                                  ),
                                  SizedBox(
                                    width: width * 0.06,
                                  ),
                                  SecText(
                                    "Thursday".tr,
                                    fontSize: 18,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.0,
                              ),
                              Divider(
                                thickness: 1.5,
                                color: AppColors.inverseCardColor,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SecText(
                                    "8 AM".tr,
                                    fontSize: 18,
                                  ),
                                  SizedBox(
                                    width: width * 0.06,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Divider(
                                thickness: 1.5,
                                color: AppColors.inverseCardColor,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
  }
}

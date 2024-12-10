// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/components/day_cards.dart';
import 'package:ibb_university_students_services/app/views/table_tab_view/table_tab_components/lecture_card.dart';

import '../../controllers/tabs_controller/table_tab_view_controller.dart';
import '../../styles/app_colors.dart';

class PhoneTableTabView extends GetView<TableTabController> {
  PhoneTableTabView({super.key});

  double height = Get.height * (1 - 0.09);
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.loadState.value)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    width: width,
                    height: height * 0.68,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.03),
                      child: Obx(() => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SecText("Lectures".tr,
                                      textColor: AppColors.highlightTextColor),
                                  SecText(controller.selectedDayName,
                                      textColor: AppColors.highlightTextColor)
                                ],
                              ),
                              SizedBox(height: height * 0.03),
                              for (int i = 0;
                                  i <
                                      (controller.selectedDay.value?.length ??
                                          0);
                                  i++) ...[
                                LectureCard(
                                  content: Rx(controller.selectedDay.value?[i]),
                                  height: height * 0.56 * (1 / 2),
                                ),
                                if (i <
                                    ((controller.selectedDay.value?.length ??
                                            0) -
                                        1))
                                  SizedBox(
                                    height: height * 0.03,
                                  )
                              ]
                            ],
                          )),
                    )),
              ),
              Container(
                  height: height * 0.32,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                              width: ((Get.width - 16) / 7) * 3.5,
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
                                          onChanged:
                                              controller.changeDepartment,
                                          value: controller
                                              .selectedDepartment.value,
                                          underline: const SizedBox(),
                                          iconEnabledColor:
                                              AppColors.mainCardColor,
                                          dropdownColor:
                                              AppColors.inverseCardColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ((Get.width - 16) / 7) * 0.1,
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
                                          value: controller.selectedLevel.value,
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
                        height: height * 0.004,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: ((Get.width - 16) / 7) * 3.5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          value: controller.selectedYear.value,
                                          underline: const SizedBox(),
                                          iconEnabledColor:
                                              AppColors.mainCardColor,
                                          dropdownColor:
                                              AppColors.inverseCardColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ((Get.width - 16) / 7) * 0.1,
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
                                    child: SecText(
                                      "Term:",
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
                                          items: controller.terms,
                                          onChanged: controller.changeTerm,
                                          value: controller.selectedTerm.value,
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
                        width: width * 0.96,
                        height: height * 0.12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  (controller.selected.value > 0)
                                      ? controller.selectedDayChange(
                                          controller.selected.value - 1)
                                      : null;
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColors.inverseIconColor,
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DayCard(
                                    height: height * 0.09,
                                    text: "sat".tr,
                                    selected: (controller.selected.value == 0),
                                    onPress: () {
                                      controller.selectedDayChange(0);
                                    }),
                                DayCard(
                                  height: height * 0.09,
                                  text: "sun".tr,
                                  selected: (controller.selected.value == 1),
                                  onPress: () {
                                    controller.selectedDayChange(1);
                                  },
                                ),
                                DayCard(
                                    height: height * 0.09,
                                    text: "mon".tr,
                                    selected: (controller.selected.value == 2),
                                    onPress: () {
                                      controller.selectedDayChange(2);
                                    }),
                                DayCard(
                                    height: height * 0.09,
                                    text: "tue".tr,
                                    selected: (controller.selected.value == 3),
                                    onPress: () {
                                      controller.selectedDayChange(3);
                                    }),
                                DayCard(
                                    height: height * 0.09,
                                    text: "wed".tr,
                                    selected: (controller.selected.value == 4),
                                    onPress: () {
                                      controller.selectedDayChange(4);
                                    }),
                                DayCard(
                                    height: height * 0.09,
                                    text: "thu".tr,
                                    selected: (controller.selected.value == 5),
                                    onPress: () {
                                      controller.selectedDayChange(5);
                                    }),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  (controller.selected.value < 5)
                                      ? controller.selectedDayChange(
                                          controller.selected.value + 1)
                                      : null;
                                },
                                icon: Icon(Icons.arrow_forward_ios,
                                    color: AppColors.inverseIconColor))
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ));
  }
}

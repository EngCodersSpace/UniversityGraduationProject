// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/permission_checker.dart';
import '../../components/custom_text.dart';
import '../../components/day_cards.dart';
import '../../controllers/tabs_controller/lecture_table_tab_view_controller.dart';
import '../../styles/app_colors.dart';
import 'lecture_table_tab_components/lecture_card.dart';

class PhoneLectureTableTabView extends GetView<LectureController> {
  PhoneLectureTableTabView({super.key});

  double height = Get.height * (1 - 0.09);
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.loadState.value)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Column(
                children: [
                  Container(
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
                          SizedBox(
                            height: height * 0.06,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: ((Get.width - 16) / 7) * 4,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          "${"Program".tr}:",
                                          textAlign: TextAlign.start,
                                          style: AppTextStyles.secStyle(
                                              textHeader: AppTextHeaders.h3Bold),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.inverseCardColor,
                                          borderRadius:
                                          BorderRadius.circular(24),
                                        ),
                                        width: (((Get.width - 16) / 7) * 4)*0.63,
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
                                        width: (((Get.width - 16) / 7) * 4) * 0.04,
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: ((Get.width - 16) / 7) * 0.4,
                              ),
                              SizedBox(
                                  width: ((Get.width - 16) / 7) * 2.5,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          "${"Level".tr}:",
                                          textAlign: TextAlign.start,
                                          style: AppTextStyles.secStyle(
                                              textHeader: AppTextHeaders.h3Bold),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.inverseCardColor,
                                          borderRadius:
                                          BorderRadius.circular(24),
                                        ),
                                        width: (((Get.width - 16) / 7) * 2.5)*0.6,
                                        child: Center(
                                          child: Obx(
                                                () => DropdownButton(
                                              items: controller.levels,
                                              onChanged:
                                              controller.changeLevel,
                                              value: controller
                                                  .selectedLevel.value,
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
                          if (PermissionUtils.checkPermission(
                              target: "Lectures", action: "showOldTables")) ...[
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
                                            "${"Year".tr}:",
                                            fontWeight: FontWeight.bold,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.inverseCardColor,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          width: Get.width / 3.3,
                                          child: Center(
                                            child: Obx(
                                              () => DropdownButton(
                                                items: controller.years,
                                                onChanged:
                                                    controller.changeYear,
                                                value: controller
                                                    .selectedYear.value,
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
                                            "${"Term".tr}:",
                                            textAlign: TextAlign.start,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.inverseCardColor,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          width: Get.width / 3.3,
                                          child: Center(
                                            child: Obx(
                                              () => DropdownButton(
                                                items: controller.terms,
                                                onChanged:
                                                    controller.changeTerm,
                                                value: controller
                                                    .selectedTerm.value,
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
                          ],
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
                                  ),
                                  padding: const EdgeInsets.all(0),
                                ),
                                Obx(
                                  () => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DayCard(
                                          text: "sat".tr,
                                          selected:
                                              (controller.selected.value == 0),
                                          onPress: () {
                                            controller.selectedDayChange(0);
                                          }),
                                      DayCard(
                                        text: "sun".tr,
                                        selected:
                                            (controller.selected.value == 1),
                                        onPress: () {
                                          controller.selectedDayChange(1);
                                        },
                                      ),
                                      DayCard(
                                          text: "mon".tr,
                                          selected:
                                              (controller.selected.value == 2),
                                          onPress: () {
                                            controller.selectedDayChange(2);
                                          }),
                                      DayCard(
                                          text: "tue".tr,
                                          selected:
                                              (controller.selected.value == 3),
                                          onPress: () {
                                            controller.selectedDayChange(3);
                                          }),
                                      DayCard(
                                          text: "wed".tr,
                                          selected:
                                              (controller.selected.value == 4),
                                          onPress: () {
                                            controller.selectedDayChange(4);
                                          }),
                                      DayCard(

                                          text: "thu".tr,
                                          selected:
                                              (controller.selected.value == 5),
                                          onPress: () {
                                            controller.selectedDayChange(5);
                                          }),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    (controller.selected.value < 5)
                                        ? controller.selectedDayChange(
                                            controller.selected.value + 1)
                                        : null;
                                  },
                                  icon: Icon(Icons.arrow_forward_ios,
                                      color: AppColors.inverseIconColor),
                                  padding: const EdgeInsets.all(0),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => SecText(controller.selectedDayName.tr,
                              textColor: AppColors.highlightTextColor),
                        ),
                        if ((PermissionUtils.checkPermission(
                            target: "Lectures", action: "add")))
                          CustomButton(
                            onPress: controller.addButtonClick,
                            text: "Add Lecture".tr,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () async => controller.refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Obx(() => Column(
                        children: [
                          SizedBox(height: height * 0.03),
                          if (controller
                                  .selectedDay(controller.selected.value)
                                  ?.isEmpty ??
                              true) ...[
                            SizedBox(
                              height: height * 0.2,
                            ),
                            Center(
                                child: CustomText(
                              controller.fieldMessage.value,
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h2Bold),
                            )),
                            IconButton(
                                onPressed: () async => controller.refresh(),
                                icon: const Icon(
                                  Icons.refresh,
                                  size: 40,
                                ))
                          ],
                          for (int i = 0;
                              i <
                                  (controller
                                          .selectedDay(
                                              controller.selected.value)
                                          ?.length ??
                                      0);
                              i++) ...[
                            LectureCard(
                              content: Rx(controller
                                  .selectedDay(controller.selected.value)
                                  ?.values
                                  .toList()[i]),
                              height: height * 0.56 * (1 / 2),
                            ),
                            if (i <
                                ((controller
                                            .selectedDay(
                                                controller.selected.value)
                                            ?.length ??
                                        0) -
                                    1))
                              SizedBox(
                                height: height * 0.03,
                              )
                          ]
                        ],
                      )),
                ),
              )),
              const SizedBox(
                height: 8,
              ),
            ],
          ));
  }
}

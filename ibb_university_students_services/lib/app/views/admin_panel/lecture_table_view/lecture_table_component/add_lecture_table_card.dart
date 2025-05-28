import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashbord_lecture_table_controller.dart';
import 'package:ibb_university_students_services/app/models/instructor_model/instructor_model.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';

class PopUpAddLectureCard extends GetView<DashboardLectureTableController> {
  const PopUpAddLectureCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "PopUpInsertCard",
          child: Material(
            color: AppColors.mainCardColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
                side: BorderSide(
                  color: AppColors.inverseCardColor,
                  width: 3,
                )),
            child: SizedBox(
                height: Get.height * 0.9,
                width: Get.width * 0.4,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText("Program".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.23,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Obx(() => DropdownButton<int?>(
                                        value: controller.SectionId.value,
                                        icon: Icon(Icons.arrow_drop_down_sharp,
                                            color: AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor: AppColors.mainCardColor,
                                        onChanged: (val) {
                                          if (val == null) return;
                                          controller.SectionId.value = val;
                                        },
                                        isExpanded: true,
                                        menuWidth: Get.width * 0.3,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Section sectionI
                                              in (controller.section.values)) {
                                            items.add(DropdownMenuItem<int?>(
                                              value: sectionI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.28,
                                                  child: CustomText(
                                                    sectionI.name ??
                                                        "Unknown".tr,
                                                    style:
                                                        AppTextStyles.secStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h3Bold),
                                                    softWrap: false,
                                                  )),
                                            ));
                                          }
                                          return items;
                                        },
                                        items: [
                                          for (Section sectionI in (controller
                                              .section.values)) ...[
                                            DropdownMenuItem<int?>(
                                                value: sectionI.id,
                                                child: Column(
                                                  children: [
                                                    CustomText(
                                                      sectionI.name ??
                                                          "Unknown",
                                                      style: AppTextStyles
                                                          .secStyle(
                                                              textHeader:
                                                                  AppTextHeaders
                                                                      .h3Bold),
                                                    ),
                                                    // Divider(color: AppColors.highlightTextColor,)
                                                  ],
                                                )),
                                          ]
                                        ],
                                      )),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Icon(
                                  //   Icons.menu_book,
                                  //   size: 40,
                                  //   color: AppColors.inverseIconColor,
                                  // ),
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  CustomText("Level".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.23,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Obx(() => DropdownButton<int?>(
                                        value: controller.LevelId.value,
                                        icon: Icon(Icons.arrow_drop_down_sharp,
                                            color: AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor: AppColors.mainCardColor,
                                        onChanged: (val) {
                                          if (val == null) return;
                                          controller.LevelId.value = val;
                                        },
                                        isExpanded: true,
                                        menuWidth: Get.width * 0.3,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Level levelI
                                              in (controller.level ?? [])) {
                                            items.add(DropdownMenuItem<int?>(
                                              value: levelI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.28,
                                                  child: CustomText(
                                                    levelI.name ?? "Unknown".tr,
                                                    style:
                                                        AppTextStyles.secStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h3Bold),
                                                    softWrap: false,
                                                  )),
                                            ));
                                          }
                                          return items;
                                        },
                                        items: [
                                          for (Level levelI
                                              in (controller.level ?? [])) ...[
                                            DropdownMenuItem<int?>(
                                                value: levelI.id,
                                                child: Column(
                                                  children: [
                                                    CustomText(
                                                      levelI.name ?? "Unknown",
                                                      style: AppTextStyles
                                                          .secStyle(
                                                              textHeader:
                                                                  AppTextHeaders
                                                                      .h3Bold),
                                                    ),
                                                    // Divider(color: AppColors.highlightTextColor,)
                                                  ],
                                                )),
                                          ]
                                        ],
                                      )),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Term".tr,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              ),
                              SizedBox(
                                width: Get.width * 0.002,
                              ),
                              Container(
                                // height: Get.height * 0.06,
                                width: Get.width * 0.23,
                                decoration: BoxDecoration(
                                  color: AppColors.mainIconColor,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(),
                                ),
                                child: Center(
                                  child: Obx(() => DropdownButton(
                                        items: controller.terms,
                                        onChanged: controller.changeAddTerm,
                                        value: controller.TermId.value,
                                        underline: const SizedBox(),
                                        iconEnabledColor:
                                            AppColors.inverseCardColor,
                                        dropdownColor: AppColors.mainCardColor,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Days".tr,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              ),
                              SizedBox(
                                width: Get.width * 0.002,
                              ),
                              Container(
                                // height: Get.height * 0.06,
                                width: Get.width * 0.23,
                                decoration: BoxDecoration(
                                  color: AppColors.mainIconColor,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(),
                                ),
                                child: Center(
                                  child: Obx(() => DropdownButton(
                                        items: controller.days,
                                        menuWidth: Get.width * 0.2,
                                        onChanged: controller.changeAddDay,
                                        value: controller.selectedDayName.value,
                                        underline: const SizedBox(),
                                        iconEnabledColor:
                                            AppColors.inverseCardColor,
                                        dropdownColor: AppColors.mainCardColor,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Icon(
                                  //   Icons.menu_book,
                                  //   size: 40,
                                  //   color: AppColors.inverseIconColor,
                                  // ),
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  CustomText("Subject".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.23,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Obx(() => DropdownButton<String?>(
                                        value: controller.subjectId.value,
                                        icon: Icon(Icons.arrow_drop_down_sharp,
                                            color: AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor: AppColors.mainCardColor,
                                        onChanged: (val) {
                                          if (val == null) return;
                                          controller.subjectId.value = val;
                                          controller.doctorId.value = controller
                                              .subjects?[
                                                  controller.subjectId.value]
                                              ?.instructors
                                              ?.values
                                              .first
                                              .id;
                                        },
                                        isExpanded: true,
                                        menuWidth: Get.width * 0.3,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Subject subjectI in (controller
                                                  .subjects?.values
                                                  .toList()) ??
                                              []) {
                                            items.add(DropdownMenuItem<String?>(
                                              value: subjectI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.28,
                                                  child: CustomText(
                                                    subjectI.subjectName ?? "",
                                                    style:
                                                        AppTextStyles.secStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h3Bold),
                                                    softWrap: false,
                                                  )),
                                            ));
                                          }
                                          return items;
                                        },
                                        items: [
                                          for (Subject subjectI in (controller
                                                  .subjects?.values
                                                  .toList()) ??
                                              []) ...[
                                            DropdownMenuItem<String?>(
                                                value: subjectI.id,
                                                child: Column(
                                                  children: [
                                                    CustomText(
                                                      subjectI.subjectName ??
                                                          "",
                                                      style: AppTextStyles
                                                          .secStyle(
                                                              textHeader:
                                                                  AppTextHeaders
                                                                      .h3Bold),
                                                    ),
                                                    // Divider(color: AppColors.highlightTextColor,)
                                                  ],
                                                )),
                                          ]
                                        ],
                                      )),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Icon(
                                  //   Icons.menu_book,
                                  //   size: 40,
                                  //   color: AppColors.inverseIconColor,
                                  // ),
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  CustomText("Doctor".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.23,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Obx(() => DropdownButton<int?>(
                                        value: controller.doctorId.value,
                                        icon: Icon(Icons.arrow_drop_down_sharp,
                                            color: AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor: AppColors.mainCardColor,
                                        onChanged: (val) {
                                          controller.doctorId.value = val;
                                        },
                                        isExpanded: true,
                                        menuWidth: Get.width * 0.3,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Instructor instructorI
                                              in (controller
                                                      .subjects?[controller
                                                          .subjectId.value]
                                                      ?.instructors
                                                      ?.values
                                                      .toList()) ??
                                                  []) {
                                            items.add(DropdownMenuItem<int?>(
                                              value: instructorI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.28,
                                                  child: CustomText(
                                                    instructorI.name ?? "",
                                                    style:
                                                        AppTextStyles.secStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h3Bold),
                                                    softWrap: false,
                                                  )),
                                            ));
                                          }
                                          return items;
                                        },
                                        items: [
                                          for (Instructor instructorI
                                              in (controller
                                                      .subjects?[controller
                                                          .subjectId.value]
                                                      ?.instructors
                                                      ?.values
                                                      .toList()) ??
                                                  []) ...[
                                            DropdownMenuItem<int?>(
                                                value: instructorI.id,
                                                child: CustomText(
                                                  instructorI.name ??
                                                      "unknown".tr,
                                                  style: AppTextStyles.secStyle(
                                                      textHeader: AppTextHeaders
                                                          .h3Bold),
                                                )),
                                          ]
                                        ],
                                      )),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Icon(
                                  //   Icons.access_time_filled,
                                  //   size: 40,
                                  //   color: AppColors.inverseIconColor,
                                  // ),
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  CustomText("Time".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.timeController,
                                // validator: controller.validateTime,
                                labelText: "Time".tr,
                                focusNode: controller.timeFocus,
                                readOnly: true,
                                onTap: () => DateTimeUtils.timePiker(
                                    context, controller.timeController),
                                onFieldSubmitted: (e) {
                                  controller.durationFocus.requestFocus();
                                },
                                width: (Get.width - 12) * 0.23,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Icon(
                                  //   Icons.timer,
                                  //   size: 40,
                                  //   color: AppColors.inverseIconColor,
                                  // ),
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  CustomText("Duration".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.durationController,
                                labelText: "Duration".tr,
                                keyboardType: TextInputType.number,
                                focusNode: controller.durationFocus,
                                onFieldSubmitted: (e) {
                                  controller.entryYearFocus.requestFocus();
                                },
                                width: (Get.width - 12) * 0.23,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Icon(
                                  //   Icons.account_balance,
                                  //   size: 40,
                                  //   color: AppColors.inverseIconColor,
                                  // ),
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  CustomText("Hall".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.hallController,
                                // validator: controller.validateEntryYear,
                                keyboardType: TextInputType.text,
                                labelText: "Hall".tr,
                                focusNode: controller.entryYearFocus,
                                onFieldSubmitted: (e) {
                                  controller.phoneFocus.requestFocus();
                                },
                                width: (Get.width - 12) * 0.23,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                  onPress: controller.addLecture, text: "Add"),
                              CustomButton(
                                onPress: () =>
                                    Navigator.of(Get.overlayContext!).pop(),
                                text: "Close".tr,
                              ),
                            ],
                          )
                        ],
                      ),
                    ))),
          ),
        ),
      ),
    );
  }
}

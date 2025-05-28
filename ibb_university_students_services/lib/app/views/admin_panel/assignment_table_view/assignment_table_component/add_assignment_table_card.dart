import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_assignment_table_controller.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

class AddAssignmentTableCard
    extends GetView<DashboardAssignmentTableController> {
  const AddAssignmentTableCard({super.key});

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
                width: Get.width * 0.3,
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
                                width: Get.width * 0.2,
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
                                        menuWidth: Get.width * 0.2,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Section sectionI
                                              in (controller.section.values)) {
                                            items.add(DropdownMenuItem<int?>(
                                              value: sectionI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.2,
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
                                  CustomText("Level".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.2,
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
                                        menuWidth: Get.width * 0.2,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Level levelI
                                              in (controller.level ?? [])) {
                                            items.add(DropdownMenuItem<int?>(
                                              value: levelI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.2,
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
                              Row(
                                children: [
                                  CustomText("Subject".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.2,
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
                                        },
                                        isExpanded: true,
                                        menuWidth: Get.width * 0.2,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Subject subjectI in (controller
                                                  .subjects?.values
                                                  .toList()) ??
                                              []) {
                                            items.add(DropdownMenuItem<String?>(
                                              value: subjectI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.2,
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
                                  CustomText("Title".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.title,
                                labelText: "Title".tr,
                                focusNode: controller.titleFocus,
                                onFieldSubmitted: (e) {
                                  controller.dueDateFocus.requestFocus();
                                },
                                width: (Get.width - 12) * 0.2,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText("Due date".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.dueDate,
                                labelText: "Due date".tr,
                                keyboardType: TextInputType.number,
                                focusNode: controller.dueDateFocus,
                                onFieldSubmitted: (e) {
                                  controller.dueDateFocus.requestFocus();
                                },
                                width: (Get.width - 12) * 0.2,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                  onPress: controller.addAssignment,
                                  text: "Add"),
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

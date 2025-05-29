import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/study_plane_controller.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import '../../../components/buttons.dart';
import '../../../components/typeahead.dart';
import '../../../models/instructor_model/instructor_model.dart';
import '../../../models/level_model/level.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class PopUpIAddAndUpdateStudyPlanCard extends GetView<StudyPlaneController> {
  const PopUpIAddAndUpdateStudyPlanCard({super.key});

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
                height: Get.height * 0.6,
                width: Get.width,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText("${controller.mode} Payment",
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h2Bold)),
                          Row(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Level".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    width: Get.width * 0.22,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                        BorderRadius.circular(24)),
                                    child: Center(
                                      child: Obx(() => DropdownButton<int?>(
                                        value: controller.selectedLevel.value,
                                        icon: Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color:
                                            AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor:
                                        AppColors.mainCardColor,
                                        onChanged: (val) {
                                          controller.selectedLevel.value = val;
                                        },
                                        isExpanded: true,
                                        menuWidth: Get.width * 0.7,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Level level
                                          in (controller.levels.values.toList())) {
                                            items
                                                .add(DropdownMenuItem<int?>(
                                              value: level.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.28,
                                                  child: CustomText(
                                                    level.name ?? "",
                                                    style: AppTextStyles
                                                        .secStyle(
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
                                          for (Section section
                                          in (controller
                                              .sections
                                              .values
                                              .toList())) ...[
                                            DropdownMenuItem<int?>(
                                                value: section.id,
                                                child: CustomText(
                                                  section.name ??
                                                      "unknown".tr,
                                                  style: AppTextStyles
                                                      .secStyle(
                                                      textHeader:
                                                      AppTextHeaders
                                                          .h3Bold),
                                                )),
                                          ]
                                        ],
                                      )),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText("Semester".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    width: 80,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                        BorderRadius.circular(24)),
                                    child: Center(
                                      child: Obx(() => DropdownButton<int>(
                                        value:
                                        controller.selectedTerm.value,
                                        icon: Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color:
                                            AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor:
                                        AppColors.mainCardColor,
                                        onChanged: controller
                                            .changeSelectedSortDirection,
                                        isExpanded: true,
                                        items: [
                                          DropdownMenuItem<int>(
                                              value: 0,
                                              child: Center(
                                                child: CustomText(
                                                  "1St",
                                                  style: AppTextStyles
                                                      .secStyle(
                                                      textHeader:
                                                      AppTextHeaders
                                                          .h3Bold),
                                                ),
                                              )),
                                          DropdownMenuItem<int>(
                                              value: 1,
                                              child: Center(
                                                child: CustomText(
                                                  "2ec",
                                                  style: AppTextStyles
                                                      .secStyle(
                                                      textHeader:
                                                      AppTextHeaders
                                                          .h3Bold),
                                                ),
                                              )),
                                        ],
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [

                                  const SizedBox(
                                    width: 8,
                                  ),
                                  CustomText("Program".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader:
                                          AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.45,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius:
                                    BorderRadius.circular(24)),
                                child: Center(
                                  child: Obx(() => DropdownButton<int?>(
                                    value: controller.selectedSection.value,
                                    icon: Icon(
                                        Icons.arrow_drop_down_sharp,
                                        color:
                                        AppColors.inverseCardColor),
                                    underline: const SizedBox(),
                                    dropdownColor:
                                    AppColors.mainCardColor,
                                    onChanged: (val) {
                                      controller.selectedSection.value = val;
                                    },
                                    isExpanded: true,
                                    menuWidth: Get.width * 0.7,
                                    selectedItemBuilder: (_) {
                                      List<Widget> items = [];
                                      for (Section section
                                      in (controller.sections.values.toList())) {
                                        items
                                            .add(DropdownMenuItem<int?>(
                                          value: section.id,
                                          child: SizedBox(
                                              width: Get.width * 0.28,
                                              child: CustomText(
                                                section.name ?? "",
                                                style: AppTextStyles
                                                    .secStyle(
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
                                      for (Section section
                                      in (controller
                                          .sections
                                          .values
                                          .toList())) ...[
                                        DropdownMenuItem<int?>(
                                            value: section.id,
                                            child: CustomText(
                                              section.name ??
                                                  "unknown".tr,
                                              style: AppTextStyles
                                                  .secStyle(
                                                  textHeader:
                                                  AppTextHeaders
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
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Subject".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader:
                                          AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              TypeAhead<String>(
                                value: controller.subjectId.value,
                                width: (Get.width * 0.45),
                                onSelected: (String i, v) {
                                  controller.subjectId.value = i;
                                  controller.doctorId.value = controller
                                      .subjects?[controller.subjectId.value]
                                      ?.instructors
                                      ?.values
                                      .first
                                      .id;
                                },
                                icon: Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: AppColors.inverseCardColor,
                                  size: 25,
                                ),
                                label: "Select Subject",
                                items: controller.subjects?.map((i, e) =>
                                    MapEntry(i, e.subjectName ?? "")) ??
                                    {},
                                // color: AppColors.inverseCardColor,
                                menuColor: AppColors.inverseCardColor,
                                textStyle: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                                menuTextStyle: AppTextStyles.mainStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.next_plan,
                                size: 40,
                                color: AppColors.inverseIconColor,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                  width: (Get.width * 0.2),
                                  child: CustomText("StudyPlan".tr,
                                      textAlign: TextAlign.start,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold))),
                              TypeAhead(
                                width: (Get.width * 0.45),
                                onSelected: (i, v) {
                                  controller.selectedStudyPlan.value = i;
                                },
                                icon: Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: AppColors.inverseCardColor,
                                  size: 25,
                                ),
                                label: "Select Study Plan",
                                value: controller.selectedStudyPlan.value,
                                items: controller.studyPlans
                                    .map((i, e) => MapEntry(i, e.name ?? "")),
                                // color: AppColors.inverseCardColor,
                                menuColor: AppColors.inverseCardColor,
                                textStyle: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                                menuTextStyle: AppTextStyles.mainStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Doctor".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader:
                                          AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.45,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius:
                                    BorderRadius.circular(24)),
                                child: Center(
                                  child: Obx(() => DropdownButton<int?>(
                                    value: controller.doctorId.value,
                                    icon: Icon(
                                        Icons.arrow_drop_down_sharp,
                                        color:
                                        AppColors.inverseCardColor),
                                    underline: const SizedBox(),
                                    dropdownColor:
                                    AppColors.mainCardColor,
                                    onChanged: (val) {
                                      controller.doctorId.value = val;
                                    },
                                    isExpanded: true,
                                    menuWidth: Get.width * 0.7,
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
                                        items
                                            .add(DropdownMenuItem<int?>(
                                          value: instructorI.id,
                                          child: SizedBox(
                                              width: Get.width * 0.28,
                                              child: CustomText(
                                                instructorI.name ?? "",
                                                style: AppTextStyles
                                                    .secStyle(
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
                                              style: AppTextStyles
                                                  .secStyle(
                                                  textHeader:
                                                  AppTextHeaders
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                onPress: controller.addStudyPlanElement,
                                text: (controller.mode).tr,
                              ),
                              CustomButton(
                                onPress: () => Get.back(result: null),
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

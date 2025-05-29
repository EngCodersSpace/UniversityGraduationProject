// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/study_plane_controller.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/study_plane/study_plane_view_components/study_plan_element_card.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_v2.dart';
import '../../components/typeahead.dart';
import '../../models/study_plan_elements_model/study_plan_elements.dart';
import '../../repositories/user_repository.dart';
import '../../styles/app_colors.dart';
import '../../utils/screen_utils.dart';

class PhoneStudyPlaneView extends GetView<StudyPlaneController> {
  PhoneStudyPlaneView({super.key});

  double width = Get.width;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tabBackColor,
      child: Obx(() => (controller.loadingState.value)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => Get.back(),
                                icon: Icon(
                                  Icons.arrow_back_outlined,
                                  color: AppColors.inverseIconColor,
                                )),
                            CustomText(
                              "Study Planes",
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h2Bold),
                            ),
                          ],
                        ),
                        if (UserRepository.currentUserType() == Doctor) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: (Get.width * 0.2),
                                  child: CustomText("StudyPlan".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold))),
                              TypeAhead(
                                width: (Get.width * 0.5),
                                onSelected: (i, v) {
                                  controller.selectedStudyPlan.value = i;
                                },
                                label: "Select Study Plan",
                                value: controller.selectedStudyPlan.value,
                                items: controller.studyPlans
                                    .map((i, e) => MapEntry(i, e.name ?? "")),
                                color: AppColors.inverseCardColor,
                                menuColor: AppColors.inverseCardColor,
                                textStyle: AppTextStyles.mainStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                                menuTextStyle: AppTextStyles.mainStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              ),
                              if ((UserRepository.checkPermission(
                                  target: "study_plan", action: "write")))
                                CustomButton(
                                  onPress: controller.newButtonClick,
                                  text: "New".tr,
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                        Row(
                          children: [
                            SizedBox(
                                width: ((Get.width - 32) / 7) * 4,
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
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      width:
                                          (((Get.width - 16) / 7) * 4) * 0.63,
                                      child: Center(
                                        child: Obx(
                                          () => DropdownButton(
                                            items: controller.sections.values
                                                .map(
                                                    (section) =>
                                                        DropdownMenuItem<int>(
                                                            value: section.id,
                                                            child: SizedBox(
                                                              width: (((Get.width -
                                                                              16) /
                                                                          7) *
                                                                      4) *
                                                                  0.48,
                                                              child: CustomText(
                                                                section.name ??
                                                                    "unknown",
                                                                style: AppTextStyles.mainStyle(
                                                                    textHeader:
                                                                        AppTextHeaders
                                                                            .h5Bold),
                                                              ),
                                                            )))
                                                .toList(),
                                            onChanged:
                                                controller.changeDepartment,
                                            value: controller
                                                .selectedSection.value,
                                            underline: const SizedBox(),
                                            iconEnabledColor:
                                                AppColors.mainCardColor,
                                            dropdownColor:
                                                AppColors.inverseCardColor,
                                            // menuWidth: 300,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          (((Get.width - 16) / 7) * 4) * 0.04,
                                    ),
                                  ],
                                )),
                            SizedBox(
                              width: ((Get.width - 32) / 7) * 0.1,
                            ),
                            SizedBox(
                                width: ((Get.width - 32) / 7) * 2.8,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        "Level:",
                                        style: AppTextStyles.secStyle(
                                            textHeader: AppTextHeaders.h3Bold),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.inverseCardColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      width: ((Get.width - 16) / 7) * 3 * 0.6,
                                      child: Center(
                                        child: Obx(
                                          () => DropdownButton(
                                            items: controller.levels.entries
                                                .map(
                                                  (e) => DropdownMenuItem<int>(
                                                      value: e.value.id,
                                                      child: SizedBox(
                                                        width: (ScreenUtils
                                                                .isPhoneScreen())
                                                            ? ((((Get.width - 32) /
                                                                            7) *
                                                                        3) -
                                                                    50) *
                                                                0.6
                                                            : (Get.width / 8) *
                                                                0.4,
                                                        child: CustomText(
                                                          e.value.name ??
                                                              "unknown",
                                                          style: AppTextStyles
                                                              .mainStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h5Bold,
                                                          ),
                                                        ),
                                                      )),
                                                )
                                                .toList(),
                                            onChanged: controller.changeLevel,
                                            value:
                                                controller.selectedLevel.value,
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
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    )),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    margin: const EdgeInsets.all(8),
                    child: Obx(
                      () => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  "Study Plan Elements",
                                  style: AppTextStyles.highlightStyle(
                                      textHeader: AppTextHeaders.h2Bold),
                                ),
                                if ((UserRepository.checkPermission(
                                    target: "study_plan", action: "write")))
                                  CustomButton(
                                    onPress: controller.addButtonClick,
                                    text: "Add Element".tr,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (controller.selectedTerm.value == 0) ...[
                                InkWell(
                                  onTap: () =>
                                      controller.changeSelectedSortDirection(0),
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 1.0,
                                        // Right side is intentionally left out
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: CustomText(
                                      "1st Semester",
                                      style: AppTextStyles.customColorStyle(
                                          textHeader: AppTextHeaders.h2Bold,
                                          color: (Colors.blueAccent)),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      controller.changeSelectedSortDirection(1),
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: controller.borders[0],
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: CustomText(
                                      "2ec Semester",
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                InkWell(
                                  onTap: () =>
                                      controller.changeSelectedSortDirection(0),
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: controller.borders[1],
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: CustomText(
                                      "1st Semester",
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      controller.changeSelectedSortDirection(1),
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 1.0,
                                        // Right side is intentionally left out
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: CustomText(
                                      "2ec Semester",
                                      style: AppTextStyles.customColorStyle(
                                          textHeader: AppTextHeaders.h2Bold,
                                          color: (Colors.blueAccent)),
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async => controller.refresh(),
                              child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Obx(
                                    () => Column(
                                      children: [
                                        SizedBox(height: 8),
                                        if ((controller.studyPlanElement?.value
                                                .isEmpty ??
                                            true)) ...[
                                          SizedBox(
                                            height: Get.height * 0.2,
                                          ),
                                          Center(
                                              child: CustomText(
                                            controller.failedMessage.value,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h2Bold),
                                          )),
                                          if (controller
                                                  .selectedStudyPlan.value !=
                                              null)
                                            IconButton(
                                                onPressed: () async =>
                                                    controller.refresh(),
                                                icon: const Icon(
                                                  Icons.refresh,
                                                  size: 40,
                                                ))
                                        ],
                                        for (StudyPlanElement s in (controller
                                                .studyPlanElement?.value.values
                                                .where((e) => controller
                                                    .checkShowStudyPlanElements(
                                                        e)) ??
                                            [])) ...[
                                          StudyPlanElementCard(
                                              studyPlanElement: Rx(s)),
                                          SizedBox(
                                            height: 16,
                                          )
                                        ],
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
    );
  }
}

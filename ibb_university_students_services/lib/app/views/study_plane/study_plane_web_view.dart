import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/typeahead.dart';
import 'package:ibb_university_students_services/app/controllers/study_plane_controller.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/models/study_plan_elements_model/study_plan_elements.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/study_plane/study_plane_view_components/study_plan_element_card.dart';

import '../../utils/screen_utils.dart';

class WebStudyPlaneView extends GetView<StudyPlaneController> {
  const WebStudyPlaneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: AppColors.tabBackColor,
      child: Obx(
        () => (controller.loadingState.value)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height * 0.17,
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
                    padding: EdgeInsets.only(top: 20, left: 12, right: 12),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (UserRepository.currentUserType() == Doctor) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.inverseCardColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  width: Get.width * 0.13,
                                  child: Center(
                                    child: Obx(
                                      () => DropdownButton(
                                        items: controller.sections.values
                                            .map((section) => DropdownMenuItem<
                                                    int>(
                                                value: section.id,
                                                child: SizedBox(
                                                  width: (Get.width / 5) * 0.4,
                                                  child: CustomText(
                                                    section.name ?? "unknown",
                                                    style:
                                                        AppTextStyles.mainStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h5Bold),
                                                  ),
                                                )))
                                            .toList(),
                                        onChanged: controller.changeDepartment,
                                        value: controller.selectedSection.value,
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
                                  width: Get.width * 0.03,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.inverseCardColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  width: Get.width * 0.11,
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
                                                        : (Get.width / 8) * 0.4,
                                                    child: CustomText(
                                                      e.value.name ?? "unknown",
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
                                SizedBox(
                                  width: Get.width * 0.03,
                                ),
                                TypeAhead(
                                  width: (Get.width * 0.2),
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
                                SizedBox(
                                  width: Get.width * 0.05,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    if ((UserRepository.checkPermission(
                                        target: "study_plan",
                                        action: "write"))) ...[
                                      IconButton(
                                          onPressed: controller.newButtonClick,
                                          icon: Icon(
                                            Icons.add,
                                            color: AppColors.inverseCardColor,
                                          ))
                                    ],
                                    IconButton(
                                        onPressed: controller.printButtonClick,
                                        icon: Icon(
                                          Icons.print,
                                          color: AppColors.inverseCardColor,
                                        ))
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ],
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 8, bottom: 32),
                      margin: const EdgeInsets.all(8),
                      child: Obx(
                        () => Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    "Study Plan Elements",
                                    style: AppTextStyles.highlightStyle(
                                        textHeader: AppTextHeaders.h2Bold),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (controller.selectedTerm.value ==
                                          0) ...[
                                        InkWell(
                                          onTap: () => controller
                                              .changeSelectedSortDirection(0),
                                          child: Container(
                                            height: 30,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blueAccent,
                                                width: 1.0,
                                                // Right side is intentionally left out
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                              ),
                                            ),
                                            child: CustomText(
                                              "1st Semester",
                                              style: AppTextStyles
                                                  .customColorStyle(
                                                      textHeader:
                                                          AppTextHeaders.h2Bold,
                                                      color:
                                                          (Colors.blueAccent)),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => controller
                                              .changeSelectedSortDirection(1),
                                          child: Container(
                                            height: 30,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              border: controller.borders[0],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(8.0),
                                                bottomRight:
                                                    Radius.circular(8.0),
                                              ),
                                            ),
                                            child: CustomText(
                                              "2ec Semester",
                                              style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h2Bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        InkWell(
                                          onTap: () => controller
                                              .changeSelectedSortDirection(0),
                                          child: Container(
                                            height: 30,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              border: controller.borders[1],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                              ),
                                            ),
                                            child: CustomText(
                                              "1st Semester",
                                              style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h2Bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => controller
                                              .changeSelectedSortDirection(1),
                                          child: Container(
                                            height: 30,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blueAccent,
                                                width: 1.0,
                                                // Right side is intentionally left out
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(8.0),
                                                bottomRight:
                                                    Radius.circular(8.0),
                                              ),
                                            ),
                                            child: CustomText(
                                              "2ec Semester",
                                              style: AppTextStyles
                                                  .customColorStyle(
                                                      textHeader:
                                                          AppTextHeaders.h2Bold,
                                                      color:
                                                          (Colors.blueAccent)),
                                            ),
                                          ),
                                        ),
                                      ]
                                    ],
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
                              height: 16,
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async => controller.refresh(),
                                child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Obx(
                                      () => Column(
                                        children: [
                                          SizedBox(height: 8),
                                          if ((controller.studyPlanElement
                                                  ?.value.isEmpty ??
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
                                                  .studyPlanElement
                                                  ?.value
                                                  .values
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
              ),
      ),
    );
  }
}

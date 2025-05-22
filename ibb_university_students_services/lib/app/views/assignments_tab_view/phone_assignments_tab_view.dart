// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/assignments_tab_controller.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/views/assignments_tab_view/assignments_view_components/assignments_card.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_v2.dart';
import '../../components/typeahead.dart';
import '../../models/doctor_model/doctor.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';
import '../../utils/screen_utils.dart';

class PhoneAssignmentsTabView extends GetView<AssignmentsTabController> {
  PhoneAssignmentsTabView({super.key});

  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.loadingState.value)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            color: AppColors.tabBackColor,
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                        // height: Get.height * 0.18,
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
                              height: Get.height * 0.05,
                            ),
                            if (UserRepository.currentUserType() == Doctor) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      CustomText(
                                        "Section".tr,
                                        style: AppTextStyles.secStyle(
                                            textHeader: AppTextHeaders.h3Bold),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.inverseCardColor,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        width: Get.width / 3,
                                        child: Center(
                                          child: Obx(
                                            () => DropdownButton(
                                              items: (controller
                                                  .sections.entries
                                                  .map((e) {
                                                return DropdownMenuItem<int>(
                                                    value: e.value.id,
                                                    child: SizedBox(
                                                      width: (ScreenUtils
                                                              .isPhoneScreen())
                                                          ? (Get.width / 3) - 30
                                                          : (Get.width / 5.5) *
                                                              0.6,
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
                                                    ));
                                              }).toList()),
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
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        "Year".tr,
                                        style: AppTextStyles.secStyle(
                                            textHeader: AppTextHeaders.h3Bold),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.inverseCardColor,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        width: Get.width / 3,
                                        child: Center(
                                          child: Obx(
                                            () => DropdownButton(
                                              items: (controller
                                                  .sections.entries
                                                  .map((e) {
                                                return DropdownMenuItem<int>(
                                                    value: e.value.id,
                                                    child: SizedBox(
                                                      width: (ScreenUtils
                                                              .isPhoneScreen())
                                                          ? (Get.width / 3) - 30
                                                          : (Get.width / 5.5) *
                                                              0.6,
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
                                                    ));
                                              }).toList()),
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
                                    ],
                                  ),
                                ],
                              ),
                            ],
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(children: [
                                  CustomText(
                                    "Level".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.inverseCardColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    width: Get.width / 5,
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
                                ]),
                                Row(children: [
                                  CustomText(
                                    "Subject".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  TypeAhead<String>(
                                    value: controller.selectedSubject.value,
                                    width: (Get.width / 3) * 1.4,
                                    height: 50,
                                    onSelected: (String i, v) {
                                      controller.changeSubject(i);
                                    },
                                    icon: Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: AppColors.mainTextColor,
                                      size: 25,
                                    ),
                                    label: "Select Subject",
                                    items: controller.subjects?.map((i, e) =>
                                            MapEntry(i, e.subjectName ?? "")) ??
                                        {},
                                    color: AppColors.inverseCardColor,
                                    menuColor: AppColors.inverseCardColor,
                                    textStyle: AppTextStyles.mainStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                    menuTextStyle: AppTextStyles.mainStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                ])
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                          ],
                        )),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            "Assignments".tr,
                            style: AppTextStyles.highlightStyle(
                                textHeader: AppTextHeaders.h2Bold),
                          ),
                          if ((UserRepository.checkPermission(
                              target: "assignments", action: "write")))
                            CustomButton(
                              onPress: controller.addButtonClick,
                              text: "Add Assignment".tr,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    width: width,
                    child: RefreshIndicator(
                        onRefresh: () async => controller.refresh(),
                        child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: Get.height * 0.01),
                            child: Obx(
                              () => Column(
                                children: [
                                  SizedBox(height: Get.height * 0.01),
                                  if (controller.assignments?.value.isEmpty ??
                                      true) ...[
                                    SizedBox(
                                      height: Get.height * 0.2,
                                    ),
                                    Center(
                                        child: CustomText(
                                      controller.fieldMessage.value,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h2Bold),
                                    )),
                                    IconButton(
                                        onPressed: () async =>
                                            controller.refresh(),
                                        icon: const Icon(Icons.refresh))
                                  ],
                                  for (int i = 0;
                                      i <
                                          (controller
                                                  .assignments?.value.length ??
                                              0);
                                      i++) ...[
                                    AssignmentsCard(
                                        content: Rx(controller
                                            .assignments?.value.values
                                            .toList()[i])),
                                    if (i <
                                        ((controller.assignments?.value
                                                    .length ??
                                                0) -
                                            1))
                                      SizedBox(
                                        height: Get.height * 0.03,
                                      )
                                  ]
                                ],
                              ),
                            )),
                      ),
                  ),
                ),
                SizedBox(height: 16,)
              ],
            ),
          ));
  }
}

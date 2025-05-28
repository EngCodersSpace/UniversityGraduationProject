import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/typeahead.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/assignments_tab_controller.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/screen_utils.dart';
import 'package:ibb_university_students_services/app/views/assignments_tab_view/assignments_view_components/assignments_card.dart';

class WebAssignmentsTabView extends GetView<AssignmentsTabController> {
  const WebAssignmentsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.loadingState.value)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            color: AppColors.tabBackColor,
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                        height: Get.height * 0.18,
                        width: Get.width,
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
                              height: Get.height * 0.02,
                            ),
                            if (UserRepository.currentUserType() == Doctor) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    "Program".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.01,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.inverseCardColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    width: Get.width * 0.12,
                                    child: Center(
                                      child: Obx(
                                        () => DropdownButton(
                                          items: (controller.sections.entries
                                              .map((e) {
                                            return DropdownMenuItem<int>(
                                                value: e.value.id,
                                                child: SizedBox(
                                                  width: (ScreenUtils
                                                          .isPhoneScreen())
                                                      ? (Get.width / 3) - 30
                                                      : (Get.width / 6) * 0.5,
                                                  child: CustomText(
                                                    e.value.name ?? "unknown",
                                                    style:
                                                        AppTextStyles.mainStyle(
                                                      textHeader:
                                                          AppTextHeaders.h5Bold,
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
                                  SizedBox(
                                    width: Get.width * 0.02,
                                  ),
                                  CustomText(
                                    "Level".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.01,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.inverseCardColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    width: Get.width * 0.08,
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
                                  SizedBox(
                                    width: Get.width * 0.02,
                                  ),
                                  CustomText(
                                    "Subject".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.01,
                                  ),
                                  TypeAhead<String>(
                                    value: controller.selectedSubject.value,
                                    width: (Get.width * 0.18),
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
                                  SizedBox(
                                    width: Get.width * 0.02,
                                  ),
                                  CustomText(
                                    "Year".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.01,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.inverseCardColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    width: Get.width * 0.13,
                                    child: Center(
                                      child: Obx(
                                        () => DropdownButton<int>(
                                          items: (controller.years.map((e) {
                                            if (e == -1) {
                                              return DropdownMenuItem<int>(
                                                  value: e,
                                                  child: SizedBox(
                                                    width: (ScreenUtils
                                                            .isPhoneScreen())
                                                        ? (Get.width / 3) - 30
                                                        : (Get.width / 3) * 0.3,
                                                    child: CustomText(
                                                      "Add",
                                                      style: AppTextStyles
                                                          .mainStyle(
                                                        textHeader:
                                                            AppTextHeaders
                                                                .h5Bold,
                                                      ),
                                                    ),
                                                  ));
                                            } else {
                                              return DropdownMenuItem<int>(
                                                  value: e,
                                                  child: SizedBox(
                                                    width: (ScreenUtils
                                                            .isPhoneScreen())
                                                        ? (Get.width / 3) - 30
                                                        : (Get.width / 5.5) *
                                                            0.6,
                                                    child: CustomText(
                                                      e.toString(),
                                                      style: AppTextStyles
                                                          .mainStyle(
                                                        textHeader:
                                                            AppTextHeaders
                                                                .h5Bold,
                                                      ),
                                                    ),
                                                  ));
                                            }
                                          }).toList()),
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
                                ],
                              ),
                            ] else ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    "Subject".tr,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h1Bold),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.02,
                                  ),
                                  TypeAhead<String>(
                                    value: controller.selectedSubject.value,
                                    width: (Get.width * 0.3),
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
                                ],
                              ),
                            ],
                            SizedBox(
                              height: Get.height * 0.04,
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      width: Get.width,
                      height: (UserRepository.checkPermission(
                              target: "assignments", action: "write"))
                          ? Get.height * 0.64
                          : Get.height * 0.666,
                      child: RefreshIndicator(
                        onRefresh: () async => controller.refresh(),
                        child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05,
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      for (int i = 0;
                                          i <
                                              (controller.assignments?.value
                                                      .length ??
                                                  0);
                                          i += 2) ...[
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
                                          ),
                                      ],
                                      for (int i = 1;
                                          i <
                                              (controller.assignments?.value
                                                      .length ??
                                                  0);
                                          i += 2) ...[
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
                                  )
                                ],
                              ),
                            )),
                      )),
                ),
              ],
            ),
          ));
  }
}

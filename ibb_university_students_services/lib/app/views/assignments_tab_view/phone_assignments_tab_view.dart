// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/assignments_tab_controller.dart';
import 'package:ibb_university_students_services/app/views/assignments_tab_view/assignments_view_components/assignments_card.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_v2.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';
import '../../utils/permission_checker.dart';

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
                        height: Get.height * 0.16,
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
                              height: Get.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SecText(
                                  "Subject".tr,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.start,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.inverseCardColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  width: Get.width*0.65,
                                  child: Center(
                                    child: Obx(
                                      () => DropdownButton<String>(
                                        items: controller.subjectsItems,
                                        selectedItemBuilder: (_) {
                                          return controller
                                              .selectedSubjectsItems;
                                        },
                                        onChanged: controller.changeSubject,
                                        value: controller.selectedSubject.value,
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
                                textHeader: AppTextHeaders.h2),
                          ),
                          if ((PermissionUtils.checkPermission(
                              target: "Assignments", action: "add")))
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
                      width: width,
                      height: (PermissionUtils.checkPermission(
                              target: "Assignments", action: "add"))
                          ? Get.height * 0.66
                          : Get.height * 0.69,
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
                                  if (controller.assignments?.value.isEmpty ?? true) ...[
                                    SizedBox(
                                      height: Get.height * 0.2,
                                    ),
                                    Center(
                                        child: CustomText(
                                      controller.fieldMessage.value,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h2),
                                    )),
                                    IconButton(
                                        onPressed: () async =>
                                            controller.refresh(),
                                        icon: const Icon(Icons.refresh))
                                  ],
                                  for (int i = 0; i < (controller.assignments?.value.length ?? 0); i++) ...[
                                    AssignmentsCard(content: Rx(controller.assignments?.value.values.toList()[i])),
                                    if (i < ((controller.assignments?.value.length ?? 0) - 1))
                                      SizedBox(
                                        height: Get.height * 0.03,
                                      )
                                  ]
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

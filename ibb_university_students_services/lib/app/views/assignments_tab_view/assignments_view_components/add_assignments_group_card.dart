import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/assignments_tab_controller.dart';
import '../../../components/buttons.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import '../../../utils/screen_utils.dart';

// ignore: must_be_immutable
class PopUpIAddAssignmentsGroupCard extends GetView<AssignmentsTabController> {
  PopUpIAddAssignmentsGroupCard({super.key});

  Rx<int?> selectedDepartment = Rx(null);
  Rx<int?> selectedLevel = Rx(null);

  @override
  Widget build(BuildContext context) {
    selectedDepartment = RxInt(controller.sections.values.first.id);
    selectedLevel = (controller.levels.first.value != null)
        ? RxInt(controller.levels.first.value!)
        : Rx(null);
    return (ScreenUtils.isPhoneScreen())
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Hero(
                tag: "PopUpInsertCard2",
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
                      height: Get.height * 0.4,
                      width: Get.width,
                      child: SafeArea(
                          minimum: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomText("Add Group",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h2Bold)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CustomText("Program".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.inverseCardColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    width: Get.width / 3,
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
                                                      : (Get.width / 5.5) * 0.6,
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
                                          onChanged: (val) {
                                            if (val == null) return;
                                            selectedDepartment.value = val;
                                          },
                                          value: selectedDepartment.value,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CustomText("Level".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.inverseCardColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    width: Get.width / 4,
                                    child: Center(
                                      child: Obx(
                                        () => DropdownButton(
                                          items: controller.levels,
                                          onChanged: (val) {
                                            if (val == null) return;
                                            selectedLevel.value = val;
                                          },
                                          value: selectedLevel.value,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton(
                                    onPress: () {
                                      controller.addGroup(
                                          selectedDepartment.value!,
                                          selectedLevel.value!);
                                      Navigator.of(Get.overlayContext!).pop();
                                    },
                                    text: controller.mode,
                                  ),
                                  CustomButton(
                                    onPress: () => Get.back(result: null),
                                    text: "Close",
                                  ),
                                ],
                              )
                            ],
                          ))),
                ),
              ),
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Hero(
                tag: "PopUpInsertCard2",
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
                      height: Get.height * 0.4,
                      width: Get.width * 0.3,
                      child: SafeArea(
                          minimum: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomText("Add Group",
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h2Bold)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CustomText("Program".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.inverseCardColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    width: Get.width / 6,
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
                                                      : (Get.width / 5.5) * 0.6,
                                                  child: CustomText(
                                                    e.value.name ?? "unknown",
                                                    style:
                                                        AppTextStyles.mainStyle(
                                                      textHeader:
                                                          AppTextHeaders.h3Bold,
                                                    ),
                                                  ),
                                                ));
                                          }).toList()),
                                          onChanged: (val) {
                                            if (val == null) return;
                                            selectedDepartment.value = val;
                                          },
                                          value: selectedDepartment.value,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CustomText("Level".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.inverseCardColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    width: Get.width / 6,
                                    child: Center(
                                      child: Obx(
                                        () => DropdownButton(
                                          items: controller.levels,
                                          onChanged: (val) {
                                            if (val == null) return;
                                            selectedLevel.value = val;
                                          },
                                          value: (selectedLevel.value == -1)
                                              ? null
                                              : selectedLevel.value,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton(
                                    onPress: () {
                                      controller.addGroup(
                                          selectedDepartment.value!,
                                          selectedLevel.value!);
                                      Navigator.of(Get.overlayContext!).pop();
                                    },
                                    text: controller.mode,
                                  ),
                                  CustomButton(
                                    onPress: () => Get.back(result: null),
                                    text: "Close",
                                  ),
                                ],
                              )
                            ],
                          ))),
                ),
              ),
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_notification_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/validators.dart';

class AddNotificationTableCard
    extends GetView<DashboardNotificationTableController> {
  const AddNotificationTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8),
        width: Get.width * 0.4,
        height: Get.height * 0.95,
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
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Title".tr,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h2Bold),
                              ),
                              SizedBox(
                                width: Get.width * 0.25,
                                child: CustomTextFormField(
                                  controller: controller.titleController,
                                  validator: Validators.validateID,
                                  keyboardType: TextInputType.multiline,
                                  labelText: "Title".tr,
                                  focusNode: controller.titleFocus,
                                  onFieldSubmitted: (e) {
                                    controller.messageFocus.requestFocus();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.width * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Message".tr,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              ),
                              SizedBox(
                                width: Get.width * 0.25,
                                child: CustomTextFormField(
                                  controller: controller.messageController,
                                  validator: Validators.validateID,
                                  keyboardType: TextInputType.multiline,
                                  labelText: "Message".tr,
                                  minLines: 5,
                                  focusNode: controller.messageFocus,
                                  onFieldSubmitted: (e) {
                                    controller.reciverFocus.requestFocus();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.width * 0.01,
                          ),
                          Row(
                            children: [
                              CustomText(
                                "Targeting Options".tr,
                                textAlign: TextAlign.start,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  color: AppColors.highlightTextColor,
                                  height: 2,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                              ),
                              Expanded(
                                child: CustomText(
                                  "Notification Type".tr,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h3Bold),
                                ),
                              ),
                              Container(
                                width: Get.width * 0.18,
                                decoration: BoxDecoration(
                                  color: AppColors.inverseCardColor,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: DropdownButton<String>(
                                  underline: const SizedBox(),
                                  iconEnabledColor: AppColors.mainCardColor,
                                  dropdownColor: AppColors.inverseCardColor,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  value: controller.mode.value,
                                  onChanged: (value) =>
                                      controller.mode.value = value!,
                                  items: ['Single', 'Group']
                                      .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: SizedBox(
                                            width: Get.width * 0.13,
                                            child: CustomText(
                                              e,
                                              style: AppTextStyles.mainStyle(
                                                  textHeader:
                                                      AppTextHeaders.h3Bold),
                                            ),
                                          )))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          if (controller.mode.value == 'Single') ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText("Receiver ID".tr,
                                        style: AppTextStyles.secStyle(
                                            textHeader: AppTextHeaders.h3Bold)),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: Get.width * 0.2,
                                  child: CustomTextFormField(
                                    controller: controller.reciverController,
                                    validator: Validators.validateID,
                                    keyboardType: TextInputType.multiline,
                                    labelText: "Receiver ID".tr,
                                    focusNode: controller.reciverFocus,
                                    onFieldSubmitted: (e) {},
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                ),
                                Expanded(
                                  child: CustomText(
                                    "Target User".tr,
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                ),
                                Container(
                                  width: Get.width * 0.18,
                                  decoration: BoxDecoration(
                                    color: AppColors.inverseCardColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: DropdownButton<String>(
                                    underline: const SizedBox(),
                                    iconEnabledColor: AppColors.mainCardColor,
                                    dropdownColor: AppColors.inverseCardColor,
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    value: controller.selectedTarget.value,
                                    onChanged: (value) => controller
                                        .selectedTarget.value = value!,
                                    items: controller.targets.keys
                                        .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: SizedBox(
                                              width: Get.width * 0.13,
                                              child: CustomText(
                                                e,
                                                style: AppTextStyles.mainStyle(
                                                    textHeader:
                                                        AppTextHeaders.h3Bold),
                                              ),
                                            )))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            CustomText(
                              "${"Programs".tr}:",
                              textAlign: TextAlign.start,
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              spacing: 8,
                              children:
                                  controller.sections.values.map((section) {
                                final selected = controller.selectedSections
                                    .contains("section_${section.id}");
                                return FilterChip(
                                  label: CustomText(section.name ?? "??",
                                      style: (selected)
                                          ? AppTextStyles.mainStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Normal)
                                          : AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Normal)),
                                  color:
                                      WidgetStateProperty.resolveWith((state) {
                                    if (state.contains(WidgetState.selected)) {
                                      return AppColors.inverseCardColor;
                                    } else {
                                      return AppColors.tabBackColor;
                                    }
                                  }),
                                  checkmarkColor: AppColors.tabBackColor,
                                  selected: selected,
                                  onSelected: (val) {
                                    selected
                                        ? controller.selectedSections
                                            .remove("section_${section.id}")
                                        : controller.selectedSections
                                            .add("section_${section.id}");
                                  },
                                );
                              }).toList(),
                            ),

                            // Levels (only for student/both)
                            if (controller.selectedTarget.value ==
                                ('Students')) ...[
                              SizedBox(height: 10),
                              CustomText(
                                "${"Levels".tr}:",
                                textAlign: TextAlign.start,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                spacing: 10,
                                children: controller.levels.values.map((level) {
                                  final selected = controller.selectedLevels
                                      .contains("level_${level.id}");
                                  return FilterChip(
                                    label: CustomText(level.name ?? '??',
                                        style: (selected)
                                            ? AppTextStyles.mainStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Normal)
                                            : AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Normal)),
                                    color: WidgetStateProperty.resolveWith(
                                        (state) {
                                      if (state
                                          .contains(WidgetState.selected)) {
                                        return AppColors.inverseCardColor;
                                      } else {
                                        return AppColors.tabBackColor;
                                      }
                                    }),
                                    checkmarkColor: AppColors.tabBackColor,
                                    selected: selected,
                                    onSelected: (val) {
                                      selected
                                          ? controller.selectedLevels
                                              .remove("level_${level.id}")
                                          : controller.selectedLevels
                                              .add("level_${level.id}");
                                    },
                                  );
                                }).toList(),
                              ),
                            ],

                            // Roles
                            SizedBox(height: 8),
                            CustomText(
                              "${"Roles".tr}:",
                              textAlign: TextAlign.start,
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              spacing: 10,
                              children: controller.roles.values.map((role) {
                                final selected = controller.selectedRoles
                                    .contains("role_${role.id}");
                                return FilterChip(
                                  label: CustomText(role.name ?? '??',
                                      style: (selected)
                                          ? AppTextStyles.mainStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Normal)
                                          : AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Normal)),
                                  color:
                                      WidgetStateProperty.resolveWith((state) {
                                    if (state.contains(WidgetState.selected)) {
                                      return AppColors.inverseCardColor;
                                    } else {
                                      return AppColors.tabBackColor;
                                    }
                                  }),
                                  selected: selected,
                                  checkmarkColor: AppColors.tabBackColor,
                                  onSelected: (val) {
                                    selected
                                        ? controller.selectedRoles
                                            .remove("role_${role.id}")
                                        : controller.selectedRoles
                                            .add("role_${role.id}");
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: Get.width * 0.1,
                                child: CustomButton(
                                    text: "Add",
                                    onPress: controller.pushNotification),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                                child: CustomButton(
                                    text: "close", onPress: () => Get.back()),
                              )
                            ],
                          )
                        ],
                      )),
                ),
              )),
        ),
      ),
    );
  }
}

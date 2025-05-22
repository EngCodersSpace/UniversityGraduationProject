import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/notification_tab_controller.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/validators.dart';

import '../../../models/role_model/role.dart';
import '../../../styles/app_colors.dart';

class AddNotificationsTargetCard extends GetView<NotificationTabController> {
  const AddNotificationsTargetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                          Center(
                            child: CustomText(
                              "Push Notification".tr,
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h2Bold),
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.title,
                                size: 40,
                                color: AppColors.inverseIconColor,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: controller.titleController,
                                  validator: Validators.validateID,
                                  keyboardType: TextInputType.text,
                                  labelText: "Title".tr,
                                  focusNode: controller.titleFocus,
                                  onFieldSubmitted: (e) {
                                    controller.messageFocus.requestFocus();
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.message_outlined,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  // CustomText("Receiver ID".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: controller.messageController,
                                  validator: Validators.validateID,
                                  keyboardType: TextInputType.multiline,
                                  labelText: "Message".tr,
                                  minLines: 5,
                                  focusNode: controller.messageFocus,
                                  onFieldSubmitted: (e) {
                                    controller.receiverIdFocus.requestFocus();
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 32,
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
                                width: 8,
                              ),
                              Expanded(
                                child: Container(
                                  color: AppColors.highlightTextColor,
                                  height: 1,
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
                                            width: Get.width * 0.3,
                                            child: CustomText(
                                              e,
                                              style: AppTextStyles.mainStyle(
                                                  textHeader:
                                                      AppTextHeaders.h2Bold),
                                            ),
                                          )))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          if (controller.mode.value == 'Single') ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 40,
                                      color: AppColors.inverseIconColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CustomText("Receiver ID".tr,
                                        style: AppTextStyles.secStyle(
                                            textHeader: AppTextHeaders.h3Bold)),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: CustomTextFormField(
                                    controller: controller.receiverIdController,
                                    validator: Validators.validateID,
                                    keyboardType: TextInputType.text,
                                    labelText: "Receiver ID".tr,
                                    focusNode: controller.receiverIdFocus,
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
                                              width: Get.width * 0.3,
                                              child: CustomText(
                                                e,
                                                style: AppTextStyles.mainStyle(
                                                    textHeader:
                                                        AppTextHeaders.h2Bold),
                                              ),
                                            )))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),

                            CustomText(
                              "${"Programs".tr}:",
                              textAlign: TextAlign.start,
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Bold),
                            ),
                            Wrap(
                              spacing: 6,
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
                              SizedBox(height: 8),
                              CustomText(
                                "${"Levels".tr}:",
                                textAlign: TextAlign.start,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              ),
                              Wrap(
                                spacing: 6,
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
                            Obx(
                              () => Row(
                                children: [
                                  Checkbox(
                                      value: controller.includeRole.value,
                                      onChanged: controller.changeIncludeRole),
                                  CustomText(
                                    "${"Roles".tr}:",
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  ),
                                ],
                              ),
                            ),
                            if(controller.includeRole.value)
                              Obx(
                              () => Wrap(
                                spacing: 6,
                                children: [
                                  for (Role role
                                      in (controller.roles.values ?? [])) ...[
                                    if ((controller.selectedTarget.value ==
                                                "Students" &&
                                            role.roleType == "student") ||
                                        (controller.selectedTarget.value ==
                                                "Doctors" &&
                                            role.roleType == "doctor") ||
                                        (controller.selectedTarget.value ==
                                            "Student And Doctors")) ...[
                                      SizedBox(
                                        // width: Get.width/4,
                                        child: FilterChip(
                                          label: CustomText(role.name ?? '??',
                                              style: (controller.selectedRoles
                                                      .contains(
                                                          "role_${role.id}"))
                                                  ? AppTextStyles.mainStyle(
                                                      textHeader: AppTextHeaders
                                                          .h3Normal)
                                                  : AppTextStyles.secStyle(
                                                      textHeader: AppTextHeaders
                                                          .h3Normal)),
                                          color:
                                              WidgetStateProperty.resolveWith(
                                                  (state) {
                                            if (state.contains(
                                                WidgetState.selected)) {
                                              return AppColors.inverseCardColor;
                                            } else {
                                              return AppColors.tabBackColor;
                                            }
                                          }),
                                          selected: controller.selectedRoles
                                              .contains("role_${role.id}"),
                                          checkmarkColor:
                                              AppColors.tabBackColor,
                                          onSelected: (val) {
                                            controller.selectedRoles
                                                    .contains("role_${role.id}")
                                                ? controller.selectedRoles
                                                    .remove("role_${role.id}")
                                                : controller.selectedRoles
                                                    .add("role_${role.id}");
                                          },
                                        ),
                                      )
                                    ]
                                  ]
                                ],
                              ),
                            ),
                          ],
                          SizedBox(height: 16),
                          CustomButton(
                              text: "Add",
                              onPress: controller.pushNotification),
                          CustomButton(text: "close", onPress: () => Get.back())
                        ],
                      )),
                ),
              )),
        ),
      ),
    );
  }
}

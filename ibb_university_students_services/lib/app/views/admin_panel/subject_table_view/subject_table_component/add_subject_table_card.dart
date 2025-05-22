import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_subjects_table_controller.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/student_table_view/student_table_component/popup_add_student_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/subject_table_view/subject_table_component/popup_add_subject_component.dart';

class PopUpAddSubjectCard extends GetView<DashboardSubjectsTableController> {
  const PopUpAddSubjectCard({super.key});

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
                width: Get.width * 0.4,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PopupAddSubjectComponent(
                            name: "Subject ID",
                            controlName: controller.subjectId,
                            focusName: controller.idFocus,
                            inputType: TextInputType.number,
                          ),
                          PopupAddSubjectComponent(
                            name: "Name",
                            controlName: controller.subjectName,
                            focusName: controller.nameFocus,
                            inputType: TextInputType.name,
                          ),
                          PopupAddSubjectComponent(
                            name: "Number Of Unit",
                            controlName: controller.subjectUnit,
                            focusName: controller.unitFocus,
                            inputType: TextInputType.number,
                          ),
                          //there is a missed fiald is the doctor filed
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Icon(
                                  //   Icons.menu_book,
                                  //   size: 40,
                                  //   color: AppColors.inverseIconColor,
                                  // ),
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  CustomText("Section".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.23,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Obx(() => DropdownButton<int?>(
                                        value: controller.sectionId.value,
                                        icon: Icon(Icons.arrow_drop_down_sharp,
                                            color: AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor: AppColors.mainCardColor,
                                        onChanged: (val) {
                                          if (val == null) return;
                                          controller.sectionId.value = val;
                                        },
                                        isExpanded: true,
                                        menuWidth: Get.width * 0.3,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Section sectionI in (controller
                                              .addSection.values)) {
                                            items.add(DropdownMenuItem<int?>(
                                              value: sectionI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.28,
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
                                              .addSection.values)) ...[
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
                                  // Icon(
                                  //   Icons.menu_book,
                                  //   size: 40,
                                  //   color: AppColors.inverseIconColor,
                                  // ),
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  CustomText("Level".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.23,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Obx(() => DropdownButton<int?>(
                                        value: controller.levelId.value,
                                        icon: Icon(Icons.arrow_drop_down_sharp,
                                            color: AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor: AppColors.mainCardColor,
                                        onChanged: (val) {
                                          if (val == null) return;
                                          controller.levelId.value = val;
                                        },
                                        isExpanded: true,
                                        menuWidth: Get.width * 0.3,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Level levelI
                                              in (controller.addLevel ?? [])) {
                                            items.add(DropdownMenuItem<int?>(
                                              value: levelI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.28,
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
                                              in (controller.addLevel ??
                                                  [])) ...[
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
                          PopupAddStudentComponent(
                            name: "Description",
                            controlName: controller.subjectDescription,
                            focusName: controller.descriptionFocus,
                            inputType: TextInputType.multiline,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                  onPress: controller.addSubject, text: "Add"),
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

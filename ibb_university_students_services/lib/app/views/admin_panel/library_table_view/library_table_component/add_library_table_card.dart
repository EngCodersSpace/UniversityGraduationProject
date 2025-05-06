import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_library_table_controller.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/library_table_view/library_table_component/popup_add_book_component.dart';

class PopUpAddLibraryCard extends GetView<DashboardLibraryTableController> {
  const PopUpAddLibraryCard({super.key});

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
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
                                          for (Section sectionI
                                              in (controller.section.values)) {
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
                                              .section.values)) ...[
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
                                              in (controller.level ?? [])) {
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
                                              in (controller.level ?? [])) ...[
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
                          PopupAddBookComponent(
                              name: "Title",
                              controlName: controller.title,
                              focusName: controller.titleFocus,
                              inputType: TextInputType.text),
                          PopupAddBookComponent(
                              name: "Author",
                              controlName: controller.author,
                              focusName: controller.authorFocus,
                              inputType: TextInputType.text),
                          PopupAddBookComponent(
                              name: "Pages",
                              controlName: controller.pages,
                              focusName: controller.pageFocus,
                              inputType: TextInputType.number),
                          PopupAddBookComponent(
                              name: "Edition",
                              controlName: controller.edition,
                              focusName: controller.editionFocus,
                              inputType: TextInputType.text),
                          PopupAddBookComponent(
                              name: "Category",
                              controlName: controller.category,
                              focusName: controller.categoryFocus,
                              inputType: TextInputType.text),
                          PopupAddBookComponent(
                              name: "Size",
                              controlName: controller.size,
                              focusName: controller.sizeFocus,
                              inputType: TextInputType.number),
                          PopupAddBookComponent(
                              name: "Path",
                              controlName: controller.path,
                              focusName: controller.pathFocus,
                              inputType: TextInputType.url),
                          PopupAddBookComponent(
                              name: "Image",
                              controlName: controller.image,
                              focusName: controller.imageFocus,
                              inputType: TextInputType.url),
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
                                  CustomText("Subject".tr,
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
                                  child: Obx(() => DropdownButton<String?>(
                                        value: controller.subjectId.value,
                                        icon: Icon(Icons.arrow_drop_down_sharp,
                                            color: AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor: AppColors.mainCardColor,
                                        onChanged: (val) {
                                          if (val == null) return;
                                          controller.subjectId.value = val;
                                        },
                                        isExpanded: true,
                                        menuWidth: Get.width * 0.3,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Subject subjectI in (controller
                                                  .subjects?.values
                                                  .toList()) ??
                                              []) {
                                            items.add(DropdownMenuItem<String?>(
                                              value: subjectI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.28,
                                                  child: CustomText(
                                                    subjectI.subjectName ?? "",
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
                                          for (Subject subjectI in (controller
                                                  .subjects?.values
                                                  .toList()) ??
                                              []) ...[
                                            DropdownMenuItem<String?>(
                                                value: subjectI.id,
                                                child: Column(
                                                  children: [
                                                    CustomText(
                                                      subjectI.subjectName ??
                                                          "",
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
                          PopupAddBookComponent(
                              name: "Book name",
                              controlName: controller.name,
                              focusName: controller.nameFocus,
                              inputType: TextInputType.name),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                  onPress: controller.addBook, text: "Add"),
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

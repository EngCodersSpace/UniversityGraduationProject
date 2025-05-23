import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/typeahead.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_library_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/library_table_view/library_table_component/add_group_card.dart';

class AddLibraryTableCard extends GetView<DashboardLibraryTableController> {
  const AddLibraryTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardLibraryTableController>(
        id: "BooksPiker",
        builder: (ctx) => Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: "PopUpInsertCard",
                  child: Material(
                    color: AppColors.tabBackColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: AppColors.inverseCardColor,
                          width: 3,
                        )),
                    child: SizedBox(
                        height: Get.height * 0.95,
                        width: Get.width * 0.4,
                        child: SafeArea(
                            minimum: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                CustomText(
                                  (controller.mode == "add")
                                      ? ("Add Books").tr
                                      : ("Add Books Request to ").tr,
                                  style: AppTextStyles.secStyle(
                                      textHeader: AppTextHeaders.h1Bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width: (Get.width * 0.08),
                                        child: CustomText("Category".tr,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold))),
                                    Container(
                                      width: Get.width * 0.2,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                          color: AppColors.inverseCardColor,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      child: Center(
                                        child: Obx(() => DropdownButton(
                                              value: controller
                                                  .selectedCategory.value,
                                              iconEnabledColor:
                                                  AppColors.mainCardColor,
                                              underline: const SizedBox(),
                                              dropdownColor:
                                                  AppColors.inverseCardColor,
                                              onChanged: (val) {
                                                if (val == null) return;
                                              },
                                              isExpanded: true,
                                              menuWidth: Get.width * 0.2,
                                              items: [
                                                for (var (i, s) in controller
                                                    .categories.indexed) ...[
                                                  DropdownMenuItem(
                                                      value: i,
                                                      child: SizedBox(
                                                          width: (Get.width *
                                                                  0.5) *
                                                              0.75,
                                                          child: CustomText(
                                                            s,
                                                            style: AppTextStyles
                                                                .mainStyle(
                                                                    textHeader:
                                                                        AppTextHeaders
                                                                            .h3Bold),
                                                          ))),
                                                ]
                                              ],
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width: (Get.width * 0.08),
                                        child: CustomText("Subject".tr,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold))),
                                    TypeAhead(
                                      width: (Get.width * 0.2),
                                      onSelected: (i, v) {
                                        controller.selectedAddSubjectId?.value =
                                            i;
                                      },
                                      label: "Select Subject",
                                      items: controller.subjects.map((i, e) =>
                                          MapEntry(i, e.subjectName ?? "")),
                                      color: AppColors.inverseCardColor,
                                      menuColor: AppColors.inverseCardColor,
                                      textStyle: AppTextStyles.mainStyle(
                                          textHeader: AppTextHeaders.h3Bold),
                                      menuTextStyle: AppTextStyles.mainStyle(
                                          textHeader: AppTextHeaders.h3Bold),
                                    ),
                                  ],
                                ),
                                Obx(() => Column(
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: CustomText("Groups",
                                              style: AppTextStyles.secStyle(
                                                  textHeader:
                                                      AppTextHeaders.h2Bold)),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                          height: Get.height * 0.2,
                                          width: Get.width * 0.39,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors
                                                      .inverseCardColor),
                                              color: AppColors.tabBackColor,
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        ((Get.width * 0.3) / 7),
                                                    child: CustomText("#",
                                                        style: AppTextStyles
                                                            .secStyle(
                                                                textHeader:
                                                                    AppTextHeaders
                                                                        .h2Bold)),
                                                  ),
                                                  SizedBox(
                                                    width: ((Get.width * 0.4) /
                                                            7) *
                                                        3,
                                                    child: CustomText("Program",
                                                        style: AppTextStyles
                                                            .secStyle(
                                                                textHeader:
                                                                    AppTextHeaders
                                                                        .h2Bold)),
                                                  ),
                                                  SizedBox(
                                                    width: ((Get.width * 0.4) /
                                                            7) *
                                                        2,
                                                    child: CustomText("Level",
                                                        style: AppTextStyles
                                                            .secStyle(
                                                                textHeader:
                                                                    AppTextHeaders
                                                                        .h2Bold)),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        ((Get.width * 0.3) / 7),
                                                    height: 25,
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        Get.dialog(
                                                            AddGroupCard());
                                                      },
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: AppColors
                                                            .inverseCardColor,
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color:
                                                    AppColors.inverseCardColor,
                                              ),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      for (var (index, item)
                                                          in controller.groups
                                                              .indexed) ...[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  ((Get.width *
                                                                          0.3) /
                                                                      7),
                                                              child: CustomText(
                                                                  "${index + 1}",
                                                                  style: AppTextStyles.secStyle(
                                                                      textHeader:
                                                                          AppTextHeaders
                                                                              .h2Bold)),
                                                            ),
                                                            SizedBox(
                                                              width: ((Get.width *
                                                                          0.3) /
                                                                      6) *
                                                                  3.5,
                                                              child: CustomText(
                                                                  "${controller.section[item["section_id"]!]?.name}",
                                                                  softWrap:
                                                                      false,
                                                                  style: AppTextStyles.secStyle(
                                                                      textHeader:
                                                                          AppTextHeaders
                                                                              .h2Bold)),
                                                            ),
                                                            SizedBox(
                                                              width: ((Get.width *
                                                                          0.3) /
                                                                      8) *
                                                                  3,
                                                              child: CustomText(
                                                                  "${item["level_id"]}",
                                                                  style: AppTextStyles.secStyle(
                                                                      textHeader:
                                                                          AppTextHeaders
                                                                              .h2Bold)),
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    ((Get.width *
                                                                            0.3) /
                                                                        8),
                                                                child: IconButton(
                                                                    onPressed: () =>
                                                                        controller.delGroup(
                                                                            index),
                                                                    icon: Icon(Icons
                                                                        .delete)))
                                                          ],
                                                        ),
                                                      ]
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    )),
                                const SizedBox(
                                  height: 8,
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: CustomText("Selected Books",
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h2Bold)),
                                ),
                                Expanded(
                                  child: Container(
                                    width: Get.width * 0.9,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.inverseCardColor),
                                      borderRadius: BorderRadius.circular(24),
                                      // color: AppColors.highlightTextColor
                                      //     .withOpacity(0.1),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                for (int i = 0;
                                                    i <
                                                        (controller
                                                            .selectedFiles
                                                            .length);
                                                    i++) ...[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16,
                                                            right: 16,
                                                            bottom: 8),
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor: AppColors
                                                              .inverseIconColor,
                                                          child: CustomText(
                                                            "${i + 1}",
                                                            style: AppTextStyles
                                                                .mainStyle(
                                                                    textHeader:
                                                                        AppTextHeaders
                                                                            .h2Bold),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CustomText(
                                                                  controller
                                                                      .selectedFiles[
                                                                          i]
                                                                      .name,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: AppTextStyles.secStyle(
                                                                      textHeader:
                                                                          AppTextHeaders
                                                                              .h3Bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 24,
                                                          width: 24,
                                                          child:
                                                              PopupMenuButton<
                                                                  String>(
                                                            onSelected: (val) =>
                                                                controller
                                                                    .filesMore(
                                                                        val, i),
                                                            color: AppColors
                                                                .inverseCardColor,
                                                            itemBuilder:
                                                                (ctx) => [
                                                              PopupMenuItem(
                                                                  value:
                                                                      "Delete",
                                                                  child:
                                                                      CustomText(
                                                                    "Delete".tr,
                                                                    style: AppTextStyles.mainStyle(
                                                                        textHeader:
                                                                            AppTextHeaders.h3Bold),
                                                                  )),
                                                              PopupMenuItem(
                                                                  value:
                                                                      "reName",
                                                                  child:
                                                                      CustomText(
                                                                    "Rename".tr,
                                                                    style: AppTextStyles.mainStyle(
                                                                        textHeader:
                                                                            AppTextHeaders.h3Bold),
                                                                  )),
                                                            ],
                                                            child: Icon(
                                                              Icons.more_horiz,
                                                              color: AppColors
                                                                  .inverseCardColor,
                                                              size: 25,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  if (i !=
                                                      ((controller.selectedFiles
                                                              .length) -
                                                          1)) ...[
                                                    Divider(
                                                      color: AppColors
                                                          .secTextColor,
                                                      thickness: 0.3,
                                                      indent: 10,
                                                      endIndent: 10,
                                                    ),
                                                  ] else ...[
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                  ]
                                                ]
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomButton(
                                  onPress: () async => controller.pickFiles(),
                                  text: "Select Books".tr,
                                  size: Size(Get.width * 0.18, 40),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomButton(
                                  onPress: controller.addBook,
                                  text: (controller.mode == "add")
                                      ? ("Upload Books").tr
                                      : ("Upload And Add Request").tr,
                                  size: Size(Get.width * 0.16, 40),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomButton(
                                  onPress: () =>
                                      Navigator.of(Get.overlayContext!).pop(),
                                  text: "Close".tr,
                                  size: Size(Get.width * 0.14, 40),
                                )
                              ],
                            ))),
                  ),
                ),
              ),
            ));
  }
}

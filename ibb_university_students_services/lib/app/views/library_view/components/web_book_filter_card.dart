import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/views/library_view/components/web_sort_icons.dart';
import '../../../components/buttons.dart';
import '../../../components/custom_text_v2.dart';
import '../../../components/typeahead.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import '../../../utils/screen_utils.dart';

// ignore: must_be_immutable
class WebBookFilterCard extends GetView<LibraryController> {
  // ignore: prefer_const_constructors_in_immutables
  WebBookFilterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Hero(
              tag: "PupCard",
              child: Material(
                color: AppColors.tabBackColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.inverseCardColor, width: 4),
                      borderRadius: BorderRadius.circular(32)),
                  width: Get.width * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    "Filters",
                                    style: AppTextStyles.highlightStyle(
                                        textHeader: AppTextHeaders.h2Bold),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width: Get.width * 0.08,
                                        child: CustomText(
                                          "${"Program".tr}:",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Bold),
                                        )),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.inverseCardColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      width: Get.width * 0.2,
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
                                                        : (Get.width / 5.5) *
                                                            0.6,
                                                    child: CustomText(
                                                      e.value.name ?? "unknown",
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
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width: Get.width * 0.08,
                                        child: CustomText(
                                          "${"Level".tr}:",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h3Bold),
                                        )),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.inverseCardColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      width: Get.width * 0.2,
                                      child: Center(
                                        child: Obx(
                                          () => DropdownButton(
                                            items: (controller.levels.entries
                                                .map((e) {
                                              return DropdownMenuItem<int>(
                                                  value: e.key,
                                                  child: SizedBox(
                                                    width: (ScreenUtils
                                                            .isPhoneScreen())
                                                        ? (Get.width / 3) - 30
                                                        : (Get.width / 5.5) *
                                                            0.6,
                                                    child: CustomText(
                                                      (e.key == -1)
                                                          ? "All"
                                                          : e.key.toString(),
                                                      style: AppTextStyles
                                                          .mainStyle(
                                                        textHeader:
                                                            AppTextHeaders
                                                                .h5Bold,
                                                      ),
                                                    ),
                                                  ));
                                            }).toList()),
                                            onChanged: controller.changeLevel,
                                            value:
                                                controller.selectedLevel.value,
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
                                const SizedBox(
                                  height: 4,
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
                                    TypeAhead<String>(
                                      width: (Get.width * 0.2),
                                      onSelected: (i, v) {
                                        controller.selectedSubjectId?.value = i;
                                      },
                                      value:
                                          controller.selectedSubjectId?.value,
                                      label: "Select Subject",
                                      items: controller.subjects.map((i, e) =>
                                          MapEntry(i, e.subjectName ?? "")),
                                      color: AppColors.inverseCardColor,
                                      menuColor: AppColors.inverseCardColor,
                                      textStyle: AppTextStyles.mainStyle(
                                          textHeader: AppTextHeaders.h3Bold),
                                      menuTextStyle: AppTextStyles.mainStyle(
                                          textHeader: AppTextHeaders.h3Bold),
                                      includeAllOption: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 4,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    "Sort",
                                    style: AppTextStyles.highlightStyle(
                                        textHeader: AppTextHeaders.h2Bold),
                                  ),
                                ),
                                Obx(
                                  () => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      WebSortIcons(
                                        icon: Icons.sort_by_alpha_sharp,
                                        title: 'Title',
                                        selected: controller
                                                .selectedSortOption.value ==
                                            "title",
                                        onTap: () => controller
                                            .changeSelectedSortOption("title"),
                                      ),
                                      WebSortIcons(
                                          icon: Icons.calendar_month,
                                          title: 'Date',
                                          selected: controller
                                                  .selectedSortOption.value ==
                                              "date",
                                          onTap: () => controller
                                              .changeSelectedSortOption(
                                                  "date")),
                                      WebSortIcons(
                                          icon: Icons.assignment_sharp,
                                          title: 'Pages',
                                          selected: controller
                                                  .selectedSortOption.value ==
                                              "page",
                                          onTap: () => controller
                                              .changeSelectedSortOption(
                                                  "page")),
                                      WebSortIcons(
                                        icon: Icons.memory,
                                        title: 'Size',
                                        selected: controller
                                                .selectedSortOption.value ==
                                            "size",
                                        onTap: () => controller
                                            .changeSelectedSortOption("size"),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Obx(
                                  () => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (controller.sortDirection.value ==
                                          0) ...[
                                        InkWell(
                                          onTap: () => controller
                                              .changeSelectedSortDirection(0),
                                          child: Container(
                                            height: 30,
                                            width: 100,
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
                                              controller.sortOptions[controller
                                                          .selectedSortOption
                                                          .value]?[
                                                      controller.sortDirection
                                                          .value] ??
                                                  "",
                                              style: AppTextStyles
                                                  .customColorStyle(
                                                textHeader:
                                                    AppTextHeaders.h2Bold,
                                                color: (controller.sortDirection
                                                            .value ==
                                                        0)
                                                    ? Colors.blueAccent
                                                    : AppColors
                                                        .inverseCardColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => controller
                                              .changeSelectedSortDirection(1),
                                          child: Container(
                                            height: 30,
                                            width: 100,
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
                                              controller.sortOptions[controller
                                                          .selectedSortOption
                                                          .value]?[
                                                      1 -
                                                          controller
                                                              .sortDirection
                                                              .value] ??
                                                  "",
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
                                            width: 100,
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
                                              controller.sortOptions[controller
                                                          .selectedSortOption
                                                          .value]?[
                                                      1 -
                                                          controller
                                                              .sortDirection
                                                              .value] ??
                                                  "",
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
                                            width: 100,
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
                                              controller.sortOptions[controller
                                                          .selectedSortOption
                                                          .value]?[
                                                      controller.sortDirection
                                                          .value] ??
                                                  "",
                                              style: AppTextStyles
                                                  .customColorStyle(
                                                      textHeader:
                                                          AppTextHeaders.h2Bold,
                                                      color:
                                                          (Colors.blueAccent)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                              ],
                            ),
                            Obx(
                              () => Column(
                                children: [
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      "Show",
                                      style: AppTextStyles.highlightStyle(
                                          textHeader: AppTextHeaders.h2Bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  RadioListTile<int>(
                                    value: 0,
                                    groupValue:
                                        controller.selectedShowOption.value,
                                    onChanged:
                                        controller.changeSelectedShowOption,
                                    contentPadding: const EdgeInsets.all(0),
                                    title: CustomText(
                                      "Downloaded only",
                                      textAlign: TextAlign.start,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Normal),
                                    ),
                                  ),
                                  RadioListTile<int>(
                                    value: 1,
                                    groupValue:
                                        controller.selectedShowOption.value,
                                    onChanged:
                                        controller.changeSelectedShowOption,
                                    contentPadding: const EdgeInsets.all(0),
                                    title: CustomText(
                                      "Not downloaded only",
                                      textAlign: TextAlign.start,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Normal),
                                    ),
                                  ),
                                  RadioListTile<int>(
                                    value: 2,
                                    groupValue:
                                        controller.selectedShowOption.value,
                                    onChanged:
                                        controller.changeSelectedShowOption,
                                    contentPadding: const EdgeInsets.all(0),
                                    title: CustomText(
                                      "Both",
                                      textAlign: TextAlign.start,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Normal),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomButton(
                          text: "Done",
                          onPress: () => Get.back(),
                          size: const Size(180, 40),
                        ),
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }
}

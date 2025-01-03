import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/views/library_view/components/sort_icons.dart';
import '../../../components/buttons.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

// ignore: must_be_immutable
class PopUpBookFilterCard extends GetView<LibraryController> {
  // ignore: prefer_const_constructors_in_immutables
  PopUpBookFilterCard({super.key});

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
                  width: Get.width - 32,
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
                                  height: 16,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    "Filters",
                                    style: AppTextStyles.highlightStyle(
                                        textHeader: AppTextHeaders.h2),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width: Get.width * 0.2,
                                        child: CustomText(
                                          "Section:",
                                          style: AppTextStyles.secStyle(
                                              textHeader: AppTextHeaders.h3),
                                        )),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.inverseCardColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      width: Get.width / 2,
                                      child: Center(
                                        child: Obx(
                                          () => DropdownButton(
                                            items: controller.departments,
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
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width: Get.width * 0.2,
                                        child: CustomText(
                                          "Level:",
                                          style: AppTextStyles.secStyle(
                                              textHeader: AppTextHeaders.h3),
                                        )),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.inverseCardColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      width: Get.width / 2,
                                      child: Center(
                                        child: Obx(
                                          () => DropdownButton(
                                            items: controller.levels,
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
                                  height: 16,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Divider(
                                  color: AppColors.inverseCardColor,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    "Sort",
                                    style: AppTextStyles.highlightStyle(
                                        textHeader: AppTextHeaders.h2),
                                  ),
                                ),
                                Obx(
                                  () => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SortIcon(
                                        icon: Icons.sort_by_alpha_sharp,
                                        title: 'Title',
                                        selected: controller
                                                .selectedSortOption.value ==
                                            "title",
                                        onTap: () => controller
                                            .selectedSortOption("title"),
                                      ),
                                      SortIcon(
                                          icon: Icons.calendar_month,
                                          title: 'Date',
                                          selected: controller
                                                  .selectedSortOption.value ==
                                              "date",
                                          onTap: () => controller
                                              .selectedSortOption("date")),
                                      SortIcon(
                                          icon: Icons.assignment_sharp,
                                          title: 'Pages',
                                          selected: controller
                                                  .selectedSortOption.value ==
                                              "page",
                                          onTap: () => controller
                                              .selectedSortOption("page")),
                                      SortIcon(
                                        icon: Icons.memory,
                                        title: 'Size',
                                        selected: controller
                                                .selectedSortOption.value ==
                                            "size",
                                        onTap: () => controller
                                            .selectedSortOption("size"),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Obx(
                                  () => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (controller.sortDirection.value ==
                                          0) ...[
                                        InkWell(
                                          onTap: ()=>controller.changeSelectedSortDirection(0),
                                          child: Container(
                                            height: 30,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blueAccent,
                                                width: 1.0,
                                                // Right side is intentionally left out
                                              ),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                bottomLeft: Radius.circular(8.0),
                                              ),
                                            ),
                                            child: CustomText(
                                              controller.sortOptions[controller
                                                          .selectedSortOption
                                                          .value]?[
                                                      controller
                                                          .sortDirection.value] ??
                                                  "",
                                              style:
                                                  AppTextStyles.customColorStyle(
                                                textHeader: AppTextHeaders.h2,
                                                color: (controller.sortDirection
                                                            .value ==
                                                        0)
                                                    ? Colors.blueAccent
                                                    : AppColors.inverseCardColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: ()=>controller.changeSelectedSortDirection(1),
                                          child: Container(
                                            height: 30,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              border: controller.borders[0],
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(8.0),
                                                bottomRight: Radius.circular(8.0),
                                              ),
                                            ),
                                            child: CustomText(
                                              controller.sortOptions[controller
                                                  .selectedSortOption
                                                  .value]?[1-
                                              controller
                                                  .sortDirection.value] ??
                                                  "",
                                              style:
                                              AppTextStyles.secStyle(
                                                textHeader: AppTextHeaders.h2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ] else
                                        ...[
                                          InkWell(
                                            onTap: ()=>controller.changeSelectedSortDirection(0),
                                            child: Container(
                                              height: 30,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                border: controller.borders[1],
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  bottomLeft: Radius.circular(8.0),
                                                ),
                                              ),
                                              child: CustomText(
                                                controller.sortOptions[controller
                                                    .selectedSortOption
                                                    .value]?[1-
                                                    controller
                                                        .sortDirection.value] ??
                                                    "",
                                                style:
                                                AppTextStyles.secStyle(
                                                  textHeader: AppTextHeaders.h2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: ()=>controller.changeSelectedSortDirection(1),
                                            child: Container(
                                              height: 30,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.blueAccent,
                                                  width: 1.0,
                                                  // Right side is intentionally left out
                                                ),
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(8.0),
                                                  bottomRight: Radius.circular(8.0),
                                                ),
                                              ),
                                              child: CustomText(
                                                controller.sortOptions[controller
                                                    .selectedSortOption
                                                    .value]?[
                                                controller
                                                    .sortDirection.value] ??
                                                    "",
                                                style:
                                                AppTextStyles.customColorStyle(
                                                  textHeader: AppTextHeaders.h2,
                                                  color: (Colors.blueAccent)
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
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

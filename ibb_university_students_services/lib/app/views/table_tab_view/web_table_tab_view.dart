import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/table_tab_view_controller.dart';

import '../../styles/app_colors.dart';

// ignore: must_be_immutable
class WebTableTabView extends GetView<TableTabController> {
  double width = Get.width;
  double height = Get.height;

  WebTableTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.loadState.value)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: [
              Container(
                color: AppColors.tabBackColor,
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SecText(
                      "Section",
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.inverseIconColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Obx(() => DropdownButton(
                              items: controller.departments,
                              onChanged: controller.changeDepartment,
                              value: controller.selectedDepartment.value,
                              underline: const SizedBox(),
                              iconEnabledColor: AppColors.mainCardColor,
                              dropdownColor: AppColors.inverseCardColor,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    SecText(
                      "Level",
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.inverseIconColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Obx(() => DropdownButton(
                              items: controller.levels,
                              onChanged: controller.changeLevel,
                              value: controller.selectedLevel.value,
                              underline: const SizedBox(),
                              iconEnabledColor: AppColors.mainCardColor,
                              dropdownColor: AppColors.inverseCardColor,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    SecText(
                      "Term",
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.inverseIconColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Obx(() => DropdownButton(
                              items: controller.terms,
                              onChanged: controller.changeTerm,
                              value: controller.selectedTerm.value,
                              underline: const SizedBox(),
                              iconEnabledColor: AppColors.mainCardColor,
                              dropdownColor: AppColors.inverseCardColor,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    SecText(
                      "Year",
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.inverseIconColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Obx(() => DropdownButton(
                              items: controller.years,
                              onChanged: controller.changeYear,
                              value: controller.selectedYear.value,
                              underline: const SizedBox(),
                              iconEnabledColor: AppColors.mainCardColor,
                              dropdownColor: AppColors.inverseCardColor,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                  ],
                ),
              )
            ],
          ));
  }
}

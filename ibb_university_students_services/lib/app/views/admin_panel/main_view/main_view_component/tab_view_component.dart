import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_main_controller.dart';

import '../../../../components/custom_text_v2.dart';
import '../../../../styles/app_colors.dart';
import '../../../../styles/text_styles.dart';

// ignore: must_be_immutable
class TabViewComponent extends GetView<DashboardMainController> {
  TabViewComponent({super.key, required this.tablename, required this.index});
  String tablename;
  int index;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () => controller.changetableindex(index),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24), // Top-left corner rounded
              bottomLeft: Radius.circular(24), // Bottom-left corner rounded
            ),
            color: (controller.selectedindex.value == index)
                ? AppColors.tabBackColor
                : AppColors.inverseTabBackColor,
          ),
          padding: const EdgeInsets.only(left: 25),
          margin: const EdgeInsets.only(left: 16),
          height: Get.height * 0.08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon(
              //   Icons.library_books_outlined,
              //   color: (controller.selectedindex.value == int)
              //       ? AppColors.secTextColor
              //       : AppColors.mainTextColor,
              // ),
              SizedBox(
                width: Get.width * 0.005,
              ),
              CustomText(
                tablename.tr,
                style: AppTextStyles.customColorStyle(
                  color: (controller.selectedindex.value == index)
                      ? AppColors.secTextColor
                      : AppColors.mainTextColor,
                  textHeader: AppTextHeaders.h3Bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

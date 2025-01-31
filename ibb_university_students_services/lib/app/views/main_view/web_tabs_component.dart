import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/main_controller.dart';

import '../../components/custom_text_v2.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

// ignore: must_be_immutable
class WebTabsComponent extends GetView<MainController> {
  WebTabsComponent({
    super.key,
    required this.tabname,
    required this.index,
  });
  String tabname;
  int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.changeTabIndex(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), // Top-left corner rounded
            bottomLeft: Radius.circular(24), // Bottom-left corner rounded
          ),
          color: (controller.selectedIndex.value == index)
              ? AppColors.tabBackColor
              : AppColors.inverseCardColor,
        ),
        padding: const EdgeInsets.only(left: 25),
        margin: const EdgeInsets.only(left: 16),
        height: Get.height * 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              color: (controller.selectedIndex.value == index)
                  ? AppColors.secTextColor
                  : AppColors.mainTextColor,
            ),
            SizedBox(
              width: Get.width * 0.005,
            ),
            CustomText(
              tabname.tr,
              style: AppTextStyles.customColorStyle(
                color: (controller.selectedIndex.value == index)
                    ? AppColors.secTextColor
                    : AppColors.mainTextColor,
                textHeader: AppTextHeaders.h6Bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

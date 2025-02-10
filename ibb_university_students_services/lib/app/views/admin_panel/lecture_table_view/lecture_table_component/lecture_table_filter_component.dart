import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashbord_lecture_table_controller.dart';

// import '../../../../components/custom_text_v2.dart';
import '../../../../styles/app_colors.dart';
// import '../../../../styles/text_styles.dart';

class LectureTableFilterComponent
    extends GetView<DashbordLectureTableController> {
  double width = Get.width;
  double height = Get.height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // CustomText(
          //   "Section".tr,
          //   style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h5Bold),
          // ),
          // SizedBox(
          //   width: width * 0.002,
          // ),
          Container(
            height: height * 0.08,
            width: width * 0.13,
            decoration: BoxDecoration(
              color: AppColors.inverseIconColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Obx(() => DropdownButton(
                    items: controller.sections,
                    onChanged: controller.changeSection,
                    value: controller.selectedSection.value,
                    underline: const SizedBox(),
                    iconEnabledColor: AppColors.mainCardColor,
                    dropdownColor: AppColors.inverseCardColor,
                  )),
            ),
          ),
          SizedBox(
            width: width * 0.01,
          ),
          // CustomText(
          //   "Level".tr,
          //   style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
          // ),
          // SizedBox(
          //   width: width * 0.002,
          // ),
          Container(
            height: height * 0.08,
            width: width * 0.1,
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
            width: width * 0.01,
          ),
          // CustomText(
          //   "Term".tr,
          //   style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
          // ),
          // SizedBox(
          //   width: width * 0.002,
          // ),
          Container(
            height: height * 0.08,
            width: width * 0.1,
            decoration: BoxDecoration(
              color: AppColors.inverseIconColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Obx(() => DropdownButton(
                    items: controller.term,
                    onChanged: controller.changeTerm,
                    value: controller.selectedTerm.value,
                    underline: const SizedBox(),
                    iconEnabledColor: AppColors.mainCardColor,
                    dropdownColor: AppColors.inverseCardColor,
                  )),
            ),
          ),
          SizedBox(
            width: width * 0.01,
          ),
          // CustomText(
          //   "Order".tr,
          //   style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
          // ),
          // SizedBox(
          //   width: width * 0.002,
          // ),
          Container(
            height: height * 0.08,
            width: width * 0.12,
            decoration: BoxDecoration(
              color: AppColors.inverseIconColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Obx(() => DropdownButton(
                    items: controller.orderby,
                    onChanged: controller.changeOrder,
                    value: controller.selectedOrder.value,
                    underline: const SizedBox(),
                    iconEnabledColor: AppColors.mainCardColor,
                    dropdownColor: AppColors.inverseCardColor,
                  )),
            ),
          ),
          SizedBox(
            width: width * 0.01,
          ),
          // CustomText(
          //   "Sort".tr,
          //   style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
          // ),
          // SizedBox(
          //   width: width * 0.002,
          // ),
          Container(
            height: height * 0.08,
            width: width * 0.12,
            decoration: BoxDecoration(
              color: AppColors.inverseIconColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Obx(() => DropdownButton(
                    items: controller.sort,
                    onChanged: controller.changeSort,
                    value: controller.selectedSort.value,
                    underline: const SizedBox(),
                    iconEnabledColor: AppColors.mainCardColor,
                    dropdownColor: AppColors.inverseCardColor,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

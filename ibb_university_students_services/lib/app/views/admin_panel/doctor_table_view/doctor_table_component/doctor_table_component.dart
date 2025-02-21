import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_doctor_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';

class DoctorTableComponent extends GetView<DashboardDoctorTableController> {
  const DoctorTableComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // CustomText(
          //   "Order".tr,
          //   style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
          // ),
          // SizedBox(
          //   width: Get.width * 0.002,
          // ),
          Container(
            height: Get.height * 0.06,
            width: Get.width * 0.11,
            decoration: BoxDecoration(
              color: AppColors.inverseIconColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Obx(() => DropdownButton(
                    items: controller.orderBy,
                    onChanged: controller.changeOrder,
                    value: controller.selectedOrder.value,
                    underline: const SizedBox(),
                    iconEnabledColor: AppColors.mainCardColor,
                    dropdownColor: AppColors.inverseCardColor,
                  )),
            ),
          ),
          SizedBox(
            width: Get.width * 0.01,
          ),
          // CustomText(
          //   "Sort".tr,
          //   style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
          // ),
          // SizedBox(
          //   width: Get.width * 0.002,
          // ),
          Container(
            height: Get.height * 0.06,
            width: Get.width * 0.11,
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

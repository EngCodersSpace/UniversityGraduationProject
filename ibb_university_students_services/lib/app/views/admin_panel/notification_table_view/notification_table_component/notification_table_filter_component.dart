import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_notification_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';

class NotificationTableFilterComponent
    extends GetView<DashboardNotificationTableController> {
  const NotificationTableFilterComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: Get.height * 0.06,
            width: Get.width * 0.11,
            decoration: BoxDecoration(
              color: AppColors.inverseIconColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Obx(() => DropdownButton(
                    items: controller.type,
                    onChanged: controller.changeType,
                    value: controller.selectedType.value,
                    underline: const SizedBox(),
                    iconEnabledColor: AppColors.mainCardColor,
                    dropdownColor: AppColors.inverseCardColor,
                  )),
            ),
          ),
          SizedBox(
            width: Get.width * 0.01,
          ),
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
          SizedBox(
            width: Get.width * 0.15,
          ),
          IconButton(
            onPressed: () {
              controller.addClick();
            },
            icon: Icon(Icons.add_box_outlined),
            tooltip: "Add",
          ),
        ],
      ),
    );
  }
}

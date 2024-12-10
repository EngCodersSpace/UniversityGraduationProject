import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/table_tab_view_controller.dart';

import '../../styles/app_colors.dart';

class WebTableTabView extends GetView<TableTabController> {
  double width = Get.width;
  double height = Get.height;

  WebTableTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: AppColors.tabBackColor,
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      SecText("Section"),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      // DropdownButton(items: controller.department, onChanged: onChanged)
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

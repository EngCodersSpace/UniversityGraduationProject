import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_grad_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';

class GradTableView extends GetView<DashboardGradTableController> {
  const GradTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: controller.width,
        height: controller.height,
        padding: EdgeInsets.all(10),
        color: AppColors.tabBackColor,
        child: Column(
          children: [
            HeaderOfViewComponent(tableName: "Grad", controller: controller),
            SizedBox(
              height: controller.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}

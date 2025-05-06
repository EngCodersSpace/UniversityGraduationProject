import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_study_plan_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';

class StudyPlanTableView extends GetView<DashboardStudyPlanTableController> {
  const StudyPlanTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: controller.height,
        width: controller.width,
        padding: EdgeInsets.all(10),
        color: AppColors.tabBackColor,
        child: Column(
          children: [
            HeaderOfViewComponent(
                tableName: "Study Plan", controller: controller),
            SizedBox(
              height: controller.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}

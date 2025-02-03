import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashbord_lecture_table_controller.dart';

class LectureTableView extends GetView<DashbordLectureTableController> {
  const LectureTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () async => controller.refesh(), child: Placeholder()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_doctor_table_controller.dart';

class DoctorTableView extends GetView<DashboardDoctorTableController> {
  const DoctorTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("Doctors tabble"),
            // HeaderOfViewComponent(tableName: "Doctors",
            // controller: controller,
            // ),
          ],
        ),
      ),
    );
  }
}

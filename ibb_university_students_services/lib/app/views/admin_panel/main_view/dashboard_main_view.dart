// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_main_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/assignment_table_view/assignment_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/doctor_table_view/doctor_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/exam_table_view/exam_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/grad_table_view/grad_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/lecture_table_view/lecture_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/library_table_view/library_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/main_view/main_view_component/tab_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/notification_table_view/notification_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/payment_table_view/payment_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/role_table_view/role_users_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/student_table_view/student_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/subject_table_view/subject_table_view.dart';

import '../study_plan_table_view/study_plan_table_view.dart';

class DashboardMainView extends GetView<DashboardMainController> {
  DashboardMainView({super.key});
  double width = Get.width;
  double height = Get.height;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Container(
            color: AppColors.backColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 10),
                  width: width * 0.2,
                  height: height,
                  color: AppColors.inverseTabBackColor,
                  child: Column(
                    children: [
                      TabViewComponent(tablename: "Rols Table", index: 9),
                      TabViewComponent(tablename: "Doctor Table", index: 0),
                      TabViewComponent(tablename: "Student Table", index: 1),
                      TabViewComponent(tablename: "Subject Table", index: 2),
                      TabViewComponent(tablename: "Study plan Table", index: 3),
                      TabViewComponent(tablename: "Lecture Table", index: 4),
                      TabViewComponent(tablename: "Exam Table", index: 5),
                      TabViewComponent(tablename: "Grad Table", index: 6),
                      TabViewComponent(tablename: "Library Table", index: 7),
                      TabViewComponent(
                          tablename: "Notification Table", index: 8),
                      TabViewComponent(tablename: "Payment Table", index: 10),
                      TabViewComponent(
                          tablename: "Assignment Table", index: 11),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.backColor,
                  width: width * 0.8,
                  height: height,
                  child: screens[controller.selectedindex.value],
                ),
              ],
            ),
          ),
        ));
  }

  List screens = [
    DoctorTableView(),
    const StudentTableView(),
    const SubjectTableView(),
    const StudyPlanTableView(),
    LectureTableView(),
    const ExamTableView(),
    const GradTableView(),
    const LibraryTableView(),
    const NotificationTableView(),
    RoleUsersTableView(),
    const PaymentTableView(),
    AssignmentTableView(),
  ];
}

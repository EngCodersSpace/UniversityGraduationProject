import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashbord_lecture_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/lecture_table_view/lecture_table_component/lecture_table_filter_component.dart';

class LectureTableView extends GetView<DashbordLectureTableController> {
  double width = Get.width;
  double height = Get.height;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height * 0.8,
                  width: width,
                  padding: EdgeInsets.all(10),
                  color: AppColors.tabBackColor,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // PaginatedDataTable(columns: columns, source: source)
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: AppColors.tabBackColor,
                width: width,
                height: height * 0.2,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HederOfViewComponent(
                      tablename: "Lectures",
                      upload: () {},
                      download: () {},
                    ),
                    LectureTableFilterComponent(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

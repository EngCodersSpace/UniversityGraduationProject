import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashbord_lecture_table_controller.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/models/lecture_model/lecture_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/lecture_table_view/lecture_table_component/lecture_table_filter_component.dart';

class LectureTableView extends GetView<DashbordLectureTableController> {
  double width = Get.width;
  double height = Get.height;
  int _rowsperpage = PaginatedDataTable.defaultRowsPerPage;

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
                        PaginatedDataTable(
                          rowsPerPage: _rowsperpage,
                          availableRowsPerPage: const <int>[10, 20, 30],
                          onRowsPerPageChanged: (int? value) {
                            if (value != null) {
                              _rowsperpage = value;
                            }
                          },
                          columns: kTableColumn,
                          source: MyData(
                              controller.fetchDashboardData() as List<Lecture>),
                        )
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

  List<DataColumn> kTableColumn = <DataColumn>[
    DataColumn(
      label: CustomText("Lecture ID"),
      numeric: true,
    ),
    DataColumn(label: CustomText("Subject")),
    DataColumn(
      label: CustomText("Doctor ID"),
      numeric: true,
    ),
    DataColumn(
      label: CustomText("Duration"),
      // numeric: true,
    ),
    DataColumn(
      label: CustomText("Start Time"),
      // numeric: true,
    ),
    DataColumn(
      label: CustomText("Hall"),
      // numeric: true,
    ),
    DataColumn(
      label: CustomText("Decsription"),
    ),
  ];
}

class MyData extends DataTableSource {
  late final List<Lecture> _list;

  MyData(this._list);
  @override
  DataRow? getRow(int index) {
    if (index >= _list.length) return null;
    final lecture = _list[index];
    return DataRow(cells: [
      DataCell(CustomText(lecture.id.toString())),
      DataCell(CustomText(lecture.subject!.subjectName!.tr)),
      DataCell(CustomText(lecture.instructorId.toString())),
      DataCell(CustomText(lecture.duration.toString())),
      DataCell(CustomText(lecture.startTime!.tr)),
      DataCell(CustomText(lecture.hall!.tr)),
      DataCell(CustomText(lecture.description!.tr)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _list.length;

  @override
  int get selectedRowCount => 0;
}

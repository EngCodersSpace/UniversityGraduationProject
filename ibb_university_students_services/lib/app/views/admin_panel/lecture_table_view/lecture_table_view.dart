// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashbord_lecture_table_controller.dart';
import 'package:ibb_university_students_services/app/models/lecture_model/lecture_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/lecture_table_view/lecture_table_component/lecture_table_filter_component.dart';

class LectureTableView extends GetView<DashbordLectureTableController> {
  @override
  Widget build(BuildContext context) {
    controller.fetchDashboardData();
    final dataSours = MyData(controller.lecture?.values.toList() ?? []);
    return Scaffold(
        body: Container(
            height: Get.height,
            width: Get.width,
            padding: EdgeInsets.all(10),
            color: AppColors.tabBackColor,
            child: Column(
              children: [
                HederOfViewComponent(
                  tablename: "Lectures",
                  upload: () {},
                  download: () {},
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                LectureTableFilterComponent(),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GetBuilder<DashbordLectureTableController>(
                          id: "DataTable",
                          builder: (ctx) => PaginatedDataTable(
                            rowsPerPage: controller.rowsperpage,
                            columnSpacing: 100,
                            availableRowsPerPage: const <int>[10, 20, 30],
                            onRowsPerPageChanged: controller.onRowChange,
                            columns: kTableColumn,
                            source: dataSours,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  List<DataColumn> kTableColumn = <DataColumn>[
    DataColumn(
      label: CustomText(
        "Lecture ID",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      ),
      numeric: true,
    ),
    DataColumn(
        label: CustomText(
      "Subject",
      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
    )),
    DataColumn(
      label: CustomText(
        "Doctor ID",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      ),
      numeric: true,
    ),
    DataColumn(
      label: CustomText(
        "Duration",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      ),
      // numeric: true,
    ),
    DataColumn(
      label: CustomText(
        "Start Time",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      ),
      // numeric: true,
    ),
    DataColumn(
      label: CustomText(
        "Hall",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      ),
      // numeric: true,
    ),
    DataColumn(
      label: CustomText(
        "Decsription",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      ),
    ),
  ];
}

class MyData extends DataTableSource {
  final List<Lecture> _list;
  MyData(this._list);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _list.length) return null;
    final Lecture newlecture = _list[index];
    return DataRow.byIndex(index: index, selected: newlecture.selected, cells: [
      DataCell(CustomText(newlecture.id.toString())),
      DataCell(CustomText(newlecture.subject?.subjectName ?? "")),
      DataCell(CustomText(newlecture.instructorId.toString())),
      DataCell(CustomText(newlecture.duration.toString())),
      DataCell(CustomText(newlecture.startTime ?? "")),
      DataCell(CustomText(newlecture.hall ?? "")),
      DataCell(CustomText(newlecture.description ?? "")),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _list.length;

  @override
  int get selectedRowCount => 0;
}

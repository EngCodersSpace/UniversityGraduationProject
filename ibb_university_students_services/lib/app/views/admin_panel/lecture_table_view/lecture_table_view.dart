// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashbord_lecture_table_controller.dart';
import 'package:ibb_university_students_services/app/models/lecture_model/lecture_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/lecture_table_view/lecture_table_component/lecture_table_filter_component.dart';

class LectureTableView extends GetView<DashboardLectureTableController> {
  const LectureTableView({super.key});

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
                  tableName: "Lectures",
                  controller: controller,
                ),
                SizedBox(
                  height: controller.height * 0.01,
                ),
                LectureTableFilterComponent(),
                SizedBox(
                  height: controller.height * 0.01,
                ),
                Expanded(
                  child: Scrollbar(
                    controller: controller.vertical,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: controller.vertical,
                      child: GetBuilder<DashboardLectureTableController>(
                        id: "DataTable",
                        builder: (ctx) => Scrollbar(
                          controller: controller.horizontal,
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: PaginatedDataTable(
                            controller: controller.horizontal,
                            rowsPerPage: controller.rowsPerPage.value,
                            columnSpacing: controller.width * 0.05,
                            onPageChanged: controller.onPageChange,
                            availableRowsPerPage: const <int>[5, 10, 20, 30],
                            onRowsPerPageChanged: controller.onRowChange,
                            showCheckboxColumn: false,
                            columns: controller.kTableColumn,
                            source: MyData(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}

class MyData extends DataTableSource {
  final DashboardLectureTableController controller =
      Get.find<DashboardLectureTableController>(); // GetX Controller

  MyData();

  @override
  DataRow? getRow(int index) {
    if (index >= rowCount || items.isEmpty) {
      return null;
    }
    return DataRow.byIndex(
        index: index % controller.rowsPerPage.value,
        selected: controller.selectedRows
            .contains(items[index % controller.rowsPerPage.value].id),
        onSelectChanged: (selected) {},
        cells: [
          DataCell(
            onTap: () {},
            Obx(() => Checkbox(
                  value: controller.selectedRows.contains(
                          items[index % controller.rowsPerPage.value].id) ||
                      controller.selectAll.value,
                  onChanged: (isSelected) {
                    if (isSelected == true) {
                      controller.selectedRows
                          .add(items[index % controller.rowsPerPage.value].id);
                    } else {
                      controller.selectedRows.remove(
                          items[index % controller.rowsPerPage.value].id);
                    }
                  },
                )),
          ),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  key: UniqueKey(),
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue: items[index % controller.rowsPerPage.value]
                      .id
                      .toString())),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  key: UniqueKey(),
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue: items[index % controller.rowsPerPage.value]
                          .subject
                          ?.subjectName ??
                      "")),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  key: UniqueKey(),
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue: items[index % controller.rowsPerPage.value]
                      .instructorId
                      .toString())),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  key: UniqueKey(),
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue: items[index % controller.rowsPerPage.value]
                      .duration
                      .toString())),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  key: UniqueKey(),
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].startTime ??
                          "")),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  key: UniqueKey(),
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].hall ?? "")),
          // DataCell(CustomText(items[index%controller.rowsPerPage.value]. "mcklsadjaiochvasnvbiuwehsvbiewcjasnwegcfoiwqjnaSVCHQWJPOHFDCIU")),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  key: UniqueKey(),
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].description ??
                          "there is not descroiption")),
        ]);
  }

  List<Lecture> get items => controller.lectures.values.toList();
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.availableRows.value;

  @override
  int get selectedRowCount => 0;
}

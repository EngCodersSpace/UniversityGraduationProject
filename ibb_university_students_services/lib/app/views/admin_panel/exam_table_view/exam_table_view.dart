import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_exam_table_controller.dart';
import 'package:ibb_university_students_services/app/models/exam_model/exam_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/exam_table_view/exam_table_component/exam_table_filters_component.dart';

class ExamTableView extends GetView<DashboardExamTableController> {
  const ExamTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        color: AppColors.tabBackColor,
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            HeaderOfViewComponent(tableName: "Exam", controller: controller),
            SizedBox(
              height: Get.height * 0.01,
            ),
            ExamTableFiltersComponent(),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Expanded(
              // ignore: sized_box_for_whitespace
              child: Container(
                width: Get.width * 0.6,
                child: Scrollbar(
                  controller: controller.vertical,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    controller: controller.vertical,
                    child: GetBuilder<DashboardExamTableController>(
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
            ),
          ],
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  final DashboardExamTableController controller =
      Get.find<DashboardExamTableController>();

  MyData();

  @override
  DataRow? getRow(int index) {
    if (index >= rowCount || items.isEmpty) {
      return null;
    }
    return DataRow.byIndex(
        index: index % controller.rowsPerPage.value,
        selected: controller.selectedRow
            .contains(items[index % controller.rowsPerPage.value].id),
        onSelectChanged: (selected) {},
        cells: [
          DataCell(
            onTap: () {},
            Obx(() => Checkbox(
                  value: controller.selectedRow.contains(
                          items[index % controller.rowsPerPage.value].id) ||
                      controller.selectedAll.value,
                  onChanged: (isSelected) {
                    if (isSelected == true) {
                      controller.selectedRow
                          .add(items[index % controller.rowsPerPage.value].id);
                    } else {
                      controller.selectedRow.remove(
                          items[index % controller.rowsPerPage.value].id);
                    }
                  },
                )),
          ),
          DataCell(
              onTap: () {},
              CustomTextFormField(
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
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue: items[index % controller.rowsPerPage.value]
                      .subject
                      ?.subjectName)),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].date)),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].day)),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].examTime)),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].hall)),
        ]);
  }

  List<Exam> get items => controller.exams.values.toList();
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.availableRows.value;

  @override
  int get selectedRowCount => 0;
}

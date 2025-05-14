import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_assignment_table_controller.dart';
import 'package:ibb_university_students_services/app/models/assignment_model/assignment_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/assignment_table_view/assignment_table_component/assignment_table_filter_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';

class AssignmentTableView extends GetView<DashboardAssignmentTableController> {
  const AssignmentTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(12),
      color: AppColors.tabBackColor,
      child: Column(
        children: [
          HeaderOfViewComponent(
            tableName: "Assignment Table",
            controller: controller,
          ),
          SizedBox(
            height: controller.height * 0.01,
          ),
          AssignmentTableFilterComponent(),
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
                child: GetBuilder<DashboardAssignmentTableController>(
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
      ),
    ));
  }
}

class MyData extends DataTableSource {
  final DashboardAssignmentTableController controller =
      Get.find<DashboardAssignmentTableController>(); // GetX Controller

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
          DataCell(CustomTextFormField(
              key: UniqueKey(),
              onTapOutside: (e) {
                controller.refresh();
              },
              onFieldSubmitted: (str) {},
              enableBorder: false,
              initialValue:
                  items[index % controller.rowsPerPage.value].id.toString())),
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
                      .doctor
                      ?.name
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
                      .sectionId
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
                      .levelId
                      .toString())),
          DataCell(CustomTextFormField(
              key: UniqueKey(),
              onTapOutside: (e) {
                controller.refresh();
              },
              onFieldSubmitted: (str) {},
              enableBorder: false,
              initialValue:
                  items[index % controller.rowsPerPage.value].title ?? "")),
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
                      .assignmentDay)),
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
                      .assignmentDate)),
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
                      items[index % controller.rowsPerPage.value].dueDate)),
        ]);
  }

  List<Assignment> get items => controller.assignment.values.toList();
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.availableRows.value;

  @override
  int get selectedRowCount => 0;
}

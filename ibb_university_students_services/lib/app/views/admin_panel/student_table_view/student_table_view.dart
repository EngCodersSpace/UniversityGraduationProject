import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_student_table_controller.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/student_table_view/student_table_component/student_table_filters_component.dart';

class StudentTableView extends GetView<DashboardStudentTableController> {
  const StudentTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.tabBackColor,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            HeaderOfViewComponent(tableName: "Student", controller: controller),
            SizedBox(
              height: Get.height * 0.01,
            ),
            StudentTableFiltersComponent(),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Expanded(
              child: Scrollbar(
                controller: controller.vertical,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: controller.vertical,
                  child: GetBuilder<DashboardStudentTableController>(
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
      ),
    );
  }
}

class MyData extends DataTableSource {
  final DashboardStudentTableController controller =
      Get.find<DashboardStudentTableController>();

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
                  onTapOutside: (e) {
                    // ignore: invalid_use_of_protected_member
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
                    // ignore: invalid_use_of_protected_member
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].name)),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    // ignore: invalid_use_of_protected_member
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].dateOfBrith)),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    // ignore: invalid_use_of_protected_member
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].email)),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    // ignore: invalid_use_of_protected_member
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue: items[index % controller.rowsPerPage.value]
                          .section
                          ?.name ??
                      "")),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    // ignore: invalid_use_of_protected_member
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].level?.name ??
                          "")),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    // ignore: invalid_use_of_protected_member
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue: items[index % controller.rowsPerPage.value]
                      .phones
                      .toString())),
        ]);
  }

  List<Student> get items => controller.student.values.toList();

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.availableRows.value;

  @override
  int get selectedRowCount => 0;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_doctor_table_controller.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/doctor_table_view/doctor_table_component/doctor_table_filters_component.dart';

class DoctorTableView extends GetView<DashboardDoctorTableController> {
  const DoctorTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.tabBackColor,
        height: Get.height,
        width: Get.width,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            HeaderOfViewComponent(
              tableName: "Doctors",
              controller: controller,
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            DoctorTableFiltersComponent(),
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
                  child: GetBuilder<DashboardDoctorTableController>(
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
  final DashboardDoctorTableController controller =
      Get.find<DashboardDoctorTableController>(); // GetX Controller

  MyData();

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= rowCount) return null;
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
              CustomText(
                  items[index % controller.rowsPerPage.value].id.toString())),
          DataCell(
              onTap: () {},
              CustomText(
                  items[index % controller.rowsPerPage.value].name ?? "")),
          DataCell(
              onTap: () {},
              CustomText(items[index % controller.rowsPerPage.value]
                  .dateOfBrith
                  .toString())),
          DataCell(
              onTap: () {},
              CustomText(items[index % controller.rowsPerPage.value]
                  .email
                  .toString())),
          DataCell(
              onTap: () {},
              CustomText(
                  items[index % controller.rowsPerPage.value].role?.name ??
                      "")),
          DataCell(
              onTap: () {},
              CustomText(items[index % controller.rowsPerPage.value]
                  .phones
                  .toString())),
          DataCell(
              onTap: () {},
              CustomText(items[index % controller.rowsPerPage.value]
                  .collegeName
                  .toString())),
          DataCell(
              onTap: () {},
              CustomText(
                  items[index % controller.rowsPerPage.value].section?.name ??
                      "")),
          DataCell(
              onTap: () {},
              CustomText(items[index % controller.rowsPerPage.value]
                  .academicDegreeData
                  .toString())),
          DataCell(
              onTap: () {},
              CustomText(items[index % controller.rowsPerPage.value]
                  .administrativePositionData
                  .toString())),
        ]);
  }

  List<Doctor> get items => controller.doctors.values.toList();
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.availableRows.value;

  @override
  int get selectedRowCount => 0;
}

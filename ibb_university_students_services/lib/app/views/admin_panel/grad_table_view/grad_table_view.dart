import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_grad_table_controller.dart';
import 'package:ibb_university_students_services/app/models/grads_model/grads_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/grad_table_view/grade_table_component/grad_table_filter_component.dart';

class GradTableView extends GetView<DashboardGradTableController> {
  const GradTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: controller.width,
        height: controller.height,
        padding: EdgeInsets.all(10),
        color: AppColors.tabBackColor,
        child: Column(
          children: [
            HeaderOfViewComponent(tableName: "Grad", controller: controller),
            SizedBox(
              height: controller.height * 0.02,
            ),
            GradTableFilterComponent(),
            SizedBox(
              height: controller.height * 0.02,
            ),
            Expanded(
              child: Scrollbar(
                controller: controller.vertical,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: controller.vertical,
                  child: GetBuilder<DashboardGradTableController>(
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
  final DashboardGradTableController controller =
      Get.find<DashboardGradTableController>(); // GetX Controller

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
          // DataCell(
          //     onTap: () {},
          //     CustomTextFormField(
          //         key: UniqueKey(),
          //         onTapOutside: (e) {
          //           controller.refresh();
          //         },
          //         onFieldSubmitted: (str) {},
          //         enableBorder: false,
          //         initialValue: items[index % controller.rowsPerPage.value].stuent)),
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
                      ?.subjectNameData
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
                      .examGrad
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
                      .workGrad
                      .toString())),
          DataCell(CustomTextFormField(
              key: UniqueKey(),
              onTapOutside: (e) {
                controller.refresh();
              },
              onFieldSubmitted: (str) {},
              enableBorder: false,
              initialValue:
                  items[index % controller.rowsPerPage.value].term ?? "")),
          // DataCell(
          //     onTap: () {},
          //     CustomTextFormField(
          //         key: UniqueKey(),
          //         onTapOutside: (e) {
          //           controller.refresh();
          //         },
          //         onFieldSubmitted: (str) {},
          //         enableBorder: false,
          //         initialValue:
          //             items[index % controller.rowsPerPage.value].section )),
          DataCell(CustomTextFormField(
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
                  items[index % controller.rowsPerPage.value].yearOfIssue)),
          DataCell(CustomTextFormField(
              key: UniqueKey(),
              onTapOutside: (e) {
                controller.refresh();
              },
              onFieldSubmitted: (str) {},
              enableBorder: false,
              initialValue: items[index % controller.rowsPerPage.value]
                  .isAbsent
                  .toString())),
        ]);
  }

  List<Grad> get items => controller.grads.values.toList();
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.availableRows.value;

  @override
  int get selectedRowCount => 0;
}

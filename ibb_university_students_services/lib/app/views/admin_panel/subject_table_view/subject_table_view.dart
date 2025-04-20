import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_subjects_table_controller.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/subject_table_view/subject_table_component/subject_table_filters_component.dart';

class SubjectTableView extends GetView<DashboardSubjectsTableController> {
  const SubjectTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.tabBackColor,
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            HeaderOfViewComponent(tableName: "Subject", controller: controller),
            SizedBox(
              height: Get.height * 0.01,
            ),
            SubjectTableFiltersComponent(),
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
                      child: GetBuilder(
                          id: "DataTable",
                          builder: (ctx) => Scrollbar(
                              controller: controller.horizontal,
                              thumbVisibility: true,
                              trackVisibility: true,
                              child: PaginatedDataTable(
                                controller: controller.horizontal,
                                rowsPerPage: controller.rowsPerPage.value,
                                columnSpacing: controller.width * 0.05,
                                onPageChanged: controller.onPageChang,
                                availableRowsPerPage: <int>[5, 10, 20, 30],
                                onRowsPerPageChanged: controller.onRowChange,
                                showCheckboxColumn: false,
                                columns: controller.kTableColumn,
                                source: MyData(),
                              ))),
                    )))
          ],
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  DashboardSubjectsTableController controller =
      Get.find<DashboardSubjectsTableController>();

  MyData();

  @override
  DataRow? getRow(int index) {
    if (index >= rowCount || items.isEmpty) {
      return null;
    }
    return DataRow.byIndex(
        index: index % controller.rowsPerPage.value,
        selected: controller.selectedRow
            .contains(items[index % controller.rowsPerPage.value].id as int),
        onSelectChanged: (selected) {},
        cells: [
          DataCell(
            onTap: () {},
            Obx(() => Checkbox(
                  value: controller.selectedRow.contains(
                          items[index % controller.rowsPerPage.value].id
                              as int) ||
                      controller.selectedAll.value,
                  onChanged: (isSelected) {
                    if (isSelected == true) {
                      controller.selectedRow.add(
                          items[index % controller.rowsPerPage.value].id
                              as int);
                    } else {
                      controller.selectedRow.remove(
                          items[index % controller.rowsPerPage.value].id
                              as int);
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
                  initialValue:
                      items[index % controller.rowsPerPage.value].id)),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].subjectName)),
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue: items[index % controller.rowsPerPage.value]
                      .units
                      .toString())),
          // DataCell(
          //     onTap: () {},
          //     CustomTextFormField(
          //         onTapOutside: (e) {
          //           controller.refresh();
          //         },
          //         onFieldSubmitted: (str) {},
          //         enableBorder: false,
          //         initialValue: items[index % controller.rowsPerPage.value]
          //             .instructors
          //             ?.values
          //             .first
          //             .name)),
          // DataCell(
          //     onTap: () {},
          //     CustomTextFormField(
          //         onTapOutside: (e) {
          //           controller.refresh();
          //         },
          //         onFieldSubmitted: (str) {},
          //         enableBorder: false,
          //         initialValue:
          //             items[index % controller.rowsPerPage.value].Section.name)),//import the section name
          // DataCell(
          //     onTap: () {},
          //     CustomTextFormField(
          //         onTapOutside: (e) {
          //           controller.refresh();
          //         },
          //         onFieldSubmitted: (str) {},
          //         enableBorder: false,
          //         initialValue:
          //             items[index % controller.rowsPerPage.value].Level.name)),//import the level name
          DataCell(
              onTap: () {},
              CustomTextFormField(
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue:
                      items[index % controller.rowsPerPage.value].description)),
        ]);
  }

  List<Subject> get items => controller.subjects.values.toList();

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.availableRows.value;

  @override
  int get selectedRowCount => 0;
}

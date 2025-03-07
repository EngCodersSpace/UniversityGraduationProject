import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_role_users_table_controller.dart';
import 'package:ibb_university_students_services/app/models/role_model/role.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/doctor_table_view/doctor_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/role_table_view/role_table_component/role_table_filter_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/student_table_view/student_table_view.dart';

// ignore: must_be_immutable
class RoleUsersTableView extends GetView<DashboardRoleUsersTableController> {
  RoleUsersTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        color: AppColors.tabBackColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderOfViewComponent(tableName: "Roles", controller: controller),
            SizedBox(
              height: Get.height * 0.01,
            ),
            RoleTableFilterComponent(),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: Get.width * 0.35,
                      child: Scrollbar(
                        controller: controller.vertical,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: controller.vertical,
                          child: GetBuilder<DashboardRoleUsersTableController>(
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
                                availableRowsPerPage: const <int>[5, 10],
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
                  SizedBox(
                    width: Get.width * 0.15,
                  ),
                  Container(
                    width: Get.width * 0.25,
                    child: Column(
                      children: [
                        Obx(() => InkWell(
                              onTap: () => controller.changeDoctorTableView(),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: (controller.selectedIndex.value == 0)
                                        ? AppColors.tabBackColor
                                        : AppColors.inverseTabBackColor,
                                  ),
                                  child: CustomText(
                                    "Doctor Table",
                                    style: AppTextStyles.customColorStyle(
                                      color:
                                          (controller.selectedIndex.value == 0)
                                              ? AppColors.secTextColor
                                              : AppColors.mainTextColor,
                                      textHeader: AppTextHeaders.h6Bold,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        Obx(() => InkWell(
                              onTap: () => controller.changeStudentTableView(),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: (controller.selectedIndex.value == 1)
                                        ? AppColors.tabBackColor
                                        : AppColors.inverseTabBackColor,
                                  ),
                                  child: CustomText(
                                    "Student Table",
                                    style: AppTextStyles.customColorStyle(
                                      color:
                                          (controller.selectedIndex.value == 1)
                                              ? AppColors.secTextColor
                                              : AppColors.mainTextColor,
                                      textHeader: AppTextHeaders.h6Bold,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Container(
            //   color: AppColors.tabBackColor,
            //   padding: EdgeInsets.all(5),
            //   width: Get.width * 0.8,
            //   height: Get.height,
            //   child: screen[controller.selectedIndex.value],
            // ),
          ],
        ),
      ),
    );
  }

  // List screen = [
  //   DoctorTableView(),
  //   StudentTableView(),
  // ];
}

class MyData extends DataTableSource {
  final DashboardRoleUsersTableController controller =
      Get.find<DashboardRoleUsersTableController>(); // GetX Controller

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
                  initialValue:
                      items[index % controller.rowsPerPage.value].name)),
        ]);
  }

  List<Role> get items => controller.roles.values.toList();
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.availableRows.value;

  @override
  int get selectedRowCount => 0;
}

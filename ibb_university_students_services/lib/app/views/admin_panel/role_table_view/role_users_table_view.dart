import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_role_users_table_controller.dart';
import 'package:ibb_university_students_services/app/models/role_model/role.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/role_table_view/role_table_component/role_table_filter_component.dart';

// ignore: must_be_immutable
class RoleUsersTableView extends GetView<DashboardRoleUsersTableController> {
  const RoleUsersTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        color: AppColors.tabBackColor,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderOfViewComponent(tableName: "Roles", controller: controller),
            SizedBox(
              height: Get.height * 0.01,
            ),
            RoleTableFilterComponent(),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                width: Get.width * 0.3,
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
                          columnSpacing: controller.width * 0.06,
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
            Obx(
              () => InkWell(
                onTap: () => controller.changeDoctorTableView(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24), // Top-left corner rounded
                      bottomLeft:
                          Radius.circular(24), // Bottom-left corner rounded
                    ),
                    color: (controller.selectedIndex.value == 0)
                        ? AppColors.tabBackColor
                        : AppColors.inverseTabBackColor,
                  ),
                  padding: const EdgeInsets.only(left: 25),
                  margin: const EdgeInsets.only(left: 16),
                  height: Get.height * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon(
                      //   Icons.library_books_outlined,
                      //   color: (controller.selectedindex.value == int)
                      //       ? AppColors.secTextColor
                      //       : AppColors.mainTextColor,
                      // ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      CustomText(
                        "Doctor".tr,
                        style: AppTextStyles.customColorStyle(
                          color: (controller.selectedIndex.value == 0)
                              ? AppColors.secTextColor
                              : AppColors.mainTextColor,
                          textHeader: AppTextHeaders.h6Bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => InkWell(
                onTap: () => controller.changeStudentTableView(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24), // Top-left corner rounded
                      bottomLeft:
                          Radius.circular(24), // Bottom-left corner rounded
                    ),
                    color: (controller.selectedIndex.value == 1)
                        ? AppColors.tabBackColor
                        : AppColors.inverseTabBackColor,
                  ),
                  padding: const EdgeInsets.only(left: 25),
                  margin: const EdgeInsets.only(left: 16),
                  height: Get.height * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon(
                      //   Icons.library_books_outlined,
                      //   color: (controller.selectedindex.value == int)
                      //       ? AppColors.secTextColor
                      //       : AppColors.mainTextColor,
                      // ),
                      SizedBox(
                        width: Get.width * 0.005,
                      ),
                      CustomText(
                        "Student".tr,
                        style: AppTextStyles.customColorStyle(
                          color: (controller.selectedIndex.value == 1)
                              ? AppColors.secTextColor
                              : AppColors.mainTextColor,
                          textHeader: AppTextHeaders.h6Bold,
                        ),
                      ),
                    ],
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

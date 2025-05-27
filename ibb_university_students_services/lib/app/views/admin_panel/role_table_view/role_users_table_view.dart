import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
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
            Row(children: [
              SizedBox(
                height: Get.height * 0.6,
                width: Get.width * 0.3,
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: Get.width * 0.2,
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
                            columnSpacing: controller.width * 0.1,
                            onPageChanged: controller.onPageChange,
                            availableRowsPerPage: const <int>[5, 10],
                            onRowsPerPageChanged: controller.onRowChange,
                            showCheckboxColumn: false,
                            columns: controller.kTableColumn,
                            source: MyData(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Get.width * 0.001,
              ),
              GetBuilder<DashboardRoleUsersTableController>(
                id: "rolePermissions",
                builder: (ctx) => Container(
                  width: Get.width * 0.47,
                  height: Get.height * 0.6,
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Scrollbar(
                      controller: controller.horizontal,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: Column(children: [
                        if (controller.selectedIndex.value != -1) ...[
                          ...?controller.roles[controller.selectedIndex.value]
                              ?.permissions.entries
                              .map<Widget>((e) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomText(
                                  "${e.key} : ",
                                  style: AppTextStyles.secStyle(),
                                ),
                                CustomText(
                                  " ${e.value}",
                                  style: AppTextStyles.secStyle(),
                                ),
                              ],
                            );
                          })
                        ],
                        Center(
                          child: CustomText("Please Select a Role",
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h3Bold)),
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  final BuildContext context;
  final DashboardRoleUsersTableController controller =
      Get.find<DashboardRoleUsersTableController>(); // GetX Controller

  MyData(this.context);

  List<String> permitionActions = [];

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
            onTap: () => controller.changeSelectedRole(
                items[index % controller.rowsPerPage.value].id),
            CustomText(
                items[index % controller.rowsPerPage.value].id.toString()),
          ),
          DataCell(
            onTap: () => controller.changeSelectedRole(
                items[index % controller.rowsPerPage.value].id),
            CustomText(
                key: UniqueKey(),
                items[index % controller.rowsPerPage.value].name.toString()),
          ),
          DataCell(
            onTap: () => controller.changeSelectedRole(
                items[index % controller.rowsPerPage.value].id),
            CustomText(
                key: UniqueKey(),
                items[index % controller.rowsPerPage.value].roleType.toString()),
          ),
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

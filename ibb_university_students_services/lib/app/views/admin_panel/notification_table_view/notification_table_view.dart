import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_notification_table_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/models/notification_model/notification_model.dart'
    as custom;
import 'package:ibb_university_students_services/app/views/admin_panel/dashboard_component/heder_of_view_component.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/notification_table_view/notification_table_component/notification_table_filter_component.dart';

class NotificationTableView
    extends GetView<DashboardNotificationTableController> {
  const NotificationTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(12),
        color: AppColors.tabBackColor,
        child: Column(
          children: [
            HeaderOfViewComponent(
              tableName: "Notification Table",
              controller: controller,
            ),
            SizedBox(
              height: controller.height * 0.01,
            ),
            NotificationTableFilterComponent(),
            SizedBox(
              height: controller.height * 0.01,
            ),
            Expanded(
              // ignore: sized_box_for_whitespace
              child: Container(
                width: Get.width * 0.7,
                child: Scrollbar(
                  controller: controller.vertical,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    controller: controller.vertical,
                    child: GetBuilder<DashboardNotificationTableController>(
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
                          availableRowsPerPage: const <int>[5, 10, 20],
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
  final DashboardNotificationTableController controller =
      Get.find<DashboardNotificationTableController>();

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
                  key: UniqueKey(),
                  onTapOutside: (e) {
                    controller.refresh();
                  },
                  onFieldSubmitted: (str) {},
                  enableBorder: false,
                  initialValue: items[index % controller.rowsPerPage.value]
                      .id
                      .toString())),
          // DataCell(
          //     onTap: () {},
          //     CustomTextFormField(
          //         key: UniqueKey(),
          //         onTapOutside: (e) {
          //           controller.refresh();
          //         },
          //         onFieldSubmitted: (str) {},
          //         enableBorder: false,
          //         initialValue: items[index % controller.rowsPerPage.value].)),
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
          //             items[index % controller.rowsPerPage.value].date ?? "")),
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
          //             items[index % controller.rowsPerPage.value].examTime ??
          //                 "")),
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
          //             items[index % controller.rowsPerPage.value].day ?? "")),
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
          //             items[index % controller.rowsPerPage.value].hall ?? "")),
        ]);
  }

  List<custom.Notification> get items =>
      controller.notifications.values.toList();
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.availableRows.value;

  @override
  int get selectedRowCount => 0;
}

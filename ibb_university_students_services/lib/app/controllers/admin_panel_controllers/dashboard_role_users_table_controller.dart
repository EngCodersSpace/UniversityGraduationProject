import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/models/role_model/role.dart';
import 'package:ibb_university_students_services/app/repositories/role_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';

class DashboardRoleUsersTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxInt roleId = 0.obs;
  RxBool loadingState = true.obs;
  RxMap<int, Role> roles = RxMap({});
  ScrollController horizontal = ScrollController();
  ScrollController vertical = ScrollController();
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  List<DataColumn> kTableColumn = [];
  RxInt selectedIndex = (-1).obs;
  Timer? _debounce;
  int currentPage = 1;
  RxBool selectAll = false.obs;
  RxSet<int> selectedRows = RxSet({});
  RxInt availableRows = 0.obs;
  RxString selectedOrder = "id".obs;
  RxString selectedSort = "DESC".obs;
  RxString faildMessage = "".obs;
  List<DropdownMenuItem<String>> orderBy = [
    DropdownMenuItem<String>(
        value: "id",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "ID",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "roleName",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Role Name",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
  ];
  List<DropdownMenuItem<String>> sort = [
    DropdownMenuItem<String>(
        value: "DESC",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Descending",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "ASC",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Ascending",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
  ];

  @override
  void onInit() async {
    searchController.addListener(() {
      onSearch();
    });
    kTableColumn = <DataColumn>[
      DataColumn(
        label: Obx(() => Checkbox(
              value: selectAll.value,
              onChanged: (isSelected) {
                if (isSelected == null) return;
                selectAll.value = isSelected;
              },
            )),
      ),
      DataColumn(
        label: CustomText(
          "Role ID",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        numeric: true,
      ),
      DataColumn(
          label: CustomText(
        "Name",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      // DataColumn(
      //     label: CustomText(
      //   "permision",
      //   style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      // )),
    ];
    await fetchRoleData();
    loadingState.value = false;
    super.onInit();
  }

  @override
  void refresh() async {
    await fetchRoleData();
  }

  Future<void> fetchRoleData({bool showSnakeBars = true}) async {
    Result res = await RoleRepository.fetchDashboardRole(
      order: selectedOrder.value,
      sort: selectedSort.value,
      limit: rowsPerPage.value,
      page: currentPage,
      search: searchController.text,
      hardFech: false,
    );
    if (res.statusCode == 200) {
      roles.value = res.data["roles"] ?? {};
      availableRows.value = res.data["totalroles"] ?? 0;
    } else if (res.statusCode == 401) {
      roles.value = {};
      availableRows.value = 0;
      faildMessage.value = "there is no roles";
      if (showSnakeBars) {
        showSnakeBar(
          title: "Not Found Roles",
          message: "there is not a Role can fetch",
        );
      }
    } else {
      roles.value = {};
      availableRows.value = 0;
      faildMessage.value = "fetching Roles faild please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Role Faild",
            message: "fetching Roles faild please check connection");
      }
    }
    update(["DataTable"]);
  }


  void changeSelectedRole(int? val){
    if(val == null)return;
    selectedIndex.value = val;
    update(["rolePermissions"]);
  }

  // Future<void> showPermition() async {
  //   Permission? permitionData=await RoleRepository.fetchDashbordPermition(id: roleId.value).then((e)=>e.data);

  // }

  void onPageChange(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchRoleData();
  }

  void onRowChange(int? value) async {
    if (value != null) {
      rowsPerPage.value = value;
      await fetchRoleData();
      update(["DataTable"]);
    }
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchRoleData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchRoleData();
  }

  void addClick() {}

  @override
  void export() {}

  @override
  void import() {}

  String prevTxt = "";

  @override
  void onSearch() {
    if (searchController.text == prevTxt) return;
    prevTxt = searchController.text;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 600), () async {
      await fetchRoleData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void onClose() {}
}

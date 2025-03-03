// ignore: implementation_imports
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import '../../utils/snake_bar.dart';

class DashboardDoctorTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  RxMap<int, Doctor> doctors = RxMap({});
  RxBool loadingState = true.obs;
  RxString fieldMessage = "".obs;
  RxString selectedOrder = "doctor_id".obs;
  RxString selectedSort = "DESC".obs;
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  int currentPage = 1;
  RxInt availableRows = 0.obs;
  List<DataColumn> kTableColumn = [];
  Timer? _debounce;
  List<DropdownMenuItem<String>> orderBy = [
    DropdownMenuItem<String>(
        value: "doctor_id",
        child: SizedBox(
            width: (Get.width / 3) * 0.3,
            child: CustomText(
              "Doctor Id",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "academic_degree",
        child: SizedBox(
            width: (Get.width / 3) * 0.3,
            child: CustomText(
              "Academic Degree",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "administrative_position",
        child: SizedBox(
            width: (Get.width / 2) * 0.2,
            child: CustomText(
              "Administrative Position",
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
  ScrollController horizontal = ScrollController();
  ScrollController vertical = ScrollController();
  RxBool selectAll = false.obs;
  RxSet<int> selectedRows = RxSet({});

  @override
  // ignore: unnecessary_overrides
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
          "Doctor ID",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        numeric: true,
      ),
      DataColumn(
          label: CustomText(
        "Name",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
        label: CustomText(
          "Date of Birth",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Email",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        // numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Role",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        // numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Phone Number",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        // numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "College",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Section",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Acadimic Degree",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "administrative Position",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
    ];
    await fetchDoctoreData();
    loadingState.value = false;
    super.onInit();
  }

  void onRowChange(int? value) async {
    if (value != null) {
      rowsPerPage.value = value;
      await fetchDoctoreData();
      update(["DataTable"]);
    }
  }

  Future<void> fetchDoctoreData({bool showSnakeBars = true}) async {
    Result results = await UserRepository.fetchDashboardDoctors();
    if (results.statusCode == 200) {
      doctors.value = results.data["Doctors"] ?? {};
    } else if (results.statusCode == 404) {
      doctors.value = {};
      availableRows.value = results.data["totalLectures"];
      update(["DataTable"]);

      fieldMessage.value = "this section and level not has Lectures";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Lectures",
            message: "this section and level doesn't has Lectures ");
      }
    } else {
      doctors.value = {};
      fieldMessage.value = "fetching lectures failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Lectures Failed",
            message: "fetching lectures failed please check connection ");
      }
    }
  }

  void onPageChange(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchDoctoreData();
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchDoctoreData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchDoctoreData();
  }

  @override
  // ignore: unnecessary_overrides
  void onClose() {
    super.onClose();
  }

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
      await fetchDoctoreData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");
}

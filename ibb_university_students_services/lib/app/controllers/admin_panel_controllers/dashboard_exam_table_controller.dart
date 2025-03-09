import "dart:async";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ibb_university_students_services/app/components/custom_text_v2.dart";
import "package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart";
import "package:ibb_university_students_services/app/models/exam_model/exam_model.dart";
import "package:ibb_university_students_services/app/models/helper_models/result.dart";
import "package:ibb_university_students_services/app/repositories/exam_repository.dart";
import "package:ibb_university_students_services/app/styles/text_styles.dart";
import "package:ibb_university_students_services/app/utils/snake_bar.dart";

class DashboardExamTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  RxMap<int, Exam> exams = RxMap({});
  RxInt availableRows = 0.obs;
  RxString fieldMessage = "".obs;
  RxBool loadingState = true.obs;
  Timer? _debounce;
  int currentPage = 1;
  RxString selectedOrder = "doctor_id".obs;
  RxString selectedSort = "DESC".obs;
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  ScrollController vertical = ScrollController();
  ScrollController horizontal = ScrollController();
  List<DataColumn> kTableColumn = [];
  RxBool selectedAll = false.obs;
  RxSet selectedRow = RxSet({});
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
  @override
  void onInit() async {
    searchController.addListener(() {
      onSearch();
    });
    kTableColumn = <DataColumn>[
      DataColumn(
          label: Obx(() => Checkbox(
              value: selectedAll.value,
              onChanged: (isSelected) {
                if (isSelected == null) return;
                selectedAll.value = isSelected;
              }))),
      DataColumn(
        label: CustomText(
          "Exam ID",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Subject",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Date",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        // numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Time",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        // numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Day",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        // numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Hall",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        // numeric: true,
      ),
    ];
    await fetchExamsData();
    loadingState.value = false;
    super.onInit();
  }

  @override
  void refresh() async {
    await fetchExamsData();
  }

  void onRowChange(int? value) async {
    if (value != null) {
      rowsPerPage.value = value;
      await fetchExamsData();
      update(["DataTable"]);
    }
  }

  void onPageChange(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchExamsData();
  }

  Future<void> fetchExamsData({bool showSnakeBars = true}) async {
    Result res = await ExamRepository.fetchDashboardExam();
    if (res.statusCode == 200) {
      exams.value = res.data["exams"] ?? {};
    } else if (res.statusCode == 404) {
      exams.value = {};
      availableRows.value = res.data["totalLectures"];
      update(["DataTable"]);

      fieldMessage.value = "this section and level not has Lectures";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Lectures",
            message: "this section and level doesn't has Lectures ");
      }
    } else {
      exams.value = {};
      fieldMessage.value = "fetching lectures failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Lectures Failed",
            message: "fetching lectures failed please check connection ");
      }
    }
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchExamsData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchExamsData();
  }

  Future<void> addClick() async {}

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
      await fetchExamsData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void onClose() {}
}

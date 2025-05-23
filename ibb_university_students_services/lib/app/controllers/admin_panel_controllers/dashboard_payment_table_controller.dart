import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import 'package:ibb_university_students_services/app/repositories/level_repository.dart';
import 'package:ibb_university_students_services/app/repositories/student_fee_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/payment_table_view/payment_table_component/add_payment_table_card.dart';

class DashboardPaymentTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  RxMap<int, StudentFee> studentFee = RxMap({});
  RxBool loadingstate = true.obs;
  GlobalKey<FormState> formKey = GlobalKey();
  ScrollController vertical = ScrollController();
  ScrollController horizontal = ScrollController();
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  int currentPage = 1;
  RxInt availableRows = 0.obs;
  RxString fieldMessage = "".obs;
  RxSet<int> selectedRows = RxSet({});
  RxBool selectAll = false.obs;
  List<DataColumn> kTableColumn = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> term = [
    DropdownMenuItem<String>(
        value: "",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "All",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Term 1",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "1st",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Term 2",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "2ec",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
  ];
  List<DropdownMenuItem<String>> orderBy = [
    DropdownMenuItem<String>(
        value: "payment_date",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "payment date",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "total_amount",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Total amount",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "amount_paid",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Amount paid",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "receipt_number",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Receipt number",
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
  RxString selectedOrder = "payment_date".obs;
  RxString selectedSort = "DESC".obs;
  Rx<int?> selectedLevel = Rx(null);
  Rx<String?> selectedTerm = "".obs;
  Timer? _debounce;

  //popup component
  List<Level>? level;
  Rx<int?> levelId = Rx(null);
  Student? student;
  RxString addTerm = "".obs;
  List<DropdownMenuItem<String>> addterm = [
    DropdownMenuItem<String>(
        value: "",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "All",
              style: AppTextStyles.secStyle(
                textHeader: AppTextHeaders.h3Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Term 1",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "1st",
              style: AppTextStyles.secStyle(
                textHeader: AppTextHeaders.h3Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Term 2",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "2ec",
              style: AppTextStyles.secStyle(
                textHeader: AppTextHeaders.h3Bold,
              ),
            ))),
  ];
  TextEditingController studentId = TextEditingController();
  TextEditingController amountPaid = TextEditingController();
  TextEditingController payDate = TextEditingController();
  TextEditingController totalPaid = TextEditingController();
  TextEditingController reciptNum = TextEditingController();
  FocusNode totalFocus = FocusNode();
  FocusNode idFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode reciptFocus = FocusNode();
  int? studentID;
  int? selectedFee;
  String mode = "Add";

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
              }))),
      DataColumn(
          label: CustomText(
        "Student Fee ID",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Student ID",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Level",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Term",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Total amount",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Amount paid",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Payment date",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Receipt number",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
    ];
    await initLevelDashboardMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    await fetchPaymentData();
    loadingstate.value = false;
    super.onInit();
  }

  @override
  void refresh() {
    fetchPaymentData();
    super.refresh();
  }

  Future<void> fetchPaymentData({
    bool showSnakeBars = true,
  }) async {
    if (selectedLevel.value == null) {
      await initLevelDashboardMenuList();
      if (levels.isNotEmpty) {
        selectedLevel.value = levels.first.value;
      }
    }

    if (selectedLevel.value == null) return;

    Result res = await StudentFeeRepository.fetchDashboardPayment(
      levelId: (selectedLevel.value == 0) ? null : selectedLevel.value,
      term: (selectedTerm.value == "") ? "" : selectedTerm.value,
      order: selectedOrder.value,
      sort: selectedSort.value,
      limit: rowsPerPage.value,
      page: currentPage,
      search: searchController.text,
    );
    if (res.statusCode == 200) {
      studentFee.value = res.data["studentFee"] ?? {};
      availableRows.value = res.data["totalStudentFee"] ?? 0;
    } else if (res.statusCode == 404) {
      studentFee.value = {};
      availableRows.value = 0;
      fieldMessage.value = "this section and level not has Student Fee";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Student Fee",
            message: "this section and level doesn't has Student Fee ");
      }
    } else {
      studentFee.value = {};
      fieldMessage.value =
          "fetching Student Fee failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Student Fee Failed",
            message: "fetching Student Fee failed please check connection ");
      }
    }
    update(["DataTable"]);
  }

  void changeTerm(String? val) async {
    if (val == null) return;
    selectedTerm.value = val;
    fetchPaymentData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchPaymentData();
  }

  Future<void> initLevelDashboardMenuList({bool force = false}) async {
    List<Level> levelsData = await LevelRepository.fetchLevels(hardFetch: force)
        .then((e) => e.data?.values.toList() ?? []);
    levels = [
      DropdownMenuItem<int>(
          value: 0,
          child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "All",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h6Bold),
            ),
          )),
    ];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (Get.width / 8) * 0.4,
              child: CustomText(
                level.name ?? "unknown",
                style:
                    AppTextStyles.mainStyle(textHeader: AppTextHeaders.h6Bold),
              ),
            )),
      );
    }
    selectedLevel.value = levelsData.first.id;
  }

  void onPageChang(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchPaymentData();
  }

  void onRowChange(int? val) async {
    if (val != null) {
      rowsPerPage.value = val;
      await fetchPaymentData();
      update(["DataTable"]);
    }
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchPaymentData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchPaymentData();
  }

  void addClick() async {
    await getLevel();
    payDate.text = DateTime.now().toString().split("")[0];
    Get.dialog(PopUpAddPaymentCard());
  }

  void changeAddTerm(String? val) async {
    if (val == null) return;
    addTerm.value = val;
  }

  Future<void> getLevel() async {
    level = await LevelRepository.fetchLevels()
        .then((e) => e.data?.values.toList() ?? []);
    if (level?.isNotEmpty ?? false) {
      levelId = Rx(level?.first.id ?? 0);
    } else {
      levelId.value = null;
    }
  }

  Future<void> addPayment() async {
    Map<String, dynamic> jsData = {};
    if (studentID == null) return;
    jsData["id"] = selectedFee;
    jsData["student_id"] = studentId;
    jsData["term"] = selectedTerm.value;
    jsData["level_fees_id"] = levelId.value;
    jsData["remaining_amount"] = 0;
    if (formKey.currentState!.validate()) {
      (payDate.text.isNotEmpty && payDate.text != "Unknown".tr)
          ? jsData["payment_date"] = payDate.text
          : null;
      (reciptNum.text.isNotEmpty && reciptNum.text != "Unknown".tr)
          ? jsData["receipt_number"] = reciptNum.text
          : null;
      (totalPaid.text.isNotEmpty && totalPaid.text != "Unknown".tr)
          ? jsData["total_amount"] = totalPaid.text
          : null;
      (amountPaid.text.isNotEmpty && amountPaid.text != "Unknown".tr)
          ? jsData["amount_paid"] = amountPaid.text
          : null;
    }

    if (mode == "Add") {
      Result<StudentFee> res = await StudentFeeRepository.createStudentFee(
          studentId: int.parse(studentId.text), data: jsData);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 201 && res.data != null) {
        studentFee[res.data!.id] = res.data!;
        studentFee.refresh();
        showSnakeBar(message: "Add successfully");
      } else {
        showSnakeBar(message: "Add failed");
      }
    } else if (mode == "Edit") {
      Result<StudentFee> res = await StudentFeeRepository.updateStudentFee(
          studentId: int.parse(studentId.text), data: jsData, id: selectedFee);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200 && res.data != null) {
        studentFee[res.data!.id] = res.data!;
        studentFee.refresh();
        showSnakeBar(message: "Edit successfully");
      } else {
        showSnakeBar(message: "Edit failed");
      }
    }
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
      await fetchPaymentData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");

  void popupClear() {
    studentId.clear();
    amountPaid.clear();
    payDate.clear();
    reciptNum.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    popupClear();
    studentId.dispose();
    amountPaid.dispose();
    payDate.dispose();
    reciptNum.dispose();
    idFocus.dispose();
    amountFocus.dispose();
    dateFocus.dispose();
    reciptFocus.dispose();
  }
}

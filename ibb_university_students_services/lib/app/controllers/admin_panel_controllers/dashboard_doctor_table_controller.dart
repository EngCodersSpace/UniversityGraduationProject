// ignore: implementation_imports
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/repositories/section_repository.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/doctor_table_view/doctor_table_component/add_doctor_table_card.dart';
import '../../utils/snake_bar.dart';

class DashboardDoctorTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
              "Doctor ID",
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

  //popup add doctor card
  TextEditingController doctorId = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController college = TextEditingController();
  TextEditingController acadimicDegree = TextEditingController();
  TextEditingController adminPosition = TextEditingController();
  FocusNode doctorIdFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode dateOfBirthFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode roleFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode collegeFocus = FocusNode();
  FocusNode acadimicFocus = FocusNode();
  FocusNode administrativeFocus = FocusNode();
  Map<int, Section> section = <int, Section>{}.obs;
  // ignore: non_constant_identifier_names
  Rx<int?> SectionId = Rx(null);

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
      ),
      DataColumn(
        label: CustomText(
          "Email",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Role",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Phone Number",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
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

  @override
  void refresh() async {
    await fetchDoctoreData();
  }

  void onRowChange(int? value) async {
    if (value != null) {
      rowsPerPage.value = value;
      await fetchDoctoreData();
      update(["DataTable"]);
    }
  }

  Future<void> fetchDoctoreData({bool showSnakeBars = true}) async {
    Result results = await UserRepository.fetchDashboardDoctors(
        order: selectedOrder.value,
        sort: selectedSort.value,
        search: searchController.text,
        limit: rowsPerPage.value,
        page: currentPage);
    if (results.statusCode == 200) {
      doctors.value = results.data["Doctors"] ?? {};
      availableRows.value = results.data["totalDoctor"] ?? 0;
    } else if (results.statusCode == 404) {
      doctors.value = {};
      availableRows.value = results.data["totalDoctor"];
      fieldMessage.value = "there is no doctors";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found doctors", message: "there is no doctors ");
      }
    } else {
      doctors.value = {};
      fieldMessage.value = "fetching Doctors failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Doctors Failed",
            message: "fetching Doctors failed please check connection ");
      }
    }
    update(["DataTable"]);
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

  Future<void> getSection() async {
    section = await SectionRepository.fetchSections().then((e) => e.data ?? {});
    if (section.isNotEmpty) {
      SectionId = RxInt(section.values.first.id);
    } else {
      SectionId.value = null;
    }
  }

  Future<void> addClick() async {
    await getSection();
    Get.dialog(const PopUpAddDoctorCard());
  }

  Future<void> addDoctor() async {}

  @override
  void export() {}

  @override
  void import() {}

  get jsdata => null;

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

  @override
  // ignore: unnecessary_overrides
  void onClose() {
    super.onClose();
  }
}

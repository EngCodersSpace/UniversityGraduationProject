// ignore: implementation_imports
import 'dart:async';

import 'package:file_picker/file_picker.dart';
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
  TextEditingController doctorPhone1 = TextEditingController();
  TextEditingController doctorPhone2 = TextEditingController();
  TextEditingController doctorPhone3 = TextEditingController();
  TextEditingController college = TextEditingController();
  TextEditingController acadimicDegree = TextEditingController();
  TextEditingController adminPosition = TextEditingController();
  FocusNode doctorIdFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode dateOfBirthFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode roleFocus = FocusNode();
  FocusNode phone1Focus = FocusNode();
  FocusNode phone2Focus = FocusNode();
  FocusNode phone3Focus = FocusNode();
  FocusNode collegeFocus = FocusNode();
  FocusNode acadimicFocus = FocusNode();
  FocusNode administrativeFocus = FocusNode();
  Map<int, Section> section = <int, Section>{}.obs;
  // ignore: non_constant_identifier_names
  Rx<int?> SectionId = Rx(null);
  RxList<Map<String, String>> groupPhons = RxList();

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
      page: currentPage,
      hardfetch: false,
    );
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

  void addGroup(
    String phone1,
    String phone2,
    String phone3,
  ) {
    //copy to dashboard
    if (groupPhons.any((map) =>
        map["phone_number"] == phone1 &&
        map["phone_number"] == phone2 &&
        map["phone_number"] == phone3)) {
      showSnakeBar(message: "Group Already Exists");
      return;
    }
    groupPhons.add(
      // ignore: equal_keys_in_map
      {"phone_number": phone1, "phone_number": phone2, "phone_number": phone3},
    );
  }

  void delGroup(int index) {
    groupPhons.removeAt(index);
  }

  Future<void> addDoctor() async {
    if (formKey.currentState!.validate()) {
      Result<Doctor> res = await UserRepository.createDoctor(
          doctorId: int.parse(doctorId.text),
          sectionId: SectionId.value!,
          roleId: int.parse(role.text),
          name: name.text,
          dateOfBirth: dateOfBirth.text,
          college: college.text,
          email: email.text,
          password: "12345678",
          academicdegree: acadimicDegree.text,
          postion: adminPosition.text,
          phonenumber: groupPhons);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        doctors[res.data!.id] = res.data!;
        doctors.refresh();
        showSnakeBar(message: "Add successfully");
      } else {
        showSnakeBar(message: "Add failed");
      }
      update(["DataTable"]);
    }
  }

  @override
  void export() async {
    await UserRepository.exportDoctors();
  }

  @override
  void import() async {
    await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          // Microsoft excel
          'xls',
          'xlsx',
        ]);
  }

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

  void popupCardClear() {
    doctorId.clear();
    name.clear();
    dateOfBirth.clear();
    email.clear();
    role.clear();
    doctorPhone1.clear();
    doctorPhone2.clear();
    doctorPhone3.clear();
    college.clear();
    acadimicDegree.clear();
    adminPosition.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    popupCardClear();
    doctorId.dispose();
    name.dispose();
    dateOfBirth.dispose();
    email.dispose();
    role.dispose();
    doctorPhone1.dispose();
    doctorPhone2.dispose();
    doctorPhone3.dispose();
    college.dispose();
    acadimicDegree.dispose();
    adminPosition.dispose();
    doctorIdFocus.dispose();
    nameFocus.dispose();
    dateOfBirthFocus.dispose();
    emailFocus.dispose();
    roleFocus.dispose();
    phone1Focus.dispose();
    phone2Focus.dispose();
    phone3Focus.dispose();
    collegeFocus.dispose();
    acadimicFocus.dispose();
    administrativeFocus.dispose();
  }
}

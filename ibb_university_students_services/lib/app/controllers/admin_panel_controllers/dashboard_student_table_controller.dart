// ignore: implementation_imports
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import 'package:ibb_university_students_services/app/repositories/level_repository.dart';
import 'package:ibb_university_students_services/app/repositories/section_repository.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/student_table_view/student_table_component/add_student_table_card.dart';

class DashboardStudentTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  GlobalKey<FormState> formKey = GlobalKey();
  ScrollController vertical = ScrollController();
  ScrollController horizontal = ScrollController();
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  int currentPage = 1;
  List<DataColumn> kTableColumn = [];
  RxBool selectAll = false.obs;
  RxSet<int> selectedRows = RxSet({});
  RxMap<int, Student> student = RxMap({});
  List<DropdownMenuItem<int>> sections = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> orderBy = [
    DropdownMenuItem<String>(
        value: "student_id",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Student id",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "student_system",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Student system",
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
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedOrder = "student_id".obs;
  RxString selectedSort = "DESC".obs;
  RxInt availableRows = 0.obs;
  RxString fieldMessage = "".obs;
  RxBool loadingState = true.obs;
  Timer? _debounce;

  //popup student component
  TextEditingController studentId = TextEditingController();
  TextEditingController studentName = TextEditingController();
  TextEditingController studentDOB = TextEditingController();
  TextEditingController studentEmail = TextEditingController();
  TextEditingController studentPhone1 = TextEditingController();
  TextEditingController studentPhone2 = TextEditingController();
  TextEditingController studentPhone3 = TextEditingController();
  TextEditingController studentsystem = TextEditingController();
  TextEditingController studentrole = TextEditingController();
  TextEditingController studentcollege = TextEditingController();
  FocusNode roleFocus = FocusNode();
  FocusNode collegeFocus = FocusNode();
  FocusNode systemFocus = FocusNode();
  FocusNode idFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phone1Focus = FocusNode();
  FocusNode phone2Focus = FocusNode();
  FocusNode phone3Focus = FocusNode();
  Map<int, Section> section = <int, Section>{}.obs;
  // ignore: non_constant_identifier_names
  Rx<int?> SectionId = Rx(null);
  List<Level>? level;
  Rx<int?> levelId = Rx(null);
  RxList<Map<String, int>> groupPhons = RxList();

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
          "Student ID",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Name",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Date Of Birth",
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
          "college Name",
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
          "Level",
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
          "Enrollment Year",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Student System",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Repeat Years",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
    ];
    await initLevelDashboardMenuList();
    await initSectionDashboardMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty) ? selectedSection.value = sections.first.value : null;
    await fetchStudentData();
    loadingState.value = false;
    super.onInit();
  }

  void refrech() async {
    await fetchStudentData();
    super.refresh();
  }

  void onPageChange(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchStudentData();
  }

  void onRowChange(int? val) async {
    if (val != null) {
      rowsPerPage.value = val;
      await fetchStudentData();
      update(["DataTable"]);
    }
  }

  void changeSection(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
    await fetchStudentData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchStudentData();
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchStudentData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchStudentData();
  }

  Future<void> initSectionDashboardMenuList({bool force = false}) async {
    Map<int, Section> sectionsData =
        await SectionRepository.fetchSections(hardFetch: force)
            .then((e) => e.data ?? {});
    sections = [
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
    for (Section section in sectionsData.values.toList()) {
      sections.add(
        DropdownMenuItem<int>(
            value: section.id,
            child: SizedBox(
              width: (Get.width / 6) * 0.5,
              child: CustomText(
                section.name ?? "unknown",
                style:
                    AppTextStyles.mainStyle(textHeader: AppTextHeaders.h6Bold),
              ),
            )),
      );
    }
    selectedSection.value = sectionsData.values.first.id;
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

  Future<void> fetchStudentData({bool showSnakeBars = true}) async {
    if (selectedLevel.value == null) {
      await initLevelDashboardMenuList();
      if (levels.isNotEmpty) {
        selectedLevel.value = levels.first.value;
      }
    }

    if (selectedSection.value == null) {
      await initSectionDashboardMenuList();
      if (sections.isNotEmpty) {
        selectedSection.value = sections.first.value;
      }
    }

    if (selectedLevel.value == null || selectedSection.value == null) {
      return;
    }

    Result res = await UserRepository.fetchDashboardStudent(
      section: (selectedSection.value == 0) ? null : selectedSection.value,
      level: (selectedLevel.value == 0) ? null : selectedLevel.value,
      limit: rowsPerPage.value,
      page: currentPage,
      order: selectedOrder.value,
      sort: selectedSort.value,
      search: searchController.text,
      hardFetch: false,
    );
    if (res.statusCode == 200) {
      student.value = res.data["students"] ?? {};
      availableRows.value = res.data["totalStudent"] ?? 0;
    } else if (res.statusCode == 404) {
      student.value = {};
      availableRows.value = 0;
      fieldMessage.value = "this section and level not has Student";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Lectures",
            message: "this section and level doesn't has Student ");
      }
    } else {
      student.value = {};
      fieldMessage.value = "fetching Student failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Student Failed",
            message: "fetching Student failed please check connection ");
      }
    }
    update(["DataTable"]);
  }

  Future<void> addClick() async {
    await getSection();
    await getLevel();
    Get.dialog(PopUpAddStudentCard());
  }

  Future<void> getSection() async {
    section = await SectionRepository.fetchSections().then((e) => e.data ?? {});
    if (section.isNotEmpty) {
      SectionId = RxInt(section.values.first.id);
    } else {
      SectionId.value = null;
    }
  }

  Future<void> getLevel() async {
    level = await LevelRepository.fetchLevels(hardFetch: false)
        .then((e) => e.data?.values.toList() ?? []);
    if (level?.isNotEmpty ?? false) {
      levelId = Rx(level?.first.id ?? 0);
    } else {
      levelId.value = null;
    }
  }

  void addGroup(
    int phone1,
    int phone2,
    int phone3,
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
      {"phone_number": phone1 & phone2 & phone3},
    );
  }

  Future<void> addStudent() async {
    if (formKey.currentState!.validate()) {
      Result<Student> res = await UserRepository.createStudent(
        studentId: int.parse(studentId.text),
        sectionId: SectionId.value!,
        roleId: int.parse(studentrole.text),
        level: levelId.value!,
        name: studentName.text,
        dateOfBirth: studentDOB.text,
        college: studentcollege.text,
        email: studentEmail.text,
        password: "12345678",
        enrolment: DateTime.now().toString(),
        system: studentsystem.text,
        phonenumber: groupPhons,
      );
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 201 && res.data != null) {
        student[res.data!.id] = res.data!;
        student.refresh();
        showSnakeBar(message: "Add successfully");
      } else {
        showSnakeBar(message: "Add failed");
      }
      update(["DataTable"]);
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
      await fetchStudentData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");

  void popupClear() {
    studentName.clear();
    studentDOB.clear();
    studentEmail.clear();
    studentPhone1.clear();
    studentPhone2.clear();
    studentPhone3.clear();
    studentcollege.clear();
    studentsystem.clear();
    studentrole.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    popupClear();
    studentName.dispose();
    studentDOB.dispose();
    studentEmail.dispose();
    studentPhone1.dispose();
    studentPhone2.dispose();
    studentPhone3.dispose();
    studentcollege.dispose();
    studentsystem.dispose();
    studentrole.dispose();
    idFocus.dispose();
    nameFocus.dispose();
    dateFocus.dispose();
    emailFocus.dispose();
    phone1Focus.dispose();
    phone2Focus.dispose();
    phone3Focus.dispose();
    collegeFocus.dispose();
    systemFocus.dispose();
    roleFocus.dispose();
  }
}

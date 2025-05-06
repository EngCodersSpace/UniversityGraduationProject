import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/repositories/level_repository.dart';
import 'package:ibb_university_students_services/app/repositories/section_repository.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/subject_table_view/subject_table_component/add_subject_table_card.dart';

class DashboardSubjectsTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  GlobalKey<FormState> formKey = GlobalKey();
  ScrollController vertical = ScrollController();
  ScrollController horizontal = ScrollController();
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  int currentPage = 1;
  List<DataColumn> kTableColumn = [];
  RxBool selectedAll = false.obs;
  RxSet<String> selectedRow = RxSet({});
  RxMap<String, Subject> subjects = RxMap({});
  List<DropdownMenuItem<int>> sections = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> orderBy = [
    DropdownMenuItem<String>(
        value: "subject_id",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Subject Id",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "subject_name",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Subject Name",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "number_of_units",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "The Units",
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
  RxString selectedOrder = "subject_id".obs;
  RxString selectedSort = "DESC".obs;
  RxInt availableRows = 0.obs;
  RxBool loadingState = true.obs;
  RxString fieldMessage = "".obs;
  Timer? _debounce;

  //popup add subject
  TextEditingController subjectId = TextEditingController();
  TextEditingController subjectName = TextEditingController();
  TextEditingController subjectUnit = TextEditingController();
  TextEditingController subjectDescription = TextEditingController();
  FocusNode idFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode unitFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  Map<int, Section> addSection = <int, Section>{};
  Rx<int?> sectionId = Rx(null);
  List<Level>? addLevel;
  Rx<int?> levelId = Rx(null);
  Map<int, Doctor> doctors = <int, Doctor>{};
  Rx<int?> doctorId = Rx(null);

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
        "Subject ID",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Name",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Number Of Unit",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Description",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
    ];
    await initLevelDashboardMenuList();
    await initSectionDashboardMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty) ? selectedSection.value = sections.first.value : null;
    await fetchSubjectData();
    loadingState.value = false;
    super.onInit();
  }

  @override
  void refresh() {
    super.refresh();
  }

  void onPageChang(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchSubjectData();
  }

  void onRowChange(int? val) async {
    if (val != null) {
      rowsPerPage.value = val;
      await fetchSubjectData();
      update(["DataTable"]);
    }
  }

  Future<void> fetchSubjectData({bool showSnakeBars = true}) async {
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

    Result res = await SubjectRepository.fetchDashboardSubject(
      sectionid: (selectedSection.value == 0) ? null : selectedSection.value,
      levelid: (selectedLevel.value == 0) ? null : selectedLevel.value,
      limit: rowsPerPage.value,
      page: currentPage,
      order: selectedOrder.value,
      sort: selectedSort.value,
      search: searchController.text,
    );
    if (res.statusCode == 200) {
      subjects.value = res.data["subject"] ?? {};
      availableRows.value = res.data["totalSubject"] ?? 0;
    } else if (res.statusCode == 404) {
      subjects.value = {};
      availableRows.value = 0;
      fieldMessage.value = "this section and level not has Subjects";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Subjects",
            message: "this section and level doesn't has Subjects ");
      }
    } else {
      subjects.value = {};
      fieldMessage.value = "fetching Subjects failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Subjects Failed",
            message: "fetching Subjects failed please check connection ");
      }
    }
    update(["DataTable"]);
  }

  void changeSection(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
    await fetchSubjectData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchSubjectData();
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchSubjectData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchSubjectData();
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

  void addClick() async {
    await getLevel();
    await getSection();
    // await getDoctor();
    Get.dialog(PopUpAddSubjectCard());
  }

  Future<void> getSection() async {
    addSection =
        await SectionRepository.fetchSections().then((e) => e.data ?? {});
    if (addSection.isNotEmpty) {
      sectionId = Rx(addSection.values.first.id);
    } else {
      sectionId.value = null;
    }
  }

  Future<void> getLevel() async {
    addLevel = await LevelRepository.fetchLevels().then((e) => e.data?.values.toList() ?? []);
    if (addLevel?.isNotEmpty ?? false) {
      levelId = Rx(addLevel?.first.id ?? 0);
    } else {
      levelId.value = null;
    }
  }

  // Future<void> getDoctor() async {
  //   doctors =
  // await UserRepository.fetchDashboardDoctors().then((e) => e.data);
  //   if (doctors.isNotEmpty) {
  //     doctorId = Rx(doctors.values.first.id);
  //   } else {
  //     doctorId.value = null;
  //   }
  // }

  Future<void> addSubject() async {}

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
      await fetchSubjectData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");

  void popupClear() {
    subjectId.clear();
    subjectName.clear();
    subjectUnit.clear();
    subjectDescription.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    popupClear();
    subjectId.dispose();
    subjectName.dispose();
    subjectUnit.dispose();
    subjectDescription.dispose();
    idFocus.dispose();
    nameFocus.dispose();
    unitFocus.dispose();
    descriptionFocus.dispose();
  }
}

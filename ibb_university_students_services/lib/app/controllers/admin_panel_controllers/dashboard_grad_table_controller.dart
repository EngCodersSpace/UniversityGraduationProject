import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/grads_model/grads_model.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/repositories/grad_repository.dart';
import 'package:ibb_university_students_services/app/repositories/level_repository.dart';
import 'package:ibb_university_students_services/app/repositories/section_repository.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';

class DashboardGradTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool loadingState = true.obs;
  RxMap<int, Grad> grads = RxMap({});
  RxInt availableRows = 0.obs;
  RxString fieldMessage = "".obs;
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedTerm = "".obs;
  RxString selectedOrder = "subject_id".obs;
  RxString selectedSort = "DESC".obs;
  Timer? _debounce;
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  int currentPage = 1;
  List<DataColumn> kTableColumn = [];
  RxBool selectAll = false.obs;
  RxSet<int> selectedRows = RxSet({});
  ScrollController horizontal = ScrollController();
  ScrollController vertical = ScrollController();
  List<DropdownMenuItem<int>> sections = [];
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
        value: "student_id",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Student",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "subject_id",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Subject",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    // DropdownMenuItem<String>(
    //     value: "lecture_room",
    //     child: SizedBox(
    //         width: (Get.width / 8) * 0.6,
    //         child: CustomText(
    //           "Lecture Room",
    //           style: AppTextStyles.mainStyle(
    //             textHeader: AppTextHeaders.h6Bold,
    //           ),
    //         ))),
    // DropdownMenuItem<String>(
    //     value: "subject_id",
    //     child: SizedBox(
    //         width: (Get.width / 8) * 0.6,
    //         child: CustomText(
    //           "Subject",
    //           style: AppTextStyles.mainStyle(
    //             textHeader: AppTextHeaders.h6Bold,
    //           ),
    //         ))),
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

  //popup component
  Map<String, Subject>? subjects;
  Rx<String?> subjectId = Rx(null);
  Map<int, Section> section = <int, Section>{}.obs;
  // ignore: non_constant_identifier_names
  Rx<int?> SectionId = Rx(null);
  List<Level>? level;
  // ignore: non_constant_identifier_names
  Rx<int?> LevelId = Rx(null);

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
          "Grad ID",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Student Id",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Subject Name",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Exam Grad",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Work Grad",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Term",
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
          "Year issue",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Pass ",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
    ];
    await initLevelDashboardMenuList();
    await initSectionDashboardMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty) ? selectedSection.value = sections.first.value : null;
    await fetchGradData();
    loadingState.value = false;
    super.onInit();
  }

  @override
  void refresh() async {
    await fetchGradData();
  }

  Future<void> fetchGradData({bool showSnakeBars = true}) async {
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

    Result res = await GradRepository.fetchDashboardGrad(
      sectionId: (selectedSection.value == 0) ? null : selectedSection.value,
      levelId: (selectedLevel.value == 0) ? null : selectedLevel.value,
      term: (selectedTerm.value == "") ? "" : selectedTerm.value,
      order: selectedOrder.value,
      sort: selectedSort.value,
      limit: rowsPerPage.value,
      page: currentPage,
      search: searchController.text,
      hardfetch: false,
    );
    if (res.statusCode == 200) {
      grads.value = res.data["grads"] ?? {};
      availableRows.value = res.data["totalGrads"] ?? 0;
    } else if (res.statusCode == 404) {
      grads.value = {};
      availableRows.value = 0;
      fieldMessage.value = "this section and level not has Grads";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Grads",
            message: "this section and level doesn't has Grads ");
      }
    } else {
      grads.value = {};
      fieldMessage.value = "fetching Grads failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Grads Failed",
            message: "fetching grad failed please check connection ");
      }
    }
    update(["DataTable"]);
  }

  void onRowChange(int? value) async {
    if (value != null) {
      rowsPerPage.value = value;
      await fetchGradData();
      update(["DataTable"]);
    }
  }

  void onPageChange(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchGradData();
  }

  void changeSection(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
    await fetchGradData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchGradData();
  }

  void changeTerm(String? val) async {
    if (val == null) return;
    selectedTerm.value = val;
    fetchGradData();
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchGradData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchGradData();
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
        .then((e) => e.data ?? []);
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

  Future<void> addClick() async {}

  Future<void> getSubjects() async {
    subjects = {};
    subjects =
        await SubjectRepository.fetchSubjects().then((e) => e.data ?? {});
    if ((subjects?.isNotEmpty ?? false) && subjects?.values.first != null) {
      subjectId = RxString(subjects!.values.first.id);
    } else {
      subjectId.value = null;
    }
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
        .then((e) => e.data ?? []);
    if (level?.isNotEmpty ?? false) {
      LevelId = RxInt(level?.first.id ?? 0);
    } else {
      LevelId.value = null;
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
      await fetchGradData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void onClose() {}
}

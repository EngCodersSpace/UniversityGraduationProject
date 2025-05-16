import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/assignment_model/assignment_model.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/repositories/assignments_repository.dart';
import 'package:ibb_university_students_services/app/repositories/level_repository.dart';
import 'package:ibb_university_students_services/app/repositories/section_repository.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/assignment_table_view/assignment_table_component/add_assignment_table_card.dart';

class DashboardAssignmentTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  RxMap<int, Assignment> assignment = RxMap({});
  RxSet<int> selectedRows = RxSet({});
  RxInt availableRows = 0.obs;
  int currentPage = 1;
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  RxString fieldMessage = "".obs;
  ScrollController horizontal = ScrollController();
  ScrollController vertical = ScrollController();
  RxBool selectAll = false.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool loadingstate = true.obs;
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedTerm = "".obs;
  RxString selectedOrder = "id".obs;
  RxString selectedSort = "DESC".obs;
  RxString selectedDay = "".obs;
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
        value: "subject_id",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Subject",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "doctor_id",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "doctor",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "assignment_date",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Assignment date",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "assignments_due_date",
        child: SizedBox(
            width: (Get.width / 6) * 0.6,
            child: CustomText(
              "Assignment due date",
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
  List<DropdownMenuItem<String>> day = [
    DropdownMenuItem<String>(
        value: "",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "All",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Saturday",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Saturday",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Sunday",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Sunday",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Monday",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Monday",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Tuesday",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Tuesday",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "wednesday",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Wednesday",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Thursday",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Thursday",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            )))
  ];
  List<DataColumn> kTableColumn = [];
  Timer? _debounce;

  //popup add component
  Map<String, Subject>? subjects;
  Rx<String?> subjectId = Rx(null);
  Map<int, Section> section = <int, Section>{}.obs;
  // ignore: non_constant_identifier_names
  Rx<int?> SectionId = Rx(null);
  List<Level>? level;
  // ignore: non_constant_identifier_names
  Rx<int?> LevelId = Rx(null);
  TextEditingController title = TextEditingController();
  TextEditingController dueDate = TextEditingController();
  FocusNode titleFocus = FocusNode();
  FocusNode dueDateFocus = FocusNode();

  @override
  void onInit() async {
    searchController.addListener(() => onSearch());
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
          "Assignment ID",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        numeric: true,
      ),
      DataColumn(
          label: CustomText(
        "Subject ID",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Doctor",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Section ID",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Level",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Title",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Day",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Date",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Due Date",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
    ];
    await initLevelDashboardMenuList();
    await initSectionDashboardMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty) ? selectedSection.value = sections.first.value : null;
    await fetchAssignmentData();
    loadingstate.value = false;
    super.onInit();
  }

  @override
  void refresh() async {
    await fetchAssignmentData();
    super.refresh();
  }

  Future<void> fetchAssignmentData({bool showSnakeBars = true}) async {
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

    Result res = await AssignmentsRepository.fetchDashboardAssignment(
      section: (selectedSection.value == 0) ? null : selectedSection.value,
      level: (selectedLevel.value == 0) ? null : selectedLevel.value,
      term: (selectedTerm.value == "") ? "" : selectedTerm.value,
      day: (selectedDay.value == "") ? "" : selectedDay.value,
      order: selectedOrder.value,
      sort: selectedSort.value,
      limit: rowsPerPage.value,
      page: currentPage,
      search: searchController.text,
      hardFetch: false,
    );
    if (res.statusCode == 200) {
      assignment.value = res.data["assignment"] ?? {};
      availableRows.value = res.data["totalassignment"] ?? 0;
    } else if (res.statusCode == 401) {
      assignment.value = {};
      availableRows.value = 0;
      fieldMessage.value = "this section and level not has Assignment";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Assignment",
            message: "this section and level doesn't has Assignment ");
      }
    } else {
      assignment.value = {};
      fieldMessage.value = "fetching assignment failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Assignment Failed",
            message: "fetching assignment failed please check connection ");
      }
    }
    update(["DataTable"]);
  }

  void onPageChange(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchAssignmentData();
  }

  void onRowChange(int? value) async {
    if (value != null) {
      rowsPerPage.value = value;
      await fetchAssignmentData();
      update(["DataTable"]);
    }
  }

  void changeSection(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
    await fetchAssignmentData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchAssignmentData();
  }

  void changeTerm(String? val) async {
    if (val == null) return;
    selectedTerm.value = val;
    fetchAssignmentData();
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchAssignmentData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchAssignmentData();
  }

  void changeDay(String? val) async {
    if (val == null) return;
    selectedDay.value = val;
    fetchAssignmentData();
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

  Future<void> addClick() async {
    await getSection();
    await getSubjects();
    await getLevel();
    Get.dialog(AddAssignmentTableCard());
  }

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
        .then((e) => e.data?.values.toList() ?? []);
    if (level?.isNotEmpty ?? false) {
      LevelId = RxInt(level?.first.id ?? 0);
    } else {
      LevelId.value = null;
    }
  }

  Future<void> addAssignment() async {}

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
      await fetchAssignmentData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");
}

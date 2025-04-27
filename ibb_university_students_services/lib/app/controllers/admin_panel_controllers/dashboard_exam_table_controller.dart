import "dart:async";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ibb_university_students_services/app/components/custom_text_v2.dart";
import "package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart";
import "package:ibb_university_students_services/app/models/exam_model/exam_model.dart";
import "package:ibb_university_students_services/app/models/helper_models/result.dart";
import "package:ibb_university_students_services/app/models/level_model/level.dart";
import "package:ibb_university_students_services/app/models/section_model/section.dart";
import "package:ibb_university_students_services/app/models/subject_model/subject_model.dart";
import "package:ibb_university_students_services/app/repositories/exam_repository.dart";
import "package:ibb_university_students_services/app/repositories/level_repository.dart";
import "package:ibb_university_students_services/app/repositories/section_repository.dart";
import "package:ibb_university_students_services/app/repositories/subject_repository.dart";
import "package:ibb_university_students_services/app/styles/text_styles.dart";
import "package:ibb_university_students_services/app/utils/date_time_utils.dart";
import "package:ibb_university_students_services/app/utils/snake_bar.dart";
import "package:ibb_university_students_services/app/views/admin_panel/exam_table_view/exam_table_component/add_exam_table_card.dart";

class DashboardExamTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxMap<int, Exam> exams = RxMap({});
  RxInt availableRows = 0.obs;
  RxString fieldMessage = "".obs;
  RxBool loadingState = true.obs;
  Timer? _debounce;
  int currentPage = 1;
  RxString selectedOrder = "exam_date".obs;
  RxString selectedSort = "DESC".obs;
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  ScrollController vertical = ScrollController();
  ScrollController horizontal = ScrollController();
  List<DataColumn> kTableColumn = [];
  RxBool selectedAll = false.obs;
  RxSet selectedRow = RxSet({});
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedTerm = "".obs;
  List<DropdownMenuItem<int>> sections = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> terms = [
    DropdownMenuItem<String>(
        value: "",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "All",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Term 1",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "1st",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Term 2",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "2ec",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
  ];
  List<DropdownMenuItem<String>> orderBy = [
    DropdownMenuItem<String>(
        value: "exam_date",
        child: SizedBox(
            width: (Get.width / 4) * 0.3,
            child: CustomText(
              "Exam date",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "exam_day",
        child: SizedBox(
            width: (Get.width / 4) * 0.3,
            child: CustomText(
              "Exam day",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "subject_id",
        child: SizedBox(
            width: (Get.width / 3) * 0.2,
            child: CustomText(
              "Subject",
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

  //popup card component
  Map<String, Subject>? subjects;
  Rx<String?> subjectId = Rx(null);
  Map<int, Section> section = <int, Section>{}.obs;
  // ignore: non_constant_identifier_names
  Rx<int?> SectionId = Rx(null);
  List<Level>? level;
  // ignore: non_constant_identifier_names
  Rx<int?> LevelId = Rx(null);
  // ignore: non_constant_identifier_names
  RxString TermId = "".obs;
  RxString selectedDayName = "Sunday".obs;
  TextEditingController dateController = TextEditingController();
  FocusNode dateFocus = FocusNode();
  TextEditingController timeController = TextEditingController();
  FocusNode timeFocus = FocusNode();
  TextEditingController hallController = TextEditingController();
  FocusNode hallFocus = FocusNode();
  FocusNode entryYearFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  List<DropdownMenuItem<String>> term = [
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
  List<DropdownMenuItem<String>> days = [
    DropdownMenuItem<String>(
        value: "Saturday",
        child: SizedBox(
            width: (Get.width / 3) * 0.6,
            child: CustomText(
              "Saturday",
              style: AppTextStyles.secStyle(
                textHeader: AppTextHeaders.h3Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Sunday",
        child: SizedBox(
            width: (Get.width / 3) * 0.6,
            child: CustomText(
              "Sunday",
              style: AppTextStyles.secStyle(
                textHeader: AppTextHeaders.h3Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Monday",
        child: SizedBox(
            width: (Get.width / 3) * 0.6,
            child: CustomText(
              "Monday",
              style: AppTextStyles.secStyle(
                textHeader: AppTextHeaders.h3Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Tuseday",
        child: SizedBox(
            width: (Get.width / 3) * 0.6,
            child: CustomText(
              "Tuseday",
              style: AppTextStyles.secStyle(
                textHeader: AppTextHeaders.h3Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Wednesday",
        child: SizedBox(
            width: (Get.width / 3) * 0.6,
            child: CustomText(
              "Wednesday",
              style: AppTextStyles.secStyle(
                textHeader: AppTextHeaders.h3Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Thursday",
        child: SizedBox(
            width: (Get.width / 3) * 0.6,
            child: CustomText(
              "Thursday",
              style: AppTextStyles.secStyle(
                textHeader: AppTextHeaders.h3Bold,
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
    await initSectionDashboardMenuList();
    await initLevelDashboardMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty) ? selectedSection.value = sections.first.value : null;
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

  void onPageChange(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchExamsData();
  }

  Future<void> fetchExamsData({bool showSnakeBars = true}) async {
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

    if (selectedSection.value == null || selectedLevel.value == null) {
      return;
    }

    Result res = await ExamRepository.fetchDashboardExam(
        sectionId: (selectedSection.value == 0) ? null : selectedSection.value,
        levelId: (selectedLevel.value == 0) ? null : selectedLevel.value,
        term: (selectedTerm.value == "") ? "" : selectedTerm.value,
        order: selectedOrder.value,
        limit: rowsPerPage.value,
        sort: selectedSort.value,
        page: currentPage,
        search: searchController.text,
        hardFetch: false);
    if (res.statusCode == 200) {
      exams.value = res.data["exams"] ?? {};
      availableRows.value = res.data["totalExams"];
    } else if (res.statusCode == 404) {
      exams.value = {};
      availableRows.value = 0;
      update(["DataTable"]);
      fieldMessage.value = "this section and level not has Exams";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Exams",
            message: "this section and level doesn't has Exams ");
      }
    } else {
      exams.value = {};
      fieldMessage.value = "fetching Exams failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Exams Failed",
            message: "fetching exams failed please check connection ");
      }
    }
    update(["DataTable"]);
  }

  void changeSection(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
    await fetchExamsData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchExamsData();
  }

  void changeTerm(String? val) async {
    if (val == null) return;
    selectedTerm.value = val;
    fetchExamsData();
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

  Future<void> addClick() async {
    await getSection();
    await getLevel();
    await getSubjects();
    timeController.text = DateTimeUtils.formatTimeOfDay(
      time: TimeOfDay.now(),
    );
    Get.dialog(AddExamTableCard());
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
        .then((e) => e.data ?? []);
    if (level?.isNotEmpty ?? false) {
      LevelId = RxInt(level?.first.id ?? 0);
    } else {
      LevelId.value = null;
    }
  }

  void changeAddDay(String? val) async {
    if (val == null) return;
    selectedDayName.value = val;
  }

  void changeAddTerm(String? val) async {
    if (val == null) return;
    TermId.value = val;
  }

  Future<void> addExam() async {
    //the parameters that must be defined in exam repository
    Result res = await ExamRepository.createExam(
      sectionId: SectionId.value!,
      levelId: LevelId.value!,
      data: dateController.text,
      term: TermId.value,
      day: selectedDayName.value,
      subjectId: subjectId.value!,
      examTime: timeController.text,
      examRoom: hallController.text,
    );

    // ignore: unused_local_variable
    Exam? createExam;
    Navigator.of(Get.overlayContext!).pop();
    if (res.statusCode == 201 && res.data != null) {
      createExam = res.data;
      showSnakeBar(message: "Add successfully");
    } else {
      showSnakeBar(message: "Add failed");
    }
    update(["DataTable"]);
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
      await fetchExamsData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void onClose() {}
}

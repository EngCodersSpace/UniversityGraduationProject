import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/lecture_table_view/lecture_table_component/add_and_update_lecture_table_card.dart';
import '../../components/custom_text_v2.dart';
import '../../models/helper_models/result.dart';
import '../../models/lecture_model/lecture_model.dart';
import '../../models/level_model/level.dart';
import '../../models/section_model/section.dart';
import '../../repositories/lecture_repository.dart';
import '../../repositories/level_repository.dart';
import '../../repositories/section_repository.dart';
import '../../styles/text_styles.dart';
import '../../utils/snake_bar.dart';
import 'header_of_view_controller_interface.dart';

class DashboardLectureTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));

  double get height => Get.height;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxMap<int, Lecture> lectures = RxMap({});
  RxSet<int> selectedRows = RxSet({});
  RxInt availableRows = 0.obs;
  int currentPage = 1;
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  RxString fieldMessage = "".obs;
  RxBool loadingState = true.obs;
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  RxString selectedOrder = "lecture_time".obs;
  RxString selectedSort = "DESC".obs;
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
        value: "lecture_time",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Lecture Time",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "lecture_day",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Lecture Day",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "lecture_room",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Lecture Room",
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
  List<DataColumn> kTableColumn = [];
  ScrollController horizontal = ScrollController();
  ScrollController vertical = ScrollController();
  RxBool selectAll = false.obs;
  Timer? _debounce;

  //Lecture popCard variables
  Map<String, Subject>? subjects;
  Map<int, Section> section = <int, Section>{}.obs;
  List<Level>? level;
  RxString selectedDayName = "Sunday".obs;
  Rx<String?> subjectId = Rx(null);
  Rx<int?> doctorId = Rx(null);
  Rx<int?> SectionId = Rx(null);
  Rx<int?> LevelId = Rx(null);
  RxString TermId = "Term 1".obs;
  TextEditingController timeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController hallController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode timeFocus = FocusNode();
  FocusNode durationFocus = FocusNode();
  FocusNode entryYearFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  int? selectedLecture;
  bool submitting = false;
  List<DropdownMenuItem<String>> terms = [
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
          "Lecture ID",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        numeric: true,
      ),
      DataColumn(
          label: CustomText(
        "Subject",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
        label: CustomText(
          "Doctor ID",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Duration",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        // numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Start Time",
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
      DataColumn(
        label: CustomText(
          "Decsription",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
    ];
    await initSectionDashboardMenuList();
    await initLevelDashboardMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty) ? selectedSection.value = sections.first.value : null;
    await fetchDashboardData();
    loadingState.value = false;
    super.onInit();
    // filteredlectures.assignAll(lectures);
  }

  @override
  void refresh() async {
    await fetchDashboardData();
  }

  void onRowChange(int? value) async {
    if (value != null) {
      rowsPerPage.value = value;
      await fetchDashboardData();
      update(["DataTable"]);
    }
  }

  Future<void> fetchDashboardData({bool showSnakeBars = true}) async {
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

    Result res = await LectureRepository.fetchDashboardLecture(
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
      lectures.value = res.data["lectures"] ?? {};
      availableRows.value = res.data["totalLectures"];
      update(["DataTable"]);
    } else if (res.statusCode == 404) {
      lectures.value = {};
      fieldMessage.value = "this section and level not has Lectures";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Lectures",
            message: "this section and level doesn't has Lectures ");
      }
    } else {
      lectures.value = {};
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
    await fetchDashboardData();
  }

  void changeSection(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
    await fetchDashboardData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchDashboardData();
  }

  void changeTerm(String? val) async {
    if (val == null) return;
    selectedTerm.value = val;
    fetchDashboardData();
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchDashboardData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchDashboardData();
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

  @override
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void export() {}

  @override
  void import() {}

  String prevTxt = "";

  get jsdata => null;

  @override
  void onSearch() {
    if (searchController.text == prevTxt) return;
    prevTxt = searchController.text;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 600), () async {
      await fetchDashboardData();
    });
  }

  Future<void> addClick() async {
    await getSection();
    await getLevel();
    await getSubjects();
    timeController.text = DateTimeUtils.formatTimeOfDay(time: TimeOfDay.now());
    Get.dialog(const PopUpAddAndUpdateLectureCard());
  }

  void changeAddTerm(String? val) async {
    if (val == null) return;
    TermId.value = val;
  }

  Future<void> getSubjects() async {
    subjects = {};
    subjects =
        await SubjectRepository.fetchSubjects().then((e) => e.data ?? {});
    if ((subjects?.isNotEmpty ?? false) && subjects?.values.first != null) {
      subjectId = RxString(subjects!.values.first.id);
      if ((subjects?.values.first.instructors?.isNotEmpty ?? false) &&
          subjects?.values.first.instructors?.values.first != null) {
        doctorId.value = subjects?.values.first.instructors?.values.first.id;
      } else {
        doctorId.value = null;
      }
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

  Future<void> addlecture() async {
    Result<Lecture> res = await LectureRepository.createLecture(
      sectionId: SectionId.value!,
      levelId: LevelId.value!,
      term: TermId.value,
      year: "",
      day: selectedDayName.value,
      subjectId: subjectId.value!,
      doctorId: doctorId.value!,
      lectureTime: timeController.text,
      lectureDuration: int.tryParse(durationController.text) ?? -999,
      lectureRoom: hallController.text,
    );

    // ignore: unused_local_variable
    Lecture? createLecture;
    Navigator.of(Get.overlayContext!).pop();
    if (res.statusCode == 201 && res.data != null) {
      createLecture = res.data;
      showSnakeBar(message: "Add successfully");
    } else {
      showSnakeBar(message: "Add failed");
    }
    update(["DataTable"]);
  }

  void popCardClear() {
    timeController.clear();
    durationController.clear();
    hallController.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    popCardClear();
    timeController.dispose();
    durationController.dispose();
    hallController.dispose();
    nameFocus.dispose();
    timeFocus.dispose();
    durationFocus.dispose();
    entryYearFocus.dispose();
    phoneFocus.dispose();
  }
}

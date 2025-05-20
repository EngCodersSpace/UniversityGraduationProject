import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/lecture_table_view/lecture_table_component/add_lecture_table_card.dart';
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
  RxString selectedTerm = "".obs;
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
  // ignore: non_constant_identifier_names
  Rx<int?> SectionId = Rx(null);
  // ignore: non_constant_identifier_names
  Rx<int?> LevelId = Rx(null);
  // ignore: non_constant_identifier_names
  RxString TermId = "".obs;
  TextEditingController timeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController hallController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode timeFocus = FocusNode();
  FocusNode durationFocus = FocusNode();
  FocusNode entryYearFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  int? selectedLecture;
  String mode = "Edit";
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
        value: "Tuesday",
        child: SizedBox(
            width: (Get.width / 3) * 0.6,
            child: CustomText(
              "Tuesday".tr,
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
          "Description",
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
      availableRows.value = res.data["totalLectures"] ?? 0;
    } else if (res.statusCode == 404) {
      lectures.value = {};
      availableRows.value = 0;
      fieldMessage.value = "this section and level not has Lectures";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Lectures",
            message: "this section and level doesn't has Lectures ");
      }
    } else {
      lectures.value = {};
      availableRows.value = res.data["totalLectures"] ?? 0;
      fieldMessage.value = "fetching lectures failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Lectures Failed",
            message: "fetching lectures failed please check connection ");
      }
    }
    update(["DataTable"]);
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

  @override
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void export() {}

  @override
  void import() {}

  String prevTxt = "";

  get jsData => null;

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
    Get.dialog(const PopUpAddLectureCard());
  }

  void changeAddTerm(String? val) async {
    if (val == null) return;
    TermId.value = val;
  }

  void changeAddDay(String? val) async {
    if (val == null) return;
    selectedDayName.value = val;
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
        .then((e) => e.data?.values.toList() ?? []);
    if (level?.isNotEmpty ?? false) {
      LevelId = RxInt(level?.first.id ?? 0);
    } else {
      LevelId.value = null;
    }
  }

  Future<void> addLecture() async {
    Result<Lecture> res = await LectureRepository.createLecture(
      sectionId: SectionId.value!,
      levelId: LevelId.value!,
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
      showSnakeBar(title: "Add Successfully",message: "Lecture added successfully");
    } else {
      showSnakeBar(title: "Add Failed",message: "Lecture added successfully");
    }
    update(["DataTable"]);
  }

  // Future<void> more(String val, {Map<String, dynamic>? data}) async {
  //   if (val == "Edit") {
  //     await getSubjects();
  //     mode = "Edit";
  //     if (data != null) {
  //       selectedLecture = data["id"];
  //       doctorId.value = data["doctor_id"];
  //       subjectId.value = data["subject"]["subject_id"];
  //       timeController.text =
  //           DateTimeUtils.formatStringTime(time: data["lecture_time"]);
  //       durationController.text = data["duration"].toString();
  //       hallController.text = data["lecture_room"].toString();
  //     }
  //     Get.dialog(const PopUpAddLectureCard());
  //   } else if (val == "Delete") {
  //     if (selectedLevel.value == null) return;
  //     if (selectedSection.value == null) return;

  //     selectedLecture = data?["id"];
  //     Result<void> res =
  //         await LectureRepository.deleteLecture(id: selectedLecture);
  //     Navigator.of(Get.overlayContext!).pop();
  //     if (res.statusCode == 200) {
  //       lectures.remove(selectedLecture);
  //       showSnakeBar(message: "Delete successfully");
  //     } else {
  //       showSnakeBar(message: "Delete failed");
  //     }
  //   } else if (val == "TemporaryReplace") {
  //     await getSubjects();
  //     mode = "Replace";
  //     if (data != null) {
  //       selectedLecture = data["id"];
  //       doctorId.value = data["doctor_id"];
  //       subjectId.value = data["subject"]["subject_id"];
  //       timeController.text =
  //           DateTimeUtils.formatStringTime(time: data["lecture_time"]);
  //       durationController.text = data["duration"].toString();
  //       hallController.text = data["lecture_room"].toString();
  //     }
  //     Get.dialog(const PopUpAddLectureCard());
  //   } else if (val == "Confirm") {
  //     selectedLecture = data?["id"];
  //     if (selectedLecture == null) return;
  //     Result<void> res = await LectureRepository.changeLectureState(
  //         id: selectedLecture!, action: 'confirm');
  //     Navigator.of(Get.overlayContext!).pop();
  //     if (res.statusCode == 200) {
  //       lectures[selectedLecture]?.lectureStatus == true;
  //       showSnakeBar(message: "Confirm successfully");
  //     } else {
  //       showSnakeBar(message: "Confirm failed");
  //     }
  //   } else if (val == "Cancel") {
  //     selectedLecture = data?["id"];
  //     if (selectedLecture == null) return;
  //     Result<void> res = await LectureRepository.changeLectureState(
  //         id: selectedLecture!, action: 'cancel');
  //     Navigator.of(Get.overlayContext!).pop();
  //     if (res.statusCode == 200) {
  //       lectures[selectedLecture]?.lectureStatus = false;
  //       showSnakeBar(message: "Cancel successfully");
  //     } else {
  //       showSnakeBar(message: "Cancel failed");
  //     }
  //   }
  // }

  // void onSelectedOperation() {
  //   if ((PermissionUtils.checkPermission(
  //       target: "Lectures", action: "write"))) {
  //     [
  //       SizedBox(
  //           height: 24,
  //           width: 24,
  //           child: PopupMenuButton<String>(
  //             onSelected: (val) => more(val, data: lectures.toJson()),
  //             color: AppColors.inverseCardColor,
  //             itemBuilder: (ctx) => [
  //               PopupMenuItem(
  //                   value: "TemporaryReplace",
  //                   child: CustomText(
  //                     "Temporary Replace".tr,
  //                     style: AppTextStyles.mainStyle(
  //                         textHeader: AppTextHeaders.h3Bold),
  //                   )),
  //               PopupMenuItem(
  //                   value: "Edit",
  //                   child: CustomText(
  //                     "Edit".tr,
  //                     style: AppTextStyles.mainStyle(
  //                         textHeader: AppTextHeaders.h3Bold),
  //                   )),
  //               PopupMenuItem(
  //                   value: "Delete",
  //                   child: CustomText(
  //                     "Delete".tr,
  //                     style: AppTextStyles.mainStyle(
  //                         textHeader: AppTextHeaders.h3Bold),
  //                   )),
  //               PopupMenuItem(
  //                   value: "Confirm",
  //                   child: CustomText(
  //                     "Confirm".tr,
  //                     style: AppTextStyles.mainStyle(
  //                         textHeader: AppTextHeaders.h3Bold),
  //                   )),
  //               PopupMenuItem(
  //                   value: "Cancel",
  //                   child: CustomText(
  //                     "Cancel".tr,
  //                     style: AppTextStyles.mainStyle(
  //                         textHeader: AppTextHeaders.h3Bold),
  //                   )),
  //             ],
  //           ))
  //     ];
  //   }
  // }

  // void submit() async {
  //   if (submitting) return;
  //   submitting = true;
  //   if (formKey.currentState!.validate()) {
  //     switch (mode) {
  //       case ("Edit"):
  //         submitEdit();
  //         break;
  //       case ("Replace"):
  //         submitReplace();
  //         break;
  //     }
  //   }
  //   submitting = false;
  //   popCardClear();
  // }

  // void submitEdit() async {}
  // void submitReplace() async {}

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

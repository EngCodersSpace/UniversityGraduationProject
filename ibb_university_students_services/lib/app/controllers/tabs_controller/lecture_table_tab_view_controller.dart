import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/models/level_model.dart';
import 'package:ibb_university_students_services/app/models/lecture_model.dart';
import 'package:ibb_university_students_services/app/models/section_model.dart';
import 'package:ibb_university_students_services/app/services/level_services.dart';
import 'package:ibb_university_students_services/app/services/section_services.dart';
import 'package:ibb_university_students_services/app/services/lecture_services.dart';
import '../../components/custom_text.dart';
import '../../models/days_table.dart';
import '../../models/result.dart';
import '../../models/subject_model.dart';
import '../../services/subject_services.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/screen_utils.dart';
import '../../utils/snake_bar.dart';
import '../../views/lecture_table_tab_view/lecture_table_tab_components/add_and_update_lecture_card.dart';

class LectureController extends GetxController {
  //Lecture main view variables
  RxBool loadState = true.obs;
  TableDays? tableTime;
  RxInt selected = 3.obs;
  String selectedDayName = "Sunday".tr;
  Rx<int?> selectedDepartment = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  Rx<String?> selectedYear = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  RxString fieldMessage = "".obs;
  List<DropdownMenuItem<int>> departments = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> years = [];
  List<DropdownMenuItem<String>> terms = [
    DropdownMenuItem<String>(
        value: "Term 1",
        child: SizedBox(
            width: (ScreenUtils.isPhoneScreen())
                ? (Get.width / 3.3) * 0.75
                : (Get.width / 6) * 0.6,
            child: SecText(
              "Term 1",
              textColor: AppColors.mainTextColor,
              fontSize: 12,
            ))),
    DropdownMenuItem<String>(
        value: "Term 2",
        child: SizedBox(
            width: (ScreenUtils.isPhoneScreen())
                ? (Get.width / 3.3) * 0.75
                : (Get.width / 6) * 0.6,
            child: SecText(
              "Term 2",
              textColor: AppColors.mainTextColor,
              fontSize: 12,
            ))),
  ];

  //Lecture popCard variables
  Map<String, Subject>? subjects;
  Rx<String?> subjectId = Rx(null);
  Rx<int?> doctorId = Rx(null);
  TextEditingController timeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController hallController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode nameFocus = FocusNode();
  FocusNode timeFocus = FocusNode();
  FocusNode durationFocus = FocusNode();
  FocusNode entryYearFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  String mode = "Add";
  int? selectedLecture;
  bool adding = false;

  @override
  void onInit() async {
    await initSectionDropdownMenuList();
    await initLevelDropdownMenuList();
    await initYearDropdownMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (departments.isNotEmpty)
        ? selectedDepartment.value = departments.first.value
        : null;
    (years.isNotEmpty) ? selectedYear.value = years.first.value! : null;
    await fetchTableData();
    loadState.value = false;
    super.onInit();
  }

  @override
  void refresh() async {
    await fetchTableData(force: true);
    loadState.value = false;
    super.refresh();
  }

  Future<void> fetchTableData({bool force = false}) async {
    if (selectedLevel.value == null) {
      await initLevelDropdownMenuList();
    }

    if (selectedDepartment.value == null) {
      await initSectionDropdownMenuList();
    }

    if (selectedYear.value == null) {
      await initYearDropdownMenuList();
    }

    if (selectedDepartment.value == null ||
        selectedLevel.value == null ||
        selectedYear.value == null) {
      return;
    }
    Result res = await LectureServices.fetchTableTime(
        sectionId: selectedDepartment.value!,
        levelId: selectedLevel.value!,
        year: selectedYear.value ?? "2024",
        term: selectedTerm.value,
        hardFetch: force);
    if (res.statusCode == 200) {
      tableTime = res.data;
      selected.refresh();
    } else if (res.statusCode == 404) {
      tableTime = null;
      fieldMessage.value = "this section and level not has Lectures";
      showSnakeBar(
          title: "Not Found Lectures",
          message: "this section and level doesn't has Lectures ");
    } else {
      fieldMessage.value = "fetching lectures failed please check connection";
      showSnakeBar(
          title: "Fetch Lectures Failed",
          message: "fetching lectures failed please check connection ");
    }
  }

  void changeDepartment(int? val) async {
    if (val == null) return;
    selectedDepartment.value = val;
    await fetchTableData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchTableData();
  }

  void changeYear(String? val) {
    if (val == null) return;
    selectedYear.value = val;
    fetchTableData();
  }

  void changeTerm(String? val) async {
    if (val == null) return;
    selectedTerm.value = val;
    fetchTableData();
    selected.refresh();
  }

  void selectedDayChange(int index) {
    selected.value = index;
  }

  Map<int, Lecture>? selectedDay(int index) {
    switch (index) {
      case 0:
        selectedDayName = "Saturday".tr;
        return tableTime?.sat;
      case 1:
        selectedDayName = "Sunday".tr;
        return tableTime?.sun;
      case 2:
        selectedDayName = "Monday".tr;
        return tableTime?.mon;
      case 3:
        selectedDayName = "Tuesday".tr;
        return tableTime?.tue;
      case 4:
        selectedDayName = "Wednesday".tr;
        return tableTime?.wed;
      case 5:
        selectedDayName = "Thursday".tr;
        return tableTime?.thu;
      default:
        return null;
    }
  }

  Future<void> initSectionDropdownMenuList({bool force = false}) async {
    List<Section> sectionsData =
        await SectionServices.fetchSections(hardFetch: force)
            .then((e) => e.data?.values.toList() ?? []);
    departments = [];
    for (Section section in sectionsData) {
      departments.add(
        DropdownMenuItem<int>(
            value: section.id,
            child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? (Get.width / 3.3) * 0.75
                  : (Get.width / 5.5) * 0.6,
              child: SecText(
                section.name ?? "unknown",
                textColor: AppColors.mainTextColor,
                fontSize: 12,
              ),
            )),
      );
    }
  }

  Future<void> initLevelDropdownMenuList({bool force = false}) async {
    List<Level> levelsData = await LevelServices.fetchLevels(hardFetch: force)
        .then((e) => e.data?.values.toList() ?? []);
    levels = [];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? (Get.width / 3.3) * 0.75
                  : (Get.width / 8) * 0.6,
              child: SecText(
                level.name ?? "unknown",
                textColor: AppColors.mainTextColor,
                fontSize: 12,
              ),
            )),
      );
    }
  }

  Future<void> initYearDropdownMenuList({bool force = false}) async {
    List<String> yearData =
        await LectureServices.fetchLectureYears(hardFetch: force)
            .then((e) => e.data ?? []);
    years = [];
    for (String year in yearData) {
      years.add(
        DropdownMenuItem(
            value: year,
            child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? (Get.width / 3.3) * 0.75
                  : (Get.width / 7) * 0.6,
              child: SecText(
                year,
                textColor: AppColors.mainTextColor,
                fontSize: 12,
              ),
            )),
      );
    }
  }

  Future<void> more(String val, {Map<String, dynamic>? data}) async {
    if (val == "Edit") {
      await getSubjects();
      mode = "Edit";
      if (data != null) {
        selectedLecture = data["id"];
        doctorId.value = data["doctor_id"];
        subjectId.value = data["subject"]["subject_id"];
        timeController.text =
            DateTimeUtils.formatStringTime(time: data["lecture_time"]);
        durationController.text = data["duration"].toString();
        hallController.text = data["lecture_room"].toString();
      }
      Get.dialog(const PopUpIAddAndUpdateLectureCard());
    } else if (val == "Delete") {
      if (selectedLevel.value == null) return;
      if (selectedDepartment.value == null) return;
      if (selectedYear.value == null) return;
      selectedLecture = data?["id"];
      Result<void> res = await LectureServices.deleteLecture(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName,
          id: selectedLecture);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        selectedDay(selected.value)?.remove(selectedLecture);
        selected.refresh();
        showSnakeBar(message: "Delete successfully");
      } else {
        showSnakeBar(message: "Delete failed");
      }
    } else if (val == "TemporaryReplace") {
      await getSubjects();
      mode = "Replace";
      if (data != null) {
        selectedLecture = data["id"];
        doctorId.value = data["doctor_id"];
        subjectId.value = data["subject"]["subject_id"];
        timeController.text =
            DateTimeUtils.formatStringTime(time: data["lecture_time"]);
        durationController.text = data["duration"].toString();
        hallController.text = data["lecture_room"].toString();
      }
      Get.dialog(const PopUpIAddAndUpdateLectureCard());
    } else if (val == "Confirm") {
      selectedLecture = data?["id"];
      if (selectedLecture == null) return;
      Result<void> res = await LectureServices.changeLectureState(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName,
          id: selectedLecture!,
          action: 'confirm');
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        selectedDay(selected.value)?[selectedLecture]?.lectureStatus = true;
        selected.refresh();
        showSnakeBar(message: "Confirm successfully");
      } else {
        showSnakeBar(message: "Confirm failed");
      }
    } else if (val == "Cancel") {
      selectedLecture = data?["id"];
      if (selectedLecture == null) return;
      Result<void> res = await LectureServices.changeLectureState(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName,
          id: selectedLecture!,
          action: 'cancel');
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        selectedDay(selected.value)?[selectedLecture]?.lectureStatus = false;
        selected.refresh();
        showSnakeBar(message: "Cancel successfully");
      } else {
        showSnakeBar(message: "Cancel failed");
      }
    }
  }

  Future<void> addButtonClick() async {
    // doctorId.value = 1000;
    await getSubjects();
    mode = "Add";
    timeController.text = DateTimeUtils.formatTimeOfDay(time: TimeOfDay.now());
    Get.dialog(const PopUpIAddAndUpdateLectureCard());
  }

  void submit() async {
    if (adding) return;
    adding = true;
    Map<String, dynamic> jsData = {};
    if (formKey.currentState!.validate()) {
      jsData["lecture_section_id"] = selectedDepartment.value;
      jsData["lecture_level_id"] = selectedLevel.value;
      jsData["year"] = selectedYear.value ?? "2024";
      jsData["term"] = selectedTerm.value;
      jsData["lecture_day"] = selectedDayName;
      ((subjectId.value?.isNotEmpty ?? false) &&
              subjectId.value != "Unknown".tr)
          ? jsData["subject_id"] = subjectId.value
          : null;
      (doctorId.value != null) ? jsData["doctor_id"] = doctorId.value : null;
      (timeController.text.isNotEmpty && timeController.text != "Unknown".tr)
          ? jsData["lecture_time"] = DateTimeUtils.formatStringTime(
              time: timeController.text,
              format: TimeFormat.hhMmSs,
              currentFormat: TimeFormat.hhMmA)
          : null;
      (durationController.text.isNotEmpty &&
              durationController.text != "Unknown".tr)
          ? jsData["lecture_duration"] =
              int.tryParse(durationController.text) ?? 0
          : null;
      (hallController.text.isNotEmpty && hallController.text != "Unknown".tr)
          ? jsData["lecture_room"] = hallController.text
          : null;
    }
    if (mode == "Add") {
      Result<Lecture> res = await LectureServices.createLecture(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value ?? "2024",
          term: selectedTerm.value,
          day: selectedDayName,
          data: jsData);

      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 201 && res.data != null) {
        selectedDay(selected.value)?[res.data!.id] = res.data!;
        selected.refresh();
        showSnakeBar(message: "Add successfully");
      } else {
        showSnakeBar(message: "Add failed");
      }
    } else if (mode == "Edit") {
      if (selectedLecture == null) return;
      Result<Lecture> res = await LectureServices.updateLecture(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName,
          data: jsData,
          id: selectedLecture);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200 && res.data != null) {
        selectedDay(selected.value)?[selectedLecture!] = res.data!;
        selected.refresh();
        showSnakeBar(message: "Edit successfully");
      } else {
        showSnakeBar(message: "Edit failed");
      }
    } else if (mode == "Replace") {
      if (selectedLecture == null) return;
      Result<Lecture> res = await LectureServices.tempReplaceLecture(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName,
          data: jsData,
          id: selectedLecture);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200 && res.data != null) {
        selectedDay(selected.value)?.remove(selectedLecture);
        selectedDay(selected.value)?[res.data!.id] = res.data!;
        selected.refresh();
        showSnakeBar(message: "Replace successfully");
      } else {
        showSnakeBar(message: "Replace failed");
      }
    }
    adding = false;
  }

  Future<void> getSubjects() async {
    subjects = {};
    subjects = await SubjectServices.fetchSubjects().then((e) => e.data ?? {});
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

  void popCardClear() {
    timeController.dispose();
    durationController.dispose();
    hallController.dispose();
    nameFocus.dispose();
    timeFocus.dispose();
    durationFocus.dispose();
    entryYearFocus.dispose();
    phoneFocus.dispose();
  }

  @override
  void onClose() {
    popCardClear();
  }
}
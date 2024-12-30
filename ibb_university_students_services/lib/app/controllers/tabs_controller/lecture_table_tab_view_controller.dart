import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/pop_up_cards/loading_card.dart';
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
import '../../utils/formatter.dart';
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
            width: (Get.width / 3.3) * 0.75,
            child: SecText("Term 1", textColor: AppColors.mainTextColor,fontSize: 12,))),
    DropdownMenuItem<String>(
        value: "Term 2",
        child: SizedBox(
            width: (Get.width / 3.3) * 0.75,
            child: SecText("Term 2", textColor: AppColors.mainTextColor,fontSize: 12,))),
  ];

  //Lecture popCard variables
  Map<String, Subject>? subjects;
  late RxString subject;
  TextEditingController doctorController = TextEditingController();
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

  @override
  void onInit() async {
    // TODO: implement onInit
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
        year: selectedYear.value!,
        term: selectedTerm.value,
        hardFetch: force);
    if (res.statusCode == 200) {
      tableTime = res.data;
      selected.refresh();
    } else if (res.statusCode == 404) {
      tableTime = null;
      fieldMessage.value = "this section and level not has Lectures";
      showSnakeBar(
          title: "Fetch Lectures Failed",
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
        break;
      case 1:
        selectedDayName = "Sunday".tr;
        return tableTime?.sun;
        break;
      case 2:
        selectedDayName = "Monday".tr;
        return tableTime?.mon;
        break;
      case 3:
        selectedDayName = "Tuesday".tr;
        return tableTime?.tue;
        break;
      case 4:
        selectedDayName = "Wednesday".tr;
        return tableTime?.wed;
        break;
      case 5:
        selectedDayName = "Thursday".tr;
        return tableTime?.thu;
        break;
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
              width: (Get.width / 3.3) * 0.75,
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
              width: (Get.width / 3.3) * 0.75,
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
              width: (Get.width / 3.3) * 0.75,
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
    if (val == "Update") {
      mode = "Update";
      if (data != null) {
        doctorController.text = data["lecturer"].toString();
        timeController.text = data["startTime"].toString();
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
      Get.back();
      selectedDay(selected.value)?.remove(selectedLecture);
      selected.refresh();
      if (res.statusCode == 200) {
        selectedDay(selected.value)?.remove(selectedLecture);
        selected.refresh();
        showSnakeBar(message: "Delete successfully");
      } else {
        showSnakeBar(message: "Delete failed");
      }
    } else if (val == "TemporaryReplace") {
    } else if (val == "Confirm") {
    } else if (val == "Cancel") {}
  }

  Future<void> addButtonClick() async {
    doctorController.text = "1000";

    mode = "Add";
    timeController.text = Formatter.formatTimeOfDay(TimeOfDay.now());
    subjects = {};
    subjects = await SubjectServices.fetchSubjects().then((e) => e.data ?? {});
    if (subjects?.values.first != null) {
      subject = RxString(subjects!.values.first.id);
    }
    Get.dialog(const PopUpIAddAndUpdateLectureCard());
  }

  void submit() async {
    Map<String, dynamic> jsData = {};
    if (formKey.currentState!.validate()) {
      jsData["lecture_section_id"] = selectedDepartment.value;
      jsData["lecture_level_id"] = selectedLevel.value;
      jsData["year"] = selectedYear.value;
      jsData["term"] = selectedTerm.value;
      jsData["lecture_day"] = selectedDayName;
      (subject.value.isNotEmpty && subject.value != "Unknown".tr)
          ? jsData["subject_id"] = subject.value
          : null;
      (doctorController.text.isNotEmpty &&
              doctorController.text != "Unknown".tr)
          ? jsData["doctor_id"] = double.parse(doctorController.text)
          : null;
      (timeController.text.isNotEmpty && timeController.text != "Unknown".tr)
          ? jsData["lecture_time"] = timeController.text
          : null;
      (durationController.text.isNotEmpty &&
              durationController.text != "Unknown".tr)
          ? jsData["lecture_duration"] = durationController.text
          : null;
      (hallController.text.isNotEmpty && hallController.text != "Unknown".tr)
          ? jsData["lecture_room"] = hallController.text
          : null;
    }
    if (mode == "Add") {
      Result<Lecture> res = await LectureServices.createLecture(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName,
          data: jsData);
      Get.back();
      if (res.statusCode == 201 && res.data != null) {
        selectedDay(selected.value)?[res.data!.id] = res.data!;
        selected.refresh();
        showSnakeBar(message: "Add successfully");
      } else {
        showSnakeBar(message: "Add failed");
      }
    } else if (mode == "Update") {
      Result<Lecture> res = await LectureServices.updateLecture(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName,
          data: jsData,
          id: null);
      Get.back();
      if (res.statusCode == 200 && res.data != null) {
        selectedDay(selected.value)?[res.data!.id] = res.data!;
        selected.refresh();
        showSnakeBar(message: "Update successfully");
      } else {
        showSnakeBar(message: "Update failed");
      }
    }
  }

  void popCardClear() {
    timeController.dispose();
    durationController.dispose();
    hallController.dispose();
    doctorController.dispose();
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

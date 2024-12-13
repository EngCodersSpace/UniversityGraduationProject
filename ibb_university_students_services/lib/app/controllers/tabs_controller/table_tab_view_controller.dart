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
import '../../services/app_data_services.dart';

class TableTabController extends GetxController {
  RxBool loadState = true.obs;
  TableDays? tableTime;
  Rx<List<Lecture>?> selectedDay = Rx<List<Lecture>?>([]);
  RxInt selected = 3.obs;
  String selectedDayName = "Sunday".tr;
  Rx<int?> selectedDepartment = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  Rx<String?> selectedYear = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  Map termsData = {};

  List<DropdownMenuItem<int>> departments = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> years = [];
  List<DropdownMenuItem<String>> terms = [];

  @override
  void onInit() async {
    await initDropdownMenuLists();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (departments.isNotEmpty)
        ? selectedDepartment.value = departments.first.value
        : null;
    (years.isNotEmpty) ? selectedYear.value = years.first.value! : null;
    await fetchTableData();
    selectedDayChange(selected.value);
    loadState.value = false;
    super.onInit();
  }

  @override
  void refresh() {
    super.refresh();
  }

  Future<void> fetchTableData() async {
    if (selectedLevel.value == null) return;
    if (selectedDepartment.value == null) return;
    if (selectedYear.value == null) return;
    Result res = await LectureServices.fetchTableTime(
      sectionId: selectedDepartment.value!,
      levelId: selectedLevel.value!,
      year: selectedYear.value!,
    );
    if (res.statusCode == 200) {
      termsData = res.data;
      tableTime = res.data[selectedTerm.value];
      selectedDayChange(selected.value);
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
    tableTime = termsData[selectedTerm.value];
    selectedDayChange(selected.value);
    selected.refresh();
  }

  void selectedDayChange(int index) {
    selected.value = index;
    switch (index) {
      case 0:
        selectedDay.value = tableTime?.sat;
        selectedDayName = "Saturday".tr;
        break;
      case 1:
        selectedDayName = "Sunday".tr;
        selectedDay.value = tableTime?.sun;
        break;
      case 2:
        selectedDay.value = tableTime?.mon;
        selectedDayName = "Monday".tr;
        break;
      case 3:
        selectedDay.value = tableTime?.tue;
        selectedDayName = "Tuesday".tr;
        break;
      case 4:
        selectedDay.value = tableTime?.wed;
        selectedDayName = "Wednesday".tr;
        break;
      case 5:
        selectedDay.value = tableTime?.thu;
        selectedDayName = "Thursday".tr;
        break;
    }
  }

  Future<void> initDropdownMenuLists() async {
    List<Section> sectionsData =
        await SectionServices.fetchSections().then((e) => e.data ?? []);
    List<Level> levelsData =
        await LevelServices.fetchLevels().then((e) => e.data ?? []);
    List<String> yearData =
        await AppDataServices.fetchLectureYears().then((e) => e.data ?? []);
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
    terms = [
      DropdownMenuItem<String>(
          value: "Term 1",
          child: SizedBox(
              width: (Get.width / 3.3) * 0.75,
              child: SecText(
                "Term 1",
                textColor: AppColors.mainTextColor,
                fontSize: 12,
              ))),
      DropdownMenuItem<String>(
          value: "Term 2",
          child: SizedBox(
              width: (Get.width / 3.3) * 0.75,
              child: SecText(
                "Term 2",
                textColor: AppColors.mainTextColor,
                fontSize: 12,
              ))),
    ];
  }

  @override
  void onClose() {}
}

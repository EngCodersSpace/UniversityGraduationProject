import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/result.dart';
import 'package:ibb_university_students_services/app/services/exam_services.dart';
import '../components/custom_text.dart';
import '../styles/app_colors.dart';
import '../models/exam_model.dart';
import '../models/level_model.dart';
import '../models/section_model.dart';
import '../services/app_data_services.dart';
import '../services/level_services.dart';
import '../services/section_services.dart';

class ExamTableController extends GetxController {
  RxBool loadingState = true.obs;
  RxInt selected = 3.obs;
  String selectedDayName = "Sunday".tr;
  Rx<int?> selectedDepartment = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  Rx<String?> selectedYear = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  Rx<List<Exam>>? exams = Rx([]);
  List<DropdownMenuItem<int>> departments = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> years = [];
  List<DropdownMenuItem<String>> terms = [];

  @override
  void onInit() async {
    // TODO: implement onInit
    await initDropdownMenuLists();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (departments.isNotEmpty)
        ? selectedDepartment.value = departments.first.value
        : null;
    (years.isNotEmpty)
        ? selectedYear.value = years.first.value!
        : null;
    await fetchExamsData();
    super.onInit();
    loadingState.value = false;
  }

  @override
  void refresh() {
    super.refresh();
  }

  Future<void> fetchExamsData() async {
    if (selectedLevel.value == null) return;
    if (selectedDepartment.value == null) return;
    Result res = await ExamServices.fetchExams(
      sectionId: selectedDepartment.value!,
      levelId: selectedLevel.value!,
      year: selectedYear.value!,
      term: selectedTerm.value
    );
    print("here ${res.statusCode}");
    if (res.statusCode == 200) {
      exams?.value = res.data??[];
    }
  }

  void changeDepartment(int? val) async {
    if (val == null) return;
    selectedDepartment.value = val;
    await fetchExamsData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchExamsData();
  }

  void changeYear(String? val) {
    if (val == null) return;
    selectedYear.value = val;
    fetchExamsData();
  }

  void changeTerm(String? val) async {
    if (val == null) return;
    selectedTerm.value = val;
    fetchExamsData();
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

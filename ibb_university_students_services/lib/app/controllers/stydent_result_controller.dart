import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/custom_text.dart';
import '../styles/app_colors.dart';
import '../models/exam_model.dart';
import '../models/level_model.dart';
import '../services/level_services.dart';

class StudentResultController extends GetxController {
  RxBool loadingState = true.obs;
  RxInt selected = 3.obs;
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  Rx<List<Exam>>? exams = Rx([]);
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> terms = [];

  @override
  void onInit() async {
    await initDropdownMenuLists();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
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
    // Result res = await ExamServices.fetchExams(
    //   levelId: selectedLevel.value!,
    //   term: selectedTerm.value
    // );
    // print("here ${res.statusCode}");
    // if (res.statusCode == 200) {
    //   exams?.value = res.data??[];
    // }
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

  Future<void> initDropdownMenuLists() async {
    List<Level> levelsData =
        await LevelServices.fetchLevels().then((e) => e.data ?? []);
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

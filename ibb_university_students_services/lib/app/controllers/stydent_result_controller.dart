import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/services/grad_services.dart';
import '../components/custom_text.dart';
import '../models/grads_model.dart';
import '../models/result.dart';
import '../styles/app_colors.dart';
import '../models/level_model.dart';
import '../services/level_services.dart';

class StudentResultController extends GetxController {
  RxBool loadingState = true.obs;
  RxInt selected = 3.obs;
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  Rx<List<Grad>>? grads = Rx([]);
  RxInt summation = 0.obs;
  RxDouble gpa = 0.0.obs;
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> terms = [];

  @override
  void onInit() async {
    // TODO: implement onInit
    await initDropdownMenuLists();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    await fetchStudentGrads();
    super.onInit();
    loadingState.value = false;
  }

  @override
  void refresh() async{
    await fetchStudentGrads();
    super.refresh();
  }

  Future<void> fetchStudentGrads() async {
    gpa.value = 0.0;
    summation.value = 0;
    if (selectedLevel.value == null) return;
    Result res = await GradServices.fetchStudentGrads(
      levelId: selectedLevel.value!,
      term: selectedTerm.value
    );
    if (res.statusCode == 200) {
      int unitSum = 0;
      grads?.value = res.data??[];
      for(Grad grad in grads?.value??[]){
        summation.value += ((grad.examGrad??0)+(grad.workGrad??0))* (grad.subject?.units??0);
        unitSum += (grad.subject?.units??0);
      }
      gpa.value = summation.value/unitSum;
    }else{
      grads?.value = [];
    }
  }



  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchStudentGrads();
  }



  void changeTerm(String? val) async {
    if (val == null) return;
    selectedTerm.value = val;
    fetchStudentGrads();
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/repositories/grad_repository.dart';
import 'package:ibb_university_students_services/app/utils/screen_utils.dart';
import '../components/custom_text_v2.dart';
import '../models/grads_model/grads_model.dart';
import '../models/helper_models/result.dart';
import '../models/level_model/level.dart';
import '../models/student_model/student.dart';
import '../repositories/level_repository.dart';
import '../repositories/user_repository.dart';
import '../styles/text_styles.dart';
import '../utils/maping_data.dart';
import '../utils/snake_bar.dart';

class StudentResultController extends GetxController {
  RxBool loadingState = true.obs;
  RxInt selected = 3.obs;
  TextEditingController idController = TextEditingController();
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  Rx<List<Grad>>? grads = Rx([]);
  RxInt summation = 0.obs;
  RxDouble gpa = 0.0.obs;
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> terms = [];
  RxString failedMessage = "".obs;
  int? studentId;

  @override
  void onInit() async {
    await initDropdownMenuLists();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    if (UserRepository.currentUserType() == Student) {
      studentId = await UserRepository.fetchUser().then((e) => e.data?.id);
    }
    await fetchStudentGrads();
    super.onInit();
    loadingState.value = false;
  }

  @override
  void refresh() async {
    await fetchStudentGrads();
    super.refresh();
  }

  Future<void> fetchStudentGrads() async {
    gpa.value = 0.0;
    summation.value = 0;
    if (studentId == null) return;
    if (selectedLevel.value == null) return;
    Result res = await GradRepository.fetchStudentGrads(
        studentID: studentId!,
        levelId: selectedLevel.value!,
        term: selectedTerm.value);
    if (res.statusCode == 200) {
      int unitSum = 0;
      grads?.value = res.data ?? [];
      for (Grad grad in grads?.value ?? []) {
        summation.value += ((grad.examGrad ?? 0) + (grad.workGrad ?? 0)) *
            (grad.subject?.units ?? 0);
        unitSum += (grad.subject?.units ?? 0);
      }
      gpa.value = summation.value / unitSum;
    } else if (res.statusCode == 404) {
      grads?.value = [];
      failedMessage.value = "this level and term not has grads";
      showSnakeBar(
          title: "Not Found Grads",
          message: "this level and term not has grads");
    } else {
      failedMessage.value = "fetching grads failed please check connection";
      showSnakeBar(
          title: "Fetch Grads Failed",
          message: "fetching lectures failed please check connection ");
    }
    grads?.refresh();
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
    List<Level> levelsData = await LevelRepository.fetchLevels()
        .then((e) => e.data?.values.toList() ?? []);
    levels = [];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? ((((Get.width - 32) / 7) * 3) - 50) * 0.6
                  : (Get.width / 8) * 0.4,
              child: CustomText(
                level.name ?? "unknown",
                style: AppTextStyles.mainStyle(
                  textHeader: AppTextHeaders.h5Bold,
                ),
              ),
            )),
      );
    }
    terms = [
      DropdownMenuItem<String>(
          value: "Term 1",
          child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? ((((Get.width - 32) / 7) * 3.8) - 50) * 0.6
                  : (Get.width / 8) * 0.4,
              child: CustomText(
                mappingTerms("Term 1"),
                style: AppTextStyles.mainStyle(
                  textHeader: AppTextHeaders.h5Bold,
                ),
              ))),
      DropdownMenuItem<String>(
          value: "Term 2",
          child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? ((((Get.width - 32) / 7) * 3.8) - 50) * 0.6
                  : (Get.width / 8) * 0.4,
              child: CustomText(
                mappingTerms("Term 2"),
                style: AppTextStyles.mainStyle(
                  textHeader: AppTextHeaders.h5Bold,
                ),
              ))),
    ];
  }

  void findButtonClick() {
    studentId = int.tryParse(idController.text);
    fetchStudentGrads();
  }

  @override
  void onClose() {}
}

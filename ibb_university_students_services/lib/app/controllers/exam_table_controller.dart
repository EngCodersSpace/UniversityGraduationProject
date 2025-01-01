import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/result.dart';
import 'package:ibb_university_students_services/app/models/subject_model.dart';
import 'package:ibb_university_students_services/app/services/exam_services.dart';
import 'package:ibb_university_students_services/app/services/subject_services.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';
import 'package:ibb_university_students_services/app/views/exam_table_view/exam_table_view_components/add_and_update_exam_card.dart';
import 'package:intl/intl.dart';
import '../components/custom_text.dart';
import '../styles/app_colors.dart';
import '../models/exam_model.dart';
import '../models/level_model.dart';
import '../models/section_model.dart';
import '../services/level_services.dart';
import '../services/section_services.dart';
import '../utils/date_time_utils.dart';

class ExamTableController extends GetxController {
  RxBool loadingState = true.obs;
  RxInt selected = 3.obs;
  String selectedDayName = "Sunday".tr;
  Rx<int?> selectedDepartment = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  Rx<String?> selectedYear = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  Rx<Map<int,Exam>>? exams = Rx({});
  List<DropdownMenuItem<int>> departments = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> years = [];
  List<DropdownMenuItem<String>> terms = [];
  RxString fieldMessage = "".obs;

  //Exam popCard variables
  Map<String,Subject>? subjects;
  late RxString subject;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  RxString day = "Saturday".obs;
  TextEditingController hallController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode subjectFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode timeFocus = FocusNode();
  FocusNode dayFocus = FocusNode();
  FocusNode hallFocus = FocusNode();
  String mode = "Add";
  int? selectedExam;

  @override
  void onInit() async {
    // TODO: implement onInit
    await initSectionDropdownMenuList();
    await initLevelDropdownMenuLists();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (departments.isNotEmpty)
        ? selectedDepartment.value = departments.first.value
        : null;
    (years.isNotEmpty) ? selectedYear.value = years.first.value! : null;
    await fetchExamsData();
    super.onInit();
    loadingState.value = false;
  }

  @override
  void refresh() {
    fetchExamsData(force: true);
    super.refresh();
  }

  Future<void> fetchExamsData({bool force = false}) async {
    if (selectedLevel.value == null) {
      await initLevelDropdownMenuLists();
    }
    if (selectedDepartment.value == null) {
      await initSectionDropdownMenuList();
    }
    if (selectedDepartment.value == null || selectedLevel.value == null) {
      return;
    }
    Result res = await ExamServices.fetchExamsGroup(
      sectionId: selectedDepartment.value!,
      levelId: selectedLevel.value!,
      hardFetch: force,
    );
    if (res.statusCode == 200) {
      exams?.value = {};
      exams?.value = res.data ?? {};
    } else if (res.statusCode == 404) {
      exams?.value = res.data ?? {};
      fieldMessage.value = "this section and level not has Exams";
      showSnakeBar(
          title: "Not Found Exams ",
          message: "this section and level doesn't has exams ");
    }else{
      fieldMessage.value = "fetching exam failed please check connection";
      showSnakeBar(
          title: "Fetch Exams Failed",
          message: "fetching exam failed please check connection ");
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


  Future<void> initSectionDropdownMenuList() async {
    List<Section> sectionsData =
    await SectionServices.fetchSections().then((e) => e.data?.values.toList() ?? []);
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
    selectedDepartment.value = sectionsData.first.id;
  }


  Future<void> initLevelDropdownMenuLists() async {
    List<Level> levelsData =
        await LevelServices.fetchLevels().then((e) => e.data?.values.toList() ?? []);
    // List<String> yearData =
    //     await AppDataServices.fetchLectureYears().then((e) => e.data ?? []);
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
    selectedLevel.value = levelsData.first.id;

    // years = [];
    // for (String year in yearData) {
    //   years.add(
    //     DropdownMenuItem(
    //         value: year,
    //         child: SizedBox(
    //           width: (Get.width / 3.3) * 0.75,
    //           child: SecText(
    //             year,
    //             textColor: AppColors.mainTextColor,
    //             fontSize: 12,
    //           ),
    //         )),
    //   );
    // }
    // terms = [
    //   DropdownMenuItem<String>(
    //       value: "Term 1",
    //       child: SizedBox(
    //           width: (Get.width / 3.3) * 0.75,
    //           child: SecText(
    //             "Term 1",
    //             textColor: AppColors.mainTextColor,
    //             fontSize: 12,
    //           ))),
    //   DropdownMenuItem<String>(
    //       value: "Term 2",
    //       child: SizedBox(
    //           width: (Get.width / 3.3) * 0.75,
    //           child: SecText(
    //             "Term 2",
    //             textColor: AppColors.mainTextColor,
    //             fontSize: 12,
    //           ))),
    // ];
  }

  void more(String val, {Map<String, dynamic>? data}) async{
    if (val == "Update") {
      mode = "Update";
      if (data != null) {
        selectedExam = data["exam_id"];
        subjects = {};
        subjects = await SubjectServices.fetchSubjects().then((e) => e.data ?? {});
        subject = RxString(data["subject"]["subject_id"]);
        dateController.text = data["exam_date"].toString();
        timeController.text = DateTimeUtils.formatStringTime(time:data["exam_time"]);
        day.value = data["exam_day"].toString();
        hallController.text = data["exam_room"].toString();
      }
      Get.dialog(const PopUpIAddAndUpdateExamCard());
    } else if (val == "Delete") {
      if (selectedLevel.value == null) return;
      if (selectedDepartment.value == null) return;
      selectedExam = data?["exam_id"];
      Result<void> res = await ExamServices.deleteExam(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          id: selectedExam
      );
      Get.back();
      if(res.statusCode == 200) {
        exams?.value.remove(selectedExam);
        exams?.refresh();
        showSnakeBar(message: "Delete successfully");
      }else{
        showSnakeBar(message: "Delete failed");
      }
    }
  }

  void addButtonClick() async {
    mode = "Add";
    dateController.text = DateTime.now().toString().split(" ")[0];
    timeController.text = DateTimeUtils.formatTimeOfDay(time:TimeOfDay.now());
    subjects = {};
    subjects = await SubjectServices.fetchSubjects().then((e) => e.data ?? {});
    if (subjects?.values.first != null) {
      subject = RxString(subjects!.values.first.id);
    }
    Get.dialog(const PopUpIAddAndUpdateExamCard());
  }

  void submit() async {
    Get.back();
    Map<String, dynamic> jsData = {};
    if (formKey.currentState!.validate()) {
      jsData["exam_section_id"] = selectedDepartment.value;
      jsData["exam_level_id"] = selectedLevel.value;
      (subject.value.isNotEmpty && subject.value != "Unknown".tr)
          ? jsData["subject_id"] = subject.value
          : null;
      (dateController.text.isNotEmpty && dateController.text != "Unknown".tr)
          ? jsData["exam_date"] = dateController.text
          : null;
      (timeController.text.isNotEmpty && timeController.text != "Unknown".tr)
          ? jsData["exam_time"] = DateFormat('HH:mm:ss')
              .format(DateFormat('hh:mm a').parse(timeController.text))
          : null;
      (day.value.isNotEmpty && day.value != "Unknown".tr)
          ? jsData["exam_day"] = day.value
          : null;
      (hallController.text.isNotEmpty && hallController.text != "Unknown".tr)
          ? jsData["exam_room"] = hallController.text
          : null;
    }
    if (selectedLevel.value == null) return;
    if (selectedDepartment.value == null) return;

    if (mode == "Add") {
      Result<Exam> res = await ExamServices.createExam(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          data: jsData);
      Get.back();
      if (res.statusCode == 201 && res.data != null) {
        exams?.value[res.data!.id] = res.data!;
        exams?.refresh();
        showSnakeBar(message: "Add successfully");
      }else{
        showSnakeBar(message: "Add failed");
      }
    } else if (mode == "Update") {
      Result<Exam> res = await ExamServices.updateExam(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          data: jsData,
          id: selectedExam
      );
      Get.back();
      if (res.statusCode == 200 && res.data != null) {
        exams?.value[res.data!.id] = res.data!;
        exams?.refresh();
        showSnakeBar(message: "Update successfully");
      }else{
        showSnakeBar(message: "Update failed");
      }
    }
  }

  void popCardClear() {
    timeController.dispose();
    hallController.dispose();
    dateController.dispose();
    subjectFocus.dispose();
    timeFocus.dispose();
    dayFocus.dispose();
    hallFocus.dispose();
    dateFocus.dispose();
  }

  @override
  void onClose() {}
}

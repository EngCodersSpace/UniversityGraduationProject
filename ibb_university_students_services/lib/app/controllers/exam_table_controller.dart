import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/pop_up_cards/loading_card.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/services/exam_services.dart';
import 'package:ibb_university_students_services/app/services/subject_services.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';
import 'package:ibb_university_students_services/app/views/exam_table_view/exam_table_view_components/add_and_update_exam_card.dart';
import 'package:intl/intl.dart';
import '../components/custom_text_v2.dart';
import '../models/subject_model/subject_model.dart';
import '../models/exam_model/exam_model.dart';
import '../models/level_model/level.dart';
import '../models/section_model/section.dart';
import '../services/level_services.dart';
import '../services/section_services.dart';
import '../styles/text_styles.dart';
import '../utils/date_time_utils.dart';

class ExamTableController extends GetxController {
  RxBool loadingState = true.obs;
  RxInt selected = 3.obs;
  String selectedDayName = "Sunday".tr;
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  Rx<String?> selectedYear = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  Rx<Map<int,Exam>>? exams = Rx({});
  List<DropdownMenuItem<int>> sections = [];
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
    await ExamServices.openBox();
    await initSectionDropdownMenuList();
    await initLevelDropdownMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty)
        ? selectedSection.value = sections.first.value
        : null;
    (years.isNotEmpty) ? selectedYear.value = years.first.value! : null;
    await fetchExamsData();
    super.onInit();
    loadingState.value = false;
  }

  @override
  void refresh() async{
    Get.dialog(const PopUpLoadingCard());
    await fetchExamsData(force: true);
    Navigator.of(Get.overlayContext!).pop();
    super.refresh();
  }

  Future<void> fetchExamsData({bool force = false}) async {
    if (selectedLevel.value == null) {
      await initLevelDropdownMenuList();
    }
    if (selectedSection.value == null) {
      await initSectionDropdownMenuList();
    }
    if (selectedSection.value == null || selectedLevel.value == null) {
      return;
    }
    Result res = await ExamServices.fetchExamsGroup(
      sectionId: selectedSection.value!,
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
      exams?.value = res.data ?? {};
      fieldMessage.value = "fetching exam failed please check connection";
      showSnakeBar(
          title: "Fetch Exams Failed",
          message: "fetching exam failed please check connection ");
    }
  }

  void changeDepartment(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
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
    await SectionServices.fetchSections().then((e) => e.data ?? []);
    sections = [];
    for (Section section in sectionsData) {
      sections.add(
        DropdownMenuItem<int>(
            value: section.id,
            child: SizedBox(
              width: (((Get.width - 16) / 7) * 4)*0.48,
              child: CustomText(
                section.name ?? "unknown",
                style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5Bold),
              ),
            )),
      );
    }
    selectedSection.value = sectionsData.first.id;
  }
  Future<void> initLevelDropdownMenuList() async {
    List<Level> levelsData =
        await LevelServices.fetchLevels().then((e) => e.data ?? []);
    // List<String> yearData =
    //     await AppDataServices.fetchLectureYears().then((e) => e.data ?? []);
    levels = [];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (((Get.width - 16) / 7) * 2.5)*0.35,
              child: CustomText(
                level.name ?? "unknown",
                style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5Bold),
              ),
            )),
      );
    }
    selectedLevel.value = levelsData.first.id;
  }

  void more(String val, {Map<String, dynamic>? data}) async{
    if (val == "Edit") {
      mode = "Edit";
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
      if (selectedSection.value == null) return;
      selectedExam = data?["exam_id"];
      Result<void> res = await ExamServices.deleteExam(
          sectionId: selectedSection.value!,
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
    Map<String, dynamic> jsData = {};
    if (formKey.currentState!.validate()) {
      jsData["exam_section_id"] = selectedSection.value;
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
    if (selectedSection.value == null) return;

    if (mode == "Add") {
      Result<Exam> res = await ExamServices.createExam(
          sectionId: selectedSection.value!,
          levelId: selectedLevel.value!,
          data: jsData);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 201 && res.data != null) {
        exams?.value[res.data!.id] = res.data!;
        exams?.refresh();
        showSnakeBar(message: "Add successfully");
      }else{
        showSnakeBar(message: "Add failed");
      }
    } else if (mode == "Edit") {
      Result<Exam> res = await ExamServices.updateExam(
          sectionId: selectedSection.value!,
          levelId: selectedLevel.value!,
          data: jsData,
          id: selectedExam
      );
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200 && res.data != null) {
        exams?.value[res.data!.id] = res.data!;
        exams?.refresh();
        showSnakeBar(message: "Edit successfully");
      }else{
        showSnakeBar(message: "Edit failed");
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/result.dart';
import 'package:ibb_university_students_services/app/services/exam_services.dart';
import 'package:ibb_university_students_services/app/views/exam_table_view/exam_table_view_components/add_and_update_exam_card.dart';
import '../components/custom_text.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../styles/app_colors.dart';
import '../models/exam_model.dart';
import '../models/level_model.dart';
import '../models/section_model.dart';
import '../services/app_data_services.dart';
import '../services/level_services.dart';
import '../services/section_services.dart';
import '../utils/formatter.dart';

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


  //Exam popCard variables
  TextEditingController subjectController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController hallController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode subjectFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode timeFocus = FocusNode();
  FocusNode dayFocus = FocusNode();
  FocusNode hallFocus = FocusNode();
  RxString mode = "Add".obs;

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
    // List<String> yearData =
    //     await AppDataServices.fetchLectureYears().then((e) => e.data ?? []);
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

  void more(String val,{Map<String,dynamic>? data}) {
    if (val == "Update") {
      mode.value = "Update";
      if(data!=null){
        subjectController.text = data["subject"]["subject_name"].toString();
        dateController.text = data["exam_date"].toString();
        timeController.text = data["exam_time"].toString();
        dayController.text = data["exam_day"].toString();
        hallController.text = data["exam_room"].toString();
      }
      Get.dialog(const PopUpIAddAndUpdateExamCard());
    } else if (val == "Delete") {
    }
  }

  void addButtonClick(){
    Get.dialog(const PopUpIAddAndUpdateExamCard());
  }

  void datePiker(BuildContext context) async {
    DateTime? pikeDate = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
            data: ThemeData().copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppColors.inverseCardColor,
                onPrimary: AppColors.mainCardColor,
                surface: AppColors.mainCardColor,
                onSurface: AppColors.inverseCardColor,
              ),
            ),
            child: child!);
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pikeDate != null) {
      dateController.text = pikeDate.toString().split(" ")[0];
    }
  }

  void timePiker(BuildContext context) async {
    TimeOfDay? pikeTime = await showTimePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
            data: ThemeData().copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppColors.inverseCardColor,
                onPrimary: AppColors.mainCardColor,
                surface: AppColors.mainCardColor,
                onSurface: AppColors.inverseCardColor,
              ),
            ),
            child: child!);
      },
      initialTime: TimeOfDay.now(),
    );
    if (pikeTime != null) {
      timeController.text = Formatter.formatTimeOfDay(pikeTime);
      dayFocus.requestFocus();
    }
  }

  void submit() async {
    Get.dialog(const PopUpLoadingCard());
    await Future.delayed(const Duration(seconds: 2));
    // Map<String, dynamic> jsData = {};
    // rentController.text = double.parse(rentController.text).toStringAsFixed(2);
    // if (formKey.currentState!.validate()) {
    //   (nameController.text.isNotEmpty && nameController.text != "Unknown".tr)
    //       ? jsData["name"] = nameController.text
    //       : null;
    //   (rentController.text.isNotEmpty && rentController.text != "Unknown".tr)
    //       ? jsData["rent"] = double.parse(rentController.text)
    //       : null;
    //   (activityController.text.isNotEmpty && activityController.text != "Unknown".tr)
    //       ? jsData["job_domain"] = activityController.text
    //       : null;
    //   (entryYearController.text.isNotEmpty && entryYearController.text != "Unknown".tr)
    //       ? jsData["entery_year"] = entryYearController.text
    //       : null;
    //   (phoneController.text.isNotEmpty && phoneController.text != "Unknown".tr )
    //       ? jsData["phones"] = [phoneController.text]
    //       : null;
    //   Get.back(result: jsData);
    // }
    Get.back();
  }

  void popCardClear() {
    subjectController.dispose();
    timeController.dispose();
    dayController.dispose();
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

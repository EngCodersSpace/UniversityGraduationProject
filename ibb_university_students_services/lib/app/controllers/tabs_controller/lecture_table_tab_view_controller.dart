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
import '../../utils/formatter.dart';
import '../../views/lecture_table_tab_view/lecture_table_tab_components/add_and_update_lecture_card.dart';

class LectureController extends GetxController {

  //Lecture main view variables
  RxBool loadState = true.obs;
  TableDays? tableTime;
  Rx<List<Lecture>?> selectedDay =  Rx<List<Lecture>?>([]);
  RxInt selected = 3.obs;
  String selectedDayName = "Sunday".tr;
  Rx<int?> selectedDepartment = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  Rx<String?> selectedYear = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  List<DropdownMenuItem<int>> departments = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> years = [];
  List<DropdownMenuItem<String>> terms = [];

  //Lecture popCard variables
  TextEditingController subjectController = TextEditingController();
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
    await fetchTableData();
    selectedDayChange(selected.value);
    loadState.value = false;
    super.onInit();
  }

  @override
  void refresh() async{

    await fetchTableData(force: true);
    selectedDayChange(selected.value);
    loadState.value = false;
    super.refresh();
  }

  Future<void> fetchTableData({bool force = false}) async {
    if (selectedLevel.value == null) return;
    if (selectedDepartment.value == null) return;
    if (selectedYear.value == null) return;
    Result res = await LectureServices.fetchTableTime(
      sectionId: selectedDepartment.value!,
      levelId: selectedLevel.value!,
      year: selectedYear.value!,
      term: selectedTerm.value,
      hardFetch: force
    );
    if (res.statusCode == 200) {
      tableTime = res.data;
      selectedDayChange(selected.value);
    }
  }

  void changeDepartment(int? val) async{
    if (val == null) return;
    selectedDepartment.value = val;
    await fetchTableData();
  }

  void changeLevel(int? val) async{
    if (val == null) return;
    selectedLevel.value = val;
    await fetchTableData();
  }

  void changeYear(String? val) {
    if (val == null) return;
    selectedYear.value = val;
    fetchTableData();
  }

  void changeTerm(String? val) async{
    if (val == null) return;
    selectedTerm.value = val;
    fetchTableData();
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

  Future<void> initDropdownMenuLists({bool force = false}) async {
    List<Section> sectionsData =
        await SectionServices.fetchSections(hardFetch: force).then((e) => e.data ?? []);
    List<Level> levelsData =
        await LevelServices.fetchLevels(hardFetch: force).then((e) => e.data ?? []);
    List<String> yearData =
        await LectureServices.fetchLectureYears(hardFetch: force).then((e) => e.data ?? []);
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
              child: SecText("Term 1", textColor: AppColors.mainTextColor,fontSize: 12,))),
      DropdownMenuItem<String>(
          value: "Term 2",
          child: SizedBox(
              width: (Get.width / 3.3) * 0.75,
              child: SecText("Term 2", textColor: AppColors.mainTextColor,fontSize: 12,))),
    ];
  }

  void more(String val,{Map<String,dynamic>? data}) {
    if (val == "Update") {
      mode.value = "Update";
      if(data!=null){
        subjectController.text = data["subject_name"].toString();
        doctorController.text = data["lecturer"].toString();
        timeController.text = data["startTime"].toString();
        durationController.text = data["duration"].toString();
        hallController.text = data["lecture_room"].toString();
      }
      Get.dialog(const PopUpIAddAndUpdateLectureCard());
    } else if (val == "Delete") {
    }else if (val == "TemporaryReplace") {
    }else if (val == "Confirm") {
    }else if (val == "Cancel") {
    }
  }

  void addButtonClick(){
    Get.dialog(const PopUpIAddAndUpdateLectureCard());
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
      durationFocus.requestFocus();
    }
  }

  void submit() async {
    Get.dialog(const PopUpLoadingCard());
    await Future.delayed(const Duration(seconds: 2));
    Map<String,dynamic> jsData = {};
    if (formKey.currentState!.validate()) {
      jsData["lecture_section_id"] = selectedDepartment.value;
      jsData["lecture_level_id"] = selectedLevel.value;
      jsData["term"] = selectedYear.value;
      jsData["year"] = selectedTerm.value;
      (subjectController.text.isNotEmpty && subjectController.text != "Unknown".tr)
          ? jsData["subject_id"] = subjectController.text
          : null;
      (doctorController.text.isNotEmpty && doctorController.text != "Unknown".tr)
          ? jsData["doctor_id"] = double.parse(doctorController.text)
          : null;
      (timeController.text.isNotEmpty && timeController.text != "Unknown".tr)
          ? jsData["lecture_time"] = timeController.text
          : null;
      (durationController.text.isNotEmpty && durationController.text != "Unknown".tr)
          ? jsData["lecture_duration"] = durationController.text
          : null;
      (hallController.text.isNotEmpty && hallController.text != "Unknown".tr )
          ? jsData["lecture_room"] = [hallController.text]
          : null;
    }
    Get.back();
  }

  void popCardClear() {
    subjectController.dispose();
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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/lecture_model/lecture_model.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/services/level_services.dart';
import 'package:ibb_university_students_services/app/services/section_services.dart';
import 'package:ibb_university_students_services/app/services/lecture_services.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/local_lisenter.dart';
import '../../components/custom_text.dart';
import '../../components/custom_text_v2.dart';
import '../../models/helper_models/days_table.dart';
import '../../models/helper_models/result.dart';
import '../../models/subject_model/subject_model.dart';
import '../../services/subject_services.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/screen_utils.dart';
import '../../utils/snake_bar.dart';
import '../../views/lecture_table_tab_view/lecture_table_tab_components/add_and_update_lecture_card.dart';

class LectureController extends GetxController {
  //Lecture main view variables
  RxBool loadState = true.obs;
  TableDays? tableTime;
  RxInt selected = 3.obs;
  RxString selectedDayName = "Sunday".obs;
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  Rx<String?> selectedYear = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  RxString fieldMessage = "".obs;
  List<DropdownMenuItem<int>> sections = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> years = [];
  List<DropdownMenuItem<String>> terms = [
    DropdownMenuItem<String>(
        value: "Term 1",
        child: SizedBox(
            width: (ScreenUtils.isPhoneScreen())
                ? (Get.width / 3.3) * 0.75
                : (Get.width / 6) * 0.6,
            child: SecText(
              "Term 1",
              textColor: AppColors.mainTextColor,
              fontSize: 12,
            ))),
    DropdownMenuItem<String>(
        value: "Term 2",
        child: SizedBox(
            width: (ScreenUtils.isPhoneScreen())
                ? (Get.width / 3.3) * 0.75
                : (Get.width / 6) * 0.6,
            child: SecText(
              "Term 2",
              textColor: AppColors.mainTextColor,
              fontSize: 12,
            ))),
  ];
  Rx<Locale?> currentLocale = Get.locale.obs;

  //Lecture popCard variables
  Map<String, Subject>? subjects;
  Rx<String?> subjectId = Rx(null);
  Rx<int?> doctorId = Rx(null);
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
  bool submitting = false;

  @override
  void onInit() async {
    ever(LocaleListener.currentLocal, (local) async {
      await initSectionDropdownMenuList();
    });
    await initSectionDropdownMenuList();
    await initLevelDropdownMenuList();
    await initYearDropdownMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty)
        ? selectedSection.value = sections.first.value
        : null;
    (years.isNotEmpty) ? selectedYear.value = years.first.value! : null;
    await fetchTableData();
    loadState.value = false;
    super.onInit();
  }

  @override
  void refresh({bool force = true}) async {
    loadState.value = true;
    await fetchTableData(force: force);
    super.refresh();
    loadState.value = false;
  }

  Future<void> fetchTableData({bool force = false}) async {
    if (selectedLevel.value == null) {
      await initLevelDropdownMenuList();
      if(levels.isNotEmpty) {
        selectedLevel.value = levels.first.value;
      }
    }

    if (selectedSection.value == null) {
      await initSectionDropdownMenuList();
      if(sections.isNotEmpty) {
        selectedSection.value = sections.first.value;
      }
    }

    if (selectedYear.value == null) {
      await initYearDropdownMenuList();
      if(years.isNotEmpty) {
        selectedYear.value = years.first.value;
      }
    }

    if (selectedSection.value == null ||
        selectedLevel.value == null ||
        selectedYear.value == null) {
      return;
    }
    Result res = await LectureServices.fetchTableTime(
        sectionId: selectedSection.value!,
        levelId: selectedLevel.value!,
        year: selectedYear.value!,
        term: selectedTerm.value,
        hardFetch: force);
    if (res.statusCode == 200) {
      tableTime = res.data;
    } else if (res.statusCode == 404) {
      tableTime = null;
      fieldMessage.value = "this section and level not has Lectures";
      showSnakeBar(
          title: "Not Found Lectures",
          message: "this section and level doesn't has Lectures ");
    } else {
      tableTime = null;
      fieldMessage.value = "fetching lectures failed please check connection";
      showSnakeBar(
          title: "Fetch Lectures Failed",
          message: "fetching lectures failed please check connection ");
    }
    selected.refresh();
    if(kIsWeb)update(["WebContentBuilder"]);
  }

  void changeDepartment(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
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
    switch (index) {
      case 0:
        selectedDayName.value = "Saturday";
        break;
      case 1:
        selectedDayName.value = "Sunday";
        break;
      case 2:
        selectedDayName.value = "Monday";
        break;
      case 3:
        selectedDayName.value = "Tuesday";
        break;
      case 4:
        selectedDayName.value = "Wednesday";
        break;
      case 5:
        selectedDayName.value = "Thursday";
        break;
      default:
        selectedDayName.value = "";
        break;
    }
  }

  Map<int, Lecture>? selectedDay(int index) {
    switch (index) {
      case 0:
        return tableTime?.sat;
      case 1:
        return tableTime?.sun;
      case 2:
        return tableTime?.mon;
      case 3:
        return tableTime?.tue;
      case 4:
        return tableTime?.wed;
      case 5:
        return tableTime?.thu;
      default:
        return null;
    }
  }

  Future<void> initSectionDropdownMenuList({bool force = false}) async {
    List<Section> sectionsData =
    await SectionServices.fetchSections(hardFetch: force).then((e) => e.data ?? []);
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
  Future<void> initLevelDropdownMenuList({bool force = false}) async {
    List<Level> levelsData =
    await LevelServices.fetchLevels(hardFetch: force).then((e) => e.data ?? []);
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
              width: (ScreenUtils.isPhoneScreen())
                  ? (Get.width / 3.3) * 0.75
                  : (Get.width / 7) * 0.6,
              child: CustomText(
                year,
                style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5Bold),
              ),
            )),
      );
    }
  }

  Future<void> more(String val, {Map<String, dynamic>? data}) async {
    if (val == "Edit") {
      await getSubjects();
      mode = "Edit";
      if (data != null) {
        selectedLecture = data["id"];
        doctorId.value = data["doctor_id"];
        subjectId.value = data["subject"]["subject_id"];
        timeController.text =
            DateTimeUtils.formatStringTime(time: data["lecture_time"]);
        durationController.text = data["duration"].toString();
        hallController.text = data["lecture_room"].toString();
      }
      Get.dialog(const PopUpIAddAndUpdateLectureCard());
    } else if (val == "Delete") {
      if (selectedLevel.value == null) return;
      if (selectedSection.value == null) return;
      if (selectedYear.value == null) return;
      selectedLecture = data?["id"];
      Result<void> res = await LectureServices.deleteLecture(
          sectionId: selectedSection.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName.value,
          id: selectedLecture);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        selectedDay(selected.value)?.remove(selectedLecture);
        selected.refresh();
        showSnakeBar(message: "Delete successfully");
      } else {
        showSnakeBar(message: "Delete failed");
      }
    } else if (val == "TemporaryReplace") {
      await getSubjects();
      mode = "Replace";
      if (data != null) {
        selectedLecture = data["id"];
        doctorId.value = data["doctor_id"];
        subjectId.value = data["subject"]["subject_id"];
        timeController.text =
            DateTimeUtils.formatStringTime(time: data["lecture_time"]);
        durationController.text = data["duration"].toString();
        hallController.text = data["lecture_room"].toString();
      }
      Get.dialog(const PopUpIAddAndUpdateLectureCard());
    } else if (val == "Confirm") {
      selectedLecture = data?["id"];
      if (selectedLecture == null) return;
      Result<void> res = await LectureServices.changeLectureState(
          sectionId: selectedSection.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName.value,
          id: selectedLecture!,
          action: 'confirm');
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        selectedDay(selected.value)?[selectedLecture]?.lectureStatus = true;
        selected.refresh();
        showSnakeBar(message: "Confirm successfully");
      } else {
        showSnakeBar(message: "Confirm failed");
      }
    } else if (val == "Cancel") {
      selectedLecture = data?["id"];
      if (selectedLecture == null) return;
      Result<void> res = await LectureServices.changeLectureState(
          sectionId: selectedSection.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName.value,
          id: selectedLecture!,
          action: 'cancel');
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        selectedDay(selected.value)?[selectedLecture]?.lectureStatus = false;
        selected.refresh();
        showSnakeBar(message: "Cancel successfully");
      } else {
        showSnakeBar(message: "Cancel failed");
      }
    }
  }

  Future<void> addButtonClick() async {
    // doctorId.value = 1000;
    await getSubjects();
    mode = "Add";
    timeController.text = DateTimeUtils.formatTimeOfDay(time: TimeOfDay.now());
    Get.dialog(const PopUpIAddAndUpdateLectureCard());
  }

  void submit() async {
    if (submitting) return;
    submitting = true;
    Map<String, dynamic> jsData = {};
    if (formKey.currentState!.validate()) {
      jsData["lecture_section_id"] = selectedSection.value;
      jsData["lecture_level_id"] = selectedLevel.value;
      jsData["year"] = selectedYear.value ?? "2024";
      jsData["term"] = selectedTerm.value;
      jsData["lecture_day"] = selectedDayName.value;
      ((subjectId.value?.isNotEmpty ?? false) &&
          subjectId.value != "Unknown".tr)
          ? jsData["subject_id"] = subjectId.value
          : null;
      (doctorId.value != null) ? jsData["doctor_id"] = doctorId.value : null;
      (timeController.text.isNotEmpty && timeController.text != "Unknown".tr)
          ? jsData["lecture_time"] = DateTimeUtils.formatStringTime(
          time: timeController.text,
          format: TimeFormat.hhMmSs,
          currentFormat: TimeFormat.hhMmA)
          : null;
      (durationController.text.isNotEmpty &&
          durationController.text != "Unknown".tr)
          ? jsData["lecture_duration"] =
          int.tryParse(durationController.text) ?? 0
          : null;
      (hallController.text.isNotEmpty && hallController.text != "Unknown".tr)
          ? jsData["lecture_room"] = hallController.text
          : null;
    }
    if (mode == "Add") {
      Result<Lecture> res = await LectureServices.createLecture(
          sectionId: selectedSection.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value ?? "2024",
          term: selectedTerm.value,
          day: selectedDayName.value,
          data: jsData);

      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 201 && res.data != null) {
        selectedDay(selected.value)?[res.data!.id] = res.data!;
        selected.refresh();
        showSnakeBar(message: "Add successfully");
      } else {
        showSnakeBar(message: "Add failed");
      }
    } else if (mode == "Edit") {
      if (selectedLecture == null) return;
      Result<Lecture> res = await LectureServices.updateLecture(
          sectionId: selectedSection.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName.value,
          data: jsData,
          id: selectedLecture);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200 && res.data != null) {
        selectedDay(selected.value)?[selectedLecture!] = res.data!;
        selected.refresh();
        showSnakeBar(message: "Edit successfully");
      } else {
        showSnakeBar(message: "Edit failed");
      }
    } else if (mode == "Replace") {
      if (selectedLecture == null) return;
      Result<Lecture> res = await LectureServices.tempReplaceLecture(
          sectionId: selectedSection.value!,
          levelId: selectedLevel.value!,
          year: selectedYear.value!,
          term: selectedTerm.value,
          day: selectedDayName.value,
          data: jsData,
          id: selectedLecture);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200 && res.data != null) {
        selectedDay(selected.value)?.remove(selectedLecture);
        selectedDay(selected.value)?[res.data!.id] = res.data!;
        selected.refresh();
        showSnakeBar(message: "Replace successfully");
      } else {
        showSnakeBar(message: "Replace failed");
      }
    }
    submitting = false;
    popCardClear();
  }

  Future<void> getSubjects() async {
    subjects = {};
    subjects = await SubjectServices.fetchSubjects().then((e) => e.data ?? {});
    if ((subjects?.isNotEmpty ?? false) && subjects?.values.first != null) {
      subjectId = RxString(subjects!.values.first.id);
      if ((subjects?.values.first.instructors?.isNotEmpty ?? false) &&
          subjects?.values.first.instructors?.values.first != null) {
        doctorId.value = subjects?.values.first.instructors?.values.first.id;
      } else {
        doctorId.value = null;
      }
    } else {
      subjectId.value = null;
    }
  }

  void popCardClear() {
    timeController.dispose();
    durationController.dispose();
    hallController.dispose();
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

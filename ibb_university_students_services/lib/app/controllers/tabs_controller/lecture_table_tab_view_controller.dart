import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/lecture_model/lecture_model.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/repositories/lecture_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/local_lisenter.dart';
import '../../components/custom_text_v2.dart';
import '../../models/helper_models/days_table.dart';
import '../../models/helper_models/result.dart';
import '../../models/subject_model/subject_model.dart';
import '../../repositories/level_repository.dart';
import '../../repositories/section_repository.dart';
import '../../repositories/subject_repository.dart';
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
  Map<int, Section> sections = {};
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> years = [];
  List<DropdownMenuItem<String>> terms = [
    DropdownMenuItem<String>(
        value: "Term 1",
        child: SizedBox(
            width: (ScreenUtils.isPhoneScreen())
                ? (((Get.width - 16) / 7) * 2.5) * 0.35
                : (Get.width / 6) * 0.6,
            child: CustomText(
              "1st",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Term 2",
        child: SizedBox(
            width: (ScreenUtils.isPhoneScreen())
                ? (((Get.width - 16) / 7) * 2.5) * 0.35
                : (Get.width / 6) * 0.6,
            child: CustomText(
              "2ec",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
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
    (sections.isNotEmpty) ? selectedSection.value = sections.values.first.id : null;
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
      if (levels.isNotEmpty) {
        selectedLevel.value = levels.first.value;
      }
    }

    if (selectedSection.value == null) {
      await initSectionDropdownMenuList();
      if (sections.isNotEmpty) {
        selectedSection.value = sections.values.first.id;
      }
    }

    if (selectedYear.value == null) {
      await initYearDropdownMenuList();
      if (years.isNotEmpty) {
        selectedYear.value = years.first.value;
      }
    }

    if (selectedSection.value == null ||
        selectedLevel.value == null ||
        selectedYear.value == null) {
      return;
    }
    Result res = await LectureRepository.fetchTableTime(
        sectionId: selectedSection.value!,
        levelId: selectedLevel.value!,
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
    if (kIsWeb) update(["WebContentBuilder"]);
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
     sections =
        await SectionRepository.fetchSections(hardFetch: force)
            .then((e) => e.data??{});
    selectedSection.value = sections.values.first.id;
  }

  Future<void> initLevelDropdownMenuList({bool force = false}) async {
    List<Level> levelsData = await LevelRepository.fetchLevels(hardFetch: force)
        .then((e) => e.data?.values.toList() ?? []);
    // List<String> yearData =
    //     await AppDataServices.fetchLectureYears().then((e) => e.data ?? []);
    levels = [];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? (((Get.width - 16) / 7) * 2.5) * 0.35
                  : (Get.width / 7) * 0.6,
              child: CustomText(
                level.name ?? "unknown",
                style:
                    AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5Bold),
              ),
            )),
      );
    }
    selectedLevel.value = levelsData.first.id;
  }

  Future<void> initYearDropdownMenuList({bool force = false}) async {
    List<String> yearData =
        await LectureRepository.fetchLectureYears(hardFetch: force)
            .then((e) => e.data ?? []);
    years = [];
    for (String year in yearData) {
      years.add(
        DropdownMenuItem(
            value: year,
            child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? (((Get.width - 16) / 7) * 4) * 0.48
                  : (Get.width / 7) * 0.6,
              child: CustomText(
                year,
                style:
                    AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5Bold),
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
      Result<void> res =
          await LectureRepository.deleteLecture(id: selectedLecture);
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
      Result<void> res = await LectureRepository.changeLectureState(
          id: selectedLecture!, action: 'confirm');
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
      Result<void> res = await LectureRepository.changeLectureState(
          id: selectedLecture!, action: 'cancel');
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
    if (formKey.currentState!.validate()) {
      switch (mode) {
        case "Add":
          await _submitAdd();
          break;
        case "Edit":
          await _submitEdit();
          break;
        case "Replace":
          await _submitReplace();
          break;
      }
    }
    submitting = false;
    popCardClear();
  }

  Future<void> _submitAdd() async {
    Result<Lecture> res = await LectureRepository.createLecture(
      sectionId: selectedSection.value!,
      levelId: selectedLevel.value!,
      year: selectedYear.value ?? "2024",
      term: selectedTerm.value,
      day: selectedDayName.value,
      subjectId: subjectId.value!,
      doctorId: doctorId.value!,
      lectureTime: timeController.text,
      lectureDuration: int.tryParse(durationController.text) ?? -999,
      lectureRoom: hallController.text,
    );

    Navigator.of(Get.overlayContext!).pop();
    if (res.statusCode == 201 && res.data != null) {
      selectedDay(selected.value)?[res.data!.id] = res.data!;
      selected.refresh();
      showSnakeBar(message: "Add successfully");
    } else {
      showSnakeBar(message: "Add failed");
    }
  }

  Future<void> _submitEdit() async {
    if (selectedLecture == null) return;
    Result<Lecture> res = await LectureRepository.updateLecture(
        sectionId: selectedSection.value!,
        levelId: selectedLevel.value!,
        year: selectedYear.value ?? "2024",
        term: selectedTerm.value,
        day: selectedDayName.value,
        subjectId: subjectId.value!,
        doctorId: doctorId.value!,
        lectureTime: DateTimeUtils.formatStringTime(
            time: timeController.text,
            format: TimeFormat.hhMmSs,
            currentFormat: TimeFormat.hhMmA),
        lectureDuration: int.tryParse(durationController.text) ?? -999,
        lectureRoom: hallController.text,
        id: selectedLecture);
    Navigator.of(Get.overlayContext!).pop();
    if (res.statusCode == 200 && res.data != null) {
      selectedDay(selected.value)?[selectedLecture!] = res.data!;
      selected.refresh();
      showSnakeBar(message: "Edit successfully");
    } else {
      showSnakeBar(message: "Edit failed");
    }
  }

  Future<void> _submitReplace() async {
    if (selectedLecture == null) return;
    Result<Lecture> res = await LectureRepository.tempReplaceLecture(
        subjectId: subjectId.value!,
        doctorId: doctorId.value!,
        lectureTime: DateTimeUtils.formatStringTime(
            time: timeController.text,
            format: TimeFormat.hhMmSs,
            currentFormat: TimeFormat.hhMmA),
        lectureDuration: int.tryParse(durationController.text) ?? -999,
        lectureRoom: hallController.text,
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

  Future<void> getSubjects() async {
    subjects = {};
    subjects =
        await SubjectRepository.fetchSubjects().then((e) => e.data ?? {});
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
    timeController.clear();
    durationController.clear();
    hallController.clear();
  }

  @override
  void onClose() {
    timeController.dispose();
    durationController.dispose();
    hallController.dispose();
    nameFocus.dispose();
    timeFocus.dispose();
    durationFocus.dispose();
    entryYearFocus.dispose();
    phoneFocus.dispose();
  }
}

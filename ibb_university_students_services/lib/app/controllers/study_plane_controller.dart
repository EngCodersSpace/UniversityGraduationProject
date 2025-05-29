import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/study_plan_elements_model/study_plan_elements.dart';
import 'package:ibb_university_students_services/app/models/study_plan_model/study_plan_model.dart';
import 'package:ibb_university_students_services/app/repositories/study_plane_repository.dart';
import 'package:ibb_university_students_services/app/utils/screen_utils.dart';
import '../components/custom_text_v2.dart';
import '../models/helper_models/result.dart';
import '../models/level_model/level.dart';
import '../models/section_model/section.dart';
import '../models/student_model/student.dart';
import '../repositories/level_repository.dart';
import '../repositories/section_repository.dart';
import '../repositories/user_repository.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';
import '../utils/snake_bar.dart';
import '../views/study_plane/study_plane_view_components/add_study_plan_card.dart';

class StudyPlaneController extends GetxController {
  RxBool loadingState = true.obs;
  RxInt selected = 3.obs;
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedStudyPlan = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  List<String> terms = ["Term 1", "Term 2"];
  RxInt selectedTerm = 0.obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController studyPlaneNameController = TextEditingController();
  FocusNode studyPlaneNameFocus = FocusNode();
  Rx<Map<int, StudyPlanElement>>? studyPlanElement = Rx({});
  Map<int, Section> sections = {};
  Map<int, StudyPlan> studyPlans = {};
  List<DropdownMenuItem<int>> levels = [];
  RxString failedMessage = "Empty".tr.obs;
  String fetchMode = "search";

  List<Border> borders = [];

  @override
  void onInit() async {
    await StudyPlanRepository.openBox();
    await initLevelDropdownMenuLists();
    await initSectionDropdownMenuList();
    await initStudyPlansDropdownMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    if (UserRepository.currentUserType() == Student) {
      selectedStudyPlan.value = await UserRepository.fetchUser()
          .then((e) => (e.data as Student).studyPlane?.id);
      fetchMode = "self";
    }
    await fetchStudyPlaneData();

    BorderSide borderSide =
        BorderSide(color: AppColors.inverseCardColor, width: 1.0);
    borders = [
      Border(
        top: borderSide,
        right: borderSide,
        bottom: borderSide,
      ),
      Border(
        top: borderSide,
        left: borderSide,
        bottom: borderSide,
      ),
    ];

    super.onInit();
    loadingState.value = false;
  }

  @override
  void refresh() async {
    await fetchStudyPlaneData();
    super.refresh();
  }

  Future<void> fetchStudyPlaneData() async {
    if (selectedStudyPlan.value == null) return;
    Result res = await StudyPlanRepository.fetchStudyPlanElements(
        studyPlanId: selectedStudyPlan.value!, mode: "mode");
    if (res.statusCode == 200) {
      studyPlanElement?.value = res.data;
    } else if (res.statusCode == 404) {
      studyPlanElement?.value = {};
      failedMessage.value = "Not Found";
      showSnakeBar(
          title: "Not Found Grads", message: "this user has not grads");
    } else {
      failedMessage.value = "fetching grads failed please check connection";
      showSnakeBar(
          title: "Fetch Grads Failed",
          message: "fetching grads failed please check connection ");
    }
    studyPlanElement?.refresh();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
  }

  void changeDepartment(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
    await fetchStudyPlaneData();
  }

  void changeSelectedSortDirection(int? val) async {
    if (val == null) return;
    selectedTerm.value = val;
  }

  Future<void> initSectionDropdownMenuList({bool force = false}) async {
    sections = await SectionRepository.fetchSections(hardFetch: force)
        .then((e) => e.data ?? {});
    if (sections.isNotEmpty) {
      selectedSection.value = sections.values.first.id;
    }
  }

  Future<void> initStudyPlansDropdownMenuList({bool force = false}) async {
    studyPlans = await StudyPlanRepository.fetchStudyPlans(hardFetch: force)
        .then((e) => e.data ?? {});
    if (studyPlans.isNotEmpty) {
      selectedStudyPlan.value = studyPlans.values.first.id;
    }
  }

  Future<void> initLevelDropdownMenuLists() async {
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
  }

  void addStudyPlan() {
    if (studyPlaneNameController.text == "") return;
    Get.back();
  }

  void newButtonClick() {
    // if (!UserRepository.checkPermission(
    //     target: "study_plan", action: "write")) {
    //   showSnakeBar(
    //       title: "Unauthorizes Access",
    //       message: "you don't have permission for search student grads");
    //   return;
    // }
    Get.dialog(PopUpAddStudyPlanCard());
    fetchStudyPlaneData();
  }

  Future<void> more(String val, {Map<String, dynamic>? data}) async {
    // if (val == "Edit") {
    //   await getSubjects();
    //   mode = "Edit";
    //   if (data != null) {
    //     selectedLecture = data["id"];
    //     doctorId.value = data["doctor_id"];
    //     subjectId.value = data["subject"]["subject_id"];
    //     timeController.text =
    //         DateTimeUtils.formatStringTime(time: data["lecture_time"]);
    //     durationController.text = data["duration"].toString();
    //     hallController.text = data["lecture_room"].toString();
    //   }
    //   Get.dialog(const PopUpIAddAndUpdateLectureCard());
    // } else if (val == "Delete") {
    //   if (selectedLevel.value == null) return;
    //   if (selectedSection.value == null) return;
    //   selectedLecture = data?["id"];
    //   Result<void> res =
    //   await LectureRepository.deleteLecture(id: selectedLecture);
    //   Navigator.of(Get.overlayContext!).pop();
    //   if (res.statusCode == 200) {
    //     selectedDay(selected.value)?.remove(selectedLecture);
    //     selected.refresh();
    //     showSnakeBar(message: "Delete successfully");
    //   } else {
    //     showSnakeBar(message: "Delete failed");
    //   }
    // } else if (val == "TemporaryReplace") {
    //   await getSubjects();
    //   mode = "Replace";
    //   if (data != null) {
    //     selectedLecture = data["id"];
    //     doctorId.value = data["doctor_id"];
    //     subjectId.value = data["subject"]["subject_id"];
    //     timeController.text =
    //         DateTimeUtils.formatStringTime(time: data["lecture_time"]);
    //     durationController.text = data["duration"].toString();
    //     hallController.text = data["lecture_room"].toString();
    //   }
    //   Get.dialog(const PopUpIAddAndUpdateLectureCard());
    // } else if (val == "Confirm") {
    //   selectedLecture = data?["id"];
    //   if (selectedLecture == null) return;
    //   Result<void> res = await LectureRepository.changeLectureState(
    //       id: selectedLecture!, action: 'confirm');
    //   Navigator.of(Get.overlayContext!).pop();
    //   if (res.statusCode == 200) {
    //     selectedDay(selected.value)?[selectedLecture]?.lectureStatus = true;
    //     selected.refresh();
    //     showSnakeBar(message: "Confirm successfully");
    //   } else {
    //     showSnakeBar(message: "Confirm failed");
    //   }
    // } else if (val == "Cancel") {
    //   selectedLecture = data?["id"];
    //   if (selectedLecture == null) return;
    //   Result<void> res = await LectureRepository.changeLectureState(
    //       id: selectedLecture!, action: 'cancel');
    //   Navigator.of(Get.overlayContext!).pop();
    //   if (res.statusCode == 200) {
    //     selectedDay(selected.value)?[selectedLecture]?.lectureStatus = false;
    //     selected.refresh();
    //     showSnakeBar(message: "Cancel successfully");
    //   } else {
    //     showSnakeBar(message: "Cancel failed");
    //   }
    // }
  }

  bool checkShowStudyPlanElements(StudyPlanElement e) {
    return (e.levelId == selectedLevel.value) &&
        (e.sectionId == selectedSection.value) &&
        (e.term == terms[selectedTerm.value]);
  }

  @override
  void onClose() async {
    await StudyPlanRepository.clearBox();
  }
}

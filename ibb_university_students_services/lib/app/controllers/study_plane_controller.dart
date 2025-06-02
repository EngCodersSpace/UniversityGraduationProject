import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/study_plan_elements_model/study_plan_elements.dart';
import 'package:ibb_university_students_services/app/models/study_plan_model/study_plan_model.dart';
import 'package:ibb_university_students_services/app/repositories/study_plane_repository.dart';
import 'package:printing/printing.dart';
import '../models/helper_models/result.dart';
import '../models/level_model/level.dart';
import '../models/section_model/section.dart';
import '../models/student_model/student.dart';
import '../models/subject_model/subject_model.dart';
import '../repositories/level_repository.dart';
import '../repositories/section_repository.dart';
import '../repositories/subject_repository.dart';
import '../repositories/user_repository.dart';
import '../services/printing/print_study_plan.dart';
import '../styles/app_colors.dart';
import '../utils/snake_bar.dart';
import '../views/study_plane/study_plane_view_components/add_and_update_study_plan_card.dart';
import '../views/study_plane/study_plane_view_components/add_study_plan_card.dart';

class StudyPlaneController extends GetxController {
  RxBool loadingState = true.obs;
  RxInt? selected;

  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedStudyPlan = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  List<String> terms = ["Term 1", "Term 2"];
  RxInt selectedTerm = 0.obs;
  Map<String, Subject>? subjects;
  Rx<String?> subjectId = Rx(null);
  Rx<int?> doctorId = Rx(null);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController studyPlaneNameController = TextEditingController();
  FocusNode studyPlaneNameFocus = FocusNode();
  Rx<Map<int, StudyPlanElement>>? studyPlanElement = Rx({});
  Map<int, Section> sections = {};
  Map<int, StudyPlan> studyPlans = {};
  Map<int, Level> levels = {};
  RxString failedMessage = "Empty".tr.obs;
  String fetchMode = "search";
  List<Border> borders = [];

  String mode = "Add";

  @override
  void onInit() async {
    await StudyPlanRepository.openBox();
    await initLevelDropdownMenuLists();
    await initSectionDropdownMenuList();
    await initStudyPlansDropdownMenuList();
    await getSubjects();
    (levels.isNotEmpty) ? selectedLevel.value = levels.values.first.id : null;
    if (UserRepository.currentUserType() == Student) {
      Student user = await UserRepository.fetchUser()
          .then((e) => (e.data as Student));
      selectedStudyPlan.value = user.studyPlane?.id;
      selectedSection.value = user.section?.id;
      fetchMode = "self";
    }

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

    await fetchStudyPlaneData();
    loadingState.value = false;
    super.onInit();
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

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchStudyPlaneData();
  }

  void changeDepartment(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
    await fetchStudyPlaneData();
  }

  void changeStudyPlane(int? val) async {
    if (val == null) return;
    selectedStudyPlan.value = val;
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
    levels = await LevelRepository.fetchLevels().then((e) => e.data ?? {});
  }

  void addStudyPlan() async {
    if (studyPlaneNameController.text == "") return;
    Result<StudyPlan> res = await StudyPlanRepository.createStudyPlan(
        name: studyPlaneNameController.text);
    Navigator.of(Get.overlayContext!).pop();
    if (res.statusCode == 201 && res.data != null) {
      studyPlans[res.data!.id] = res.data!;
      Get.back();
    }
  }

  void addStudyPlanElement() async {
    if (selectedStudyPlan.value == null) return;
    if (selectedLevel.value == null) return;
    if (selectedSection.value == null) return;
    if (subjectId.value == null) return;
    if (doctorId.value == null) return;
    Result<StudyPlanElement> res =
        await StudyPlanRepository.createStudyPlanElement(
            studyPlanId: selectedStudyPlan.value!,
            sectionId: selectedSection.value!,
            levelId: selectedLevel.value!,
            term: terms[selectedTerm.value],
            doctorId: doctorId.value!,
            subjectId: subjectId.value!);
    Navigator.of(Get.overlayContext!).pop();
    if (res.statusCode == 201 && res.data != null) {
      studyPlanElement?.value[res.data!.id] = res.data!;
      studyPlanElement?.refresh();
      Get.back();
    }
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

  void printButtonClick() async {
    final pdfData = await generateStudyPlanPdfFromElements(
      studyPlanName: studyPlans[selectedStudyPlan.value]?.name ?? "",
      studyPlanId: selectedStudyPlan.value??-1,
      sectionName: sections[selectedSection.value]?.name ?? "",
      elements: (studyPlanElement?.value.values
              .where((e) => (e.sectionId == selectedSection.value)) ??
          []).toList(),
    );

    await Printing.layoutPdf(onLayout: (_) => pdfData);
  }

  Future<void> more(String val, {Map<String, dynamic>? data}) async {
    if (data != null) {
      selected ??= RxInt(0);
      selected?.value = data["id"];
      selectedStudyPlan.value = data["studyPlaneId"];
      selectedSection.value = data["sectionId"];
      selectedLevel.value = data["levelId"];
      selectedTerm.value = terms.indexOf(data["term"]);
      doctorId.value = data["doctorId"];
      subjectId.value = data["subject"]["subject_id"];
    }
    if (val == "Edit") {
      await getSubjects();
      mode = "Edit";
      await Get.dialog(const PopUpIAddAndUpdateStudyPlanCard());
      if (selected?.value == null) return;
      if (selectedStudyPlan.value == null) return;
      if (selectedLevel.value == null) return;
      if (selectedSection.value == null) return;
      if (subjectId.value == null) return;
      if (doctorId.value == null) return;
      Result<StudyPlanElement> res =
          await StudyPlanRepository.updateStudyPlanElement(
              id: selected!.value,
              studyPlanId: selectedStudyPlan.value!,
              sectionId: selectedSection.value!,
              levelId: selectedLevel.value!,
              term: terms[selectedTerm.value],
              doctorId: doctorId.value!,
              subjectId: subjectId.value!);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200 && res.data != null) {
        studyPlanElement?.value[res.data!.id] = res.data!;
        studyPlanElement?.refresh();
        showSnakeBar(title: "Successful", message: "Update successfully");
      } else {
        showSnakeBar(title: "Failed", message: "Update failed");
      }
    } else if (val == "Delete") {
      if (selected?.value == null) return;
      Result<void> res = await StudyPlanRepository.deleteStudyPlanElement(
        id: selected!.value,
      );
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        studyPlanElement?.value.remove(selected?.value);
        studyPlanElement?.refresh();
        showSnakeBar(title: "Successful", message: "Delete successfully");
      } else {
        showSnakeBar(title: "Failed", message: "Delete failed");
      }
    }
  }

  bool checkShowStudyPlanElements(StudyPlanElement e) {
    return (e.levelId == selectedLevel.value) &&
        (e.sectionId == selectedSection.value) &&
        (e.term == terms[selectedTerm.value]);
  }

  void addButtonClick() {
    Get.dialog(PopUpIAddAndUpdateStudyPlanCard());
  }

  @override
  void onClose() async {
    await StudyPlanRepository.clearBox();
  }
}

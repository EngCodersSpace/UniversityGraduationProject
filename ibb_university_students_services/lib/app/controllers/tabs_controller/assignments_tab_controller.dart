import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/services/assignments_services.dart';
import 'package:ibb_university_students_services/app/services/subject_services.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import '../../models/assignment_model/assignment_model.dart';
import '../../models/helper_models/result.dart';
import '../../models/level_model/level.dart';
import '../../models/section_model/section.dart';
import '../../models/subject_model/subject_model.dart';
import '../../services/level_services.dart';
import '../../services/section_services.dart';
import '../../utils/screen_utils.dart';
import '../../utils/snake_bar.dart';

class AssignmentsTabController extends GetxController {
  RxBool loadingState = true.obs;
  RxInt selected = 3.obs;
  RxString fieldMessage = "".obs;
  Rx<int?> selectedDepartment = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  Rx<String?> selectedSubject = Rx(null);
  List<DropdownMenuItem<String>> subjectsItems = [];
  List<DropdownMenuItem<String>> selectedSubjectsItems = [];
  List<DropdownMenuItem<int>> sections = [];
  List<DropdownMenuItem<int>> levels = [];
  Rx<Map<int, Assignment>>? assignments = Rx({});
  Rx<List<PlatformFile>>? selectedAttachments = Rx([]);

  @override
  void onInit() async {
    // await initSectionDropdownMenuList();
    // (years.isNotEmpty) ? selectedYear.value = years.first.value! : null;
    await initSectionDropdownMenuList();
    await initLevelDropdownMenuList();
    await initSubjectDropdownMenuList();
    await fetchAssignmentsData();
    super.onInit();
    loadingState.value = false;
  }

  @override
  void refresh() async{
    await initSectionDropdownMenuList();
    await initLevelDropdownMenuList();
    await initSubjectDropdownMenuList();
    await fetchAssignmentsData(force: true);
    super.refresh();
  }

  Future<void> fetchAssignmentsData({bool force = false}) async {
    if (selectedSubject.value == null) {
      await initSubjectDropdownMenuList();
    }
    if (selectedSubject.value == null) {
      return;
    }
    Result res = await AssignmentsServices.fetchFakeAssignments(
        subjectId: selectedSubject.value!, hardFetch: force);
    if (res.statusCode == 200) {
      assignments?.value = {};
      assignments?.value = res.data ?? {};
    } else if (res.statusCode == 404) {
      assignments?.value = res.data ?? {};
      fieldMessage.value = "this section and level not has Assignments";
      showSnakeBar(
          title: "Not Found Assignments ",
          message: "this section and level doesn't has assignments ");
    } else {
      fieldMessage.value = "fetching assignments failed please check connection";
      showSnakeBar(
          title: "Fetch Assignments Failed",
          message: "fetching assignments failed please check connection ");
    }
  }


  void changeDepartment(int? val) async {
    if (val == null) return;
    selectedDepartment.value = val;
    await fetchAssignmentsData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchAssignmentsData();
  }

  void changeSubject(String? val) async {
    if (val == null) return;
    selectedSubject.value = val;
    await fetchAssignmentsData();
  }


  Future<void> initSectionDropdownMenuList({bool force = false}) async {
    List<Section> sectionsData =
    await SectionServices.fetchSections(hardFetch: force)
        .then((e) => e.data ?? []);
    sections = [];
    for (Section section in sectionsData) {
      sections.add(
        DropdownMenuItem<int>(
            value: section.id,
            child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? (Get.width/3)-30
                  : (Get.width / 5.5) * 0.6,
              child: CustomText(
                section.name ?? "unknown",
                style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5Bold,),
              ),
            )),
      );
    }
    selectedDepartment = RxInt(sectionsData.first.id);
  }

  Future<void> initLevelDropdownMenuList({bool force = false}) async {
    List<Level> levelsData = await LevelServices.fetchLevels(hardFetch: force)
        .then((e) => e.data?? []);
    levels = [];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? (Get.width / 4)-30
                  : (Get.width / 8) * 0.6,
              child: CustomText(
                level.name ?? "unknown",
                style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5Bold,),
              ),
            )),
      );
    }
    selectedLevel = RxInt(levelsData.first.id);
  }

  Future<void> initSubjectDropdownMenuList() async {
    List<String> subjectsIds =
        await AssignmentsServices.fetchFakeAssignmentsSubjects()
            .then((e) => e.data ?? []);
    subjectsItems = [];
    selectedSubjectsItems = [];
    for (String id in subjectsIds) {
      Subject? subject =
          await SubjectServices.fetchSubject(id: id).then((e) => e.data);
      if (subject != null) {
        subjectsItems.add(
          DropdownMenuItem<String>(
              value: id,
              child: CustomText(
                subject.subjectName ?? "unknown".tr,
                style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Normal),
              )),
        );
        selectedSubjectsItems.add(DropdownMenuItem<String>(
          value: id,
          child: SizedBox(
            width: (Get.width/3)-30,
            child: CustomText(
              subject.subjectName ?? "",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Bold),
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
        ));
      }
    }

    selectedSubject = RxString(subjectsIds.first);
  }

  void uploadAttachments(){

  }

  Future<void> pickFiles() async {
    // Open file picker dialog
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      selectedAttachments?.value.addAll(result.files);
    } else {
      // User canceled the picker
      if (kDebugMode) {
        print('No file selected');
      }
    }
  }

  void more(String val, {Map<String, dynamic>? data}) async {
    if (val == "Edit") {
      // mode = "Edit";
      // if (data != null) {
      //   selectedExam = data["exam_id"];
      //   subjects = {};
      //   subjects =
      //   await SubjectServices.fetchSubjects().then((e) => e.data ?? {});
      //   subject = RxString(data["subject"]["subject_id"]);
      //   dateController.text = data["exam_date"].toString();
      //   timeController.text =
      //       DateTimeUtils.formatStringTime(time: data["exam_time"]);
      //   day.value = data["exam_day"].toString();
      //   hallController.text = data["exam_room"].toString();
      // }
      // Get.dialog(const PopUpIAddAndUpdateExamCard());
    } else if (val == "Delete") {
      // if (selectedLevel.value == null) return;
      // if (selectedSection.value == null) return;
      // selectedExam = data?["exam_id"];
      // Result<void> res = await ExamServices.deleteExam(
      //     sectionId: selectedSection.value!,
      //     levelId: selectedLevel.value!,
      //     id: selectedExam);
      // Get.back();
      // if (res.statusCode == 200) {
      //   exams?.value.remove(selectedExam);
      //   exams?.refresh();
      //   showSnakeBar(message: "Delete successfully");
      // } else {
      //   showSnakeBar(message: "Delete failed");
      // }
    }
  }

  void addButtonClick() async {
    // mode = "Add";
    // dateController.text = DateTime.now().toString().split(" ")[0];
    // timeController.text = DateTimeUtils.formatTimeOfDay(time:TimeOfDay.now());
    // subjects = {};
    // subjects = await SubjectServices.fetchSubjects().then((e) => e.data ?? {});
    // if (subjects?.values.first != null) {
    //   subject = RxString(subjects!.values.first.id);
    // }
    // Get.dialog(const PopUpIAddAndUpdateExamCard());
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/repositories/assignments_repository.dart';
import 'package:ibb_university_students_services/app/services/http_provider/http_provider.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';
import 'package:ibb_university_students_services/app/views/assignments_tab_view/assignments_view_components/add_and_update_assignments_card.dart';
import '../../models/assignment_model/assignment_model.dart';
import '../../models/helper_models/result.dart';
import '../../models/level_model/level.dart';
import '../../models/section_model/section.dart';
import '../../models/subject_model/subject_model.dart';
import '../../repositories/level_repository.dart';
import '../../repositories/section_repository.dart';
import '../../repositories/subject_repository.dart';
import '../../services/notification_services/notification_services.dart';
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
  Rx<List<PlatformFile>>? attachmentsFiles = Rx([]);

  TextEditingController dueDateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode dueDateFocus = FocusNode();
  FocusNode hallFocus = FocusNode();
  String mode = "Add";
  int? selectedAssignment;

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
  void refresh() async {
    await fetchAssignmentsData(force: true);
    super.refresh();
  }

  Future<void> fetchAssignmentsData({bool force = false}) async {
    if (selectedSubject.value == null) {
      await initSubjectDropdownMenuList();
    }
    if (selectedLevel.value == null) {
      await initLevelDropdownMenuList();
      if (levels.isNotEmpty) {
        selectedLevel.value = levels.first.value;
      }
    }
    if (selectedDepartment.value == null) {
      await initSectionDropdownMenuList();
      if (sections.isNotEmpty) {
        selectedDepartment.value = sections.first.value;
      }
    }

    // if (selectedYear.value == null) {
    //   await initYearDropdownMenuList();
    //   if(years.isNotEmpty) {
    //     selectedYear.value = years.first.value;
    //   }
    // }

    if (selectedDepartment.value == null ||
        selectedLevel.value == null ||
        selectedSubject.value == null) {
      return;
    }

    Result res = await AssignmentsRepository.fetchAssignmentsGroup(
      subjectId: selectedSubject.value!,
      sectionId: selectedDepartment.value!,
      levelId: selectedLevel.value!,
      year: '',
      hardFetch: force,
    );
    print(res.data);
    if (res.statusCode == 200) {
      assignments?.value = res.data ?? {};
    } else if (res.statusCode == 404) {
      assignments?.value = res.data ?? {};
      fieldMessage.value = "this section and level not has Assignments";
      showSnakeBar(
          title: "Not Found Assignments ",
          message: "this section and level doesn't has assignments ");
    } else {
      fieldMessage.value =
          "fetching assignments failed please check connection";
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
        await SectionRepository.fetchSections(hardFetch: force)
            .then((e) => e.data ?? []);
    sections = [];
    for (Section section in sectionsData) {
      sections.add(
        DropdownMenuItem<int>(
            value: section.id,
            child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? (Get.width / 3) - 30
                  : (Get.width / 5.5) * 0.6,
              child: CustomText(
                section.name ?? "unknown",
                style: AppTextStyles.mainStyle(
                  textHeader: AppTextHeaders.h5Bold,
                ),
              ),
            )),
      );
    }
    selectedDepartment = RxInt(sectionsData.first.id);
  }

  Future<void> initLevelDropdownMenuList({bool force = false}) async {
    List<Level> levelsData = await LevelRepository.fetchLevels(hardFetch: force)
        .then((e) => e.data ?? []);
    levels = [];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? (Get.width / 4) - 30
                  : (Get.width / 8) * 0.6,
              child: CustomText(
                level.name ?? "unknown",
                style: AppTextStyles.mainStyle(
                  textHeader: AppTextHeaders.h5Bold,
                ),
              ),
            )),
      );
    }
    selectedLevel = RxInt(levelsData.first.id);
  }

  Future<void> initSubjectDropdownMenuList() async {
    List<Subject> subjects = await SubjectRepository.fetchSubjects()
        .then((e) => e.data?.values.toList() ?? []);
    subjectsItems = [];
    selectedSubjectsItems = [];
    for (Subject subj in subjects) {
      subjectsItems.add(
        DropdownMenuItem<String>(
            value: subj.id,
            child: CustomText(
              subj.subjectName ?? "unknown".tr,
              style:
                  AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Normal),
            )),
      );
      selectedSubjectsItems.add(DropdownMenuItem<String>(
        value: subj.id,
        child: SizedBox(
          width: (Get.width / 3) - 30,
          child: CustomText(
            subj.subjectName ?? "",
            style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Bold),
            textAlign: TextAlign.center,
            softWrap: false,
          ),
        ),
      ));
    }
    if (subjects.isNotEmpty) {
      selectedSubject = RxString(subjects.first.id);
    }
  }

  void uploadAttachments() {
    for (PlatformFile file in (attachmentsFiles?.value ?? [])) {
      HttpProvider.uploadFileWithProgress(
              file: file, uploadUrl: "upload-files-assignment-doctor")
          .then((val) {
        if (val?.statusCode == 200) {
          NotificationHandler().showNotification(
              uniqueId: file.identifier.hashCode,
              title: "${file.name} uploaded successfully!");
        } else {
          NotificationHandler().showNotification(
              uniqueId: file.identifier.hashCode,
              title: "${file.name} upload failed!",
              body: '');
        }
      });
    }
  }

  Future<void> pickFiles() async {
    // Open file picker dialog
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      attachmentsFiles?.value.addAll(result.files);
      attachmentsFiles?.refresh();
    } else {
      // User canceled the picker
      if (kDebugMode) {
        print('No file selected');
      }
    }
  }

  void more(String val, {Map<String, dynamic>? data}) async {
    selectedAssignment = data?["assignment_id"];
    print(selectedAssignment);
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
      Result<void> res = await AssignmentsRepository.deleteAssignment(
        sectionId: selectedDepartment.value!,
        levelId: selectedLevel.value!,
        subjectId: selectedSubject.value!,
        id: selectedAssignment,
      );
      Get.back();
      if (res.statusCode == 200) {
        assignments?.value.remove(selectedAssignment);
        assignments?.refresh();
        showSnakeBar(message: "Delete successfully");
      } else {
        showSnakeBar(message: "Delete failed");
      }
    } else if (val == "DeleteFile") {
      if(data == null)return;
      attachmentsFiles?.value.removeAt(data["index"]);
      attachmentsFiles?.refresh();
      // assignments?.value[selectedAssignment];
    } else if (val == "reUploadFile") {}
  }

  void addButtonClick() async {
    mode = "Add";
    if (selectedLevel.value == null) {
      showSnakeBar(message: "Select Level First");
      return;
    }
    if (selectedDepartment.value == null) {
      showSnakeBar(message: "Select Program First");
      return;
    }
    if (selectedSubject.value == null) {
      showSnakeBar(message: "Select Subject First");
      return;
    }
    // dateController.text = DateTime.now().toString().split(" ")[0];
    // timeController.text = DateTimeUtils.formatTimeOfDay(time:TimeOfDay.now());
    // subjects = {};
    // subjects = await SubjectServices.fetchSubjects().then((e) => e.data ?? {});
    // if (subjects?.values.first != null) {
    //   subject = RxString(subjects!.values.first.id);
    // }
    Get.dialog(const PopUpIAddAndUpdateAssignmentsCard());
  }

  void submit() async {
    Map<String, dynamic> jsData = {};
    // "subject_id": "absconditu",
    // "title": "controll6",
    // "assignment_due_day": "Monday",
    // "assignment_date": "2024-11-10",
    // "assignments_due_date": "2025-01-05",
    // "section_id":1,
    // "level_id":1
    if (formKey.currentState!.validate()) {
      jsData["section_id"] = selectedDepartment.value;
      jsData["level_id"] = selectedLevel.value;
      jsData["subject_id"] = selectedSubject.value;
      jsData["assignment_date"] = DateTime.now().toString();
      jsData["assignment_due_day"] = "Sunday";

      (dueDateController.text.isNotEmpty &&
              dueDateController.text != "Unknown".tr)
          ? jsData["assignments_due_date"] = dueDateController.text
          : null;
      (titleController.text.isNotEmpty && titleController.text != "Unknown".tr)
          ? jsData["title"] = titleController.text
          : null;
    }

    if (mode == "Add") {
      Result<Assignment> res = await AssignmentsRepository.createAssignment(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          subjectId: selectedSubject.value!,
          data: jsData);
      Navigator.of(Get.overlayContext!).pop();
      print(res?.data);
      print(res?.statusCode);
      print(res?.message);
      if (res.statusCode == 201 && res.data != null) {
        assignments?.value[res.data!.id] = res.data!;
        assignments?.refresh();
        showSnakeBar(message: "Add successfully");
      } else {
        showSnakeBar(message: "Add failed");
      }
    } else if (mode == "Edit") {
      // Result<Exam> res = await ExamRepository.updateExam(
      //     sectionId: selectedSection.value!,
      //     levelId: selectedLevel.value!,
      //     data: jsData,
      //     id: selectedExam);
      // Navigator.of(Get.overlayContext!).pop();
      // if (res.statusCode == 200 && res.data != null) {
      //   exams?.value[res.data!.id] = res.data!;
      //   exams?.refresh();
      //   showSnakeBar(message: "Edit successfully");
      // } else {
      //   showSnakeBar(message: "Edit failed");
      // }
    }
  }
}

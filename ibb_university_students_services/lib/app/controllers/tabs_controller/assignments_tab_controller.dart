import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/pop_up_cards/loading_card.dart';
import 'package:ibb_university_students_services/app/models/attachment_file_model/attachment_file_model.dart';
import 'package:ibb_university_students_services/app/repositories/assignments_repository.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/file_utils.dart';
import 'package:ibb_university_students_services/app/views/assignments_tab_view/assignments_view_components/add_and_update_assignments_card.dart';
import 'package:ibb_university_students_services/app/views/assignments_tab_view/assignments_view_components/show_files_card.dart';
import '../../models/assignment_model/assignment_model.dart';
import '../../models/helper_models/result.dart';
import '../../models/helper_models/student_assignment_state/student_assignment_state.dart';
import '../../models/level_model/level.dart';
import '../../models/section_model/section.dart';
import '../../models/student_model/student.dart';
import '../../models/subject_model/subject_model.dart';
import '../../repositories/level_repository.dart';
import '../../repositories/section_repository.dart';
import '../../repositories/subject_repository.dart';
import '../../utils/permission_checker.dart';
import '../../utils/screen_utils.dart';
import '../../utils/snake_bar.dart';
import '../../views/assignments_tab_view/assignments_view_components/add_files_card.dart';
import '../../views/assignments_tab_view/assignments_view_components/assignment_student_list.dart';

class AssignmentsTabController extends GetxController {
  RxBool loadingState = true.obs;
  RxString fieldMessage = "".obs;
  Rx<int?> selectedDepartment = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  Rx<String?> selectedSubject = Rx(null);
  List<DropdownMenuItem<String>> subjectsItems = [];
  List<DropdownMenuItem<String>> selectedSubjectsItems = [];
  Map<int, Section> sections = {};
  List<DropdownMenuItem<int>> levels = [];
  RxList<Map<String, int>> groups = RxList();
  Rx<Map<int, Assignment>>? assignments = Rx({});
  RxBool addToMultiGroup = false.obs;

  TextEditingController dueDateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode dueDateFocus = FocusNode();
  FocusNode hallFocus = FocusNode();
  String mode = "Add";
  int? selectedAssignment;
  int? selectedStudent;

  @override
  void onInit() async {
    // await initSectionDropdownMenuList();
    // (years.isNotEmpty) ? selectedYear.value = years.first.value! : null;
    if (!(PermissionUtils.checkPermission(
        target: "Assignments", action: "doctorView"))) {
      Student? student =
          await UserRepository.fetchUser().then((e) => e.data as Student);
      selectedDepartment.value = student?.section?.id;
      selectedLevel.value = student?.level?.id;
    }
    await initSectionDropdownMenuList();
    await initLevelDropdownMenuList();
    await initSubjectDropdownMenuList();
    await fetchAssignmentsData();
    super.onInit();
    loadingState.value = false;
  }

  @override
  void refresh() async {
    loadingState.value = true;
    await fetchAssignmentsData(force: true);
    super.refresh();
    loadingState.value = false;
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
        selectedDepartment.value = sections.values.first.id;
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

  void changeAddToMultiGroup(bool? val) async {
    if (val == null) return;
    addToMultiGroup.value = val;
  }

  Future<void> initSectionDropdownMenuList({bool force = false}) async {
    sections = await SectionRepository.fetchSections(hardFetch: force)
        .then((e) => e.data ?? {});
    selectedDepartment = RxInt(sections.values.first.id);
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

  void uploadAssignmentsFiles() async {
    if (selectedLevel.value == null) return;
    if (selectedDepartment.value == null) return;
    for (AttachmentFile file in (assignments
            ?.value[selectedAssignment]?.attachments?.values
            .toList() ??
        [])) {
      if (file.path == null || file.id > 0) {
        continue;
      }
      int? oldId = file.id;
      await AssignmentsRepository.uploadAttachment(
              attachment: file,
              sectionId: selectedDepartment.value!,
              levelId: selectedLevel.value!)
          .then((e) {
        assignments?.value[selectedAssignment]?.attachments?[file.id] = file;
        assignments?.value[selectedAssignment]?.attachments?.remove(oldId);
      });
    }
  }

  Future<void> pickFiles() async {
    // Open file picker dialog
    Get.dialog(const PopUpLoadingCard());
    FilePickerResult? result;
    try {
      assignments?.value[selectedAssignment]?.attachments ??= {};
      result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        readSequential: true,
      );
    } catch (e) {
      showSnakeBar(message: "Loading Files Failed");
    }
    Navigator.of(Get.overlayContext!).pop();
    if (result != null) {
      bool exist = false;
      for (int i = 0; i < result.count; i++) {
        AttachmentFile file = AttachmentFile(
            id: -result.files[i].name.hashCode,
            title: result.files[i].name,
            path: result.files[i].path,
            assignmentId: selectedAssignment,
            status: RxString("Not Uploaded"));
        file.downloaded.value = true;

        assignments?.value[selectedAssignment]?.attachments?.forEach((i, e) {
          exist = (e.path?.split("/").last == file.path?.split("/").last);
        });
        if (!exist) {
          assignments?.value[selectedAssignment]?.attachments?[file.id] = file;
        } else {
          showSnakeBar(message: "This File Already Exist");
        }
      }
      update(["AttachmentPiker"]);
    } else {
      // User canceled the picker
      if (kDebugMode) {
        print('No file selected');
      }
    }
  }

  void openFile(String? path) async {
    await FileUtils.openFile(path);
  }

  void downloadAttachment() {}

  void more(String val, {Map<String, dynamic>? data}) async {
    selectedAssignment = data?["assignment_id"];
    if (val == "Edit") {
      mode = "Edit";
      titleController.text =
          assignments?.value[selectedAssignment]?.title ?? "";
      dueDateController.text =
          assignments?.value[selectedAssignment]?.dueDate ?? "";
      Get.dialog(const PopUpIAddAndUpdateAssignmentsCard());
    } else if (val == "Delete") {
      Result<void> res = await AssignmentsRepository.deleteAssignment(
        sectionId: selectedDepartment.value!,
        levelId: selectedLevel.value!,
        subjectId: selectedSubject.value!,
        id: selectedAssignment,
      );
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        assignments?.value.remove(selectedAssignment);
        assignments?.refresh();
        showSnakeBar(message: "Delete successfully");
      } else {
        showSnakeBar(message: "Delete failed");
      }
    } else if (val == "DeleteFile") {
      if (data == null) return;
      if (data["id"] < 0) {
        assignments?.value[selectedAssignment]?.attachments?.remove(data["id"]);
        update(["AttachmentPiker"]);
      } else {
        Result res = await AssignmentsRepository.deleteAssignmentFile(
            assignmentId: selectedAssignment!, id: data["id"]);
        Navigator.of(Get.overlayContext!).pop();
        if (res.statusCode == 200) {
          assignments?.value[selectedAssignment]?.attachments
              ?.remove(data["id"]);
          update(["AttachmentPiker"]);
        } else {
          showSnakeBar(message: "Delete File Failed");
        }
      }
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
    groups.value = [];
    addGroup(selectedDepartment.value!, selectedLevel.value!);
    Get.dialog(const PopUpIAddAndUpdateAssignmentsCard());
  }

  void addGroup(int sectionId, int levelId) {
    if (groups.any((map) =>
        map["section_id"] == sectionId && map["level_id"] == levelId)) {
      showSnakeBar(message: "Group Already Exists");
      return;
    }
    groups.add(
      {"section_id": sectionId, "level_id": levelId},
    );
  }

  void delGroup(int index) {
    groups.removeAt(index);
  }

  void submit() async {
    Map<String, dynamic> jsData = {};
    if (formKey.currentState!.validate()) {
      jsData["language"] = Get.locale?.languageCode ?? "en";
      jsData["assignment_due_day"] = "Sunday";
      jsData["assignments_due_date"] = dueDateController.text;
      jsData["title"] = titleController.text;

      if (mode == "Add") {
        jsData["sectionsAndLevels"] = groups;
        jsData["subject_id"] = selectedSubject.value;
        jsData["assignment_date"] = DateTime.now().toString();
        Result<Assignment> res = await AssignmentsRepository.createAssignment(
            sectionId: selectedDepartment.value!,
            levelId: selectedLevel.value!,
            subjectId: selectedSubject.value!,
            data: jsData);
        Navigator.of(Get.overlayContext!).pop();
        if (res.statusCode == 201 && res.data != null) {
          assignments?.value[res.data!.id] = res.data!;
          assignments?.refresh();
          showSnakeBar(message: "Add successfully");
        } else {
          showSnakeBar(message: "Add failed");
        }
      } else if (mode == "Edit") {
        jsData["assignment_id"] = selectedAssignment;
        Result<Assignment> res = await AssignmentsRepository.updateAssignment(
            sectionId: selectedDepartment.value!,
            levelId: selectedLevel.value!,
            subjectId: selectedSubject.value!,
            data: jsData,
            id: selectedAssignment!);
        Navigator.of(Get.overlayContext!).pop();
        if (res.statusCode == 200 && res.data != null) {
          assignments?.value[res.data!.id] = res.data!;
          assignments?.refresh();
          showSnakeBar(message: "Edit successfully");
        } else {
          showSnakeBar(message: "Edit failed");
        }
      }
    }
  }

  void showAttachmentsFiles(int? assignmentId) {
    selectedAssignment = assignmentId;
    if ((PermissionUtils.checkPermission(
        target: "Assignments", action: "doctorView"))) {
      Get.dialog(AssignmentsAddFilesCard());
    }else{
      Get.dialog(AssignmentsShowFilesCard());
    }
  }

  void showStudentFiles({int? studentId}) {
    selectedStudent = studentId;
    if ((PermissionUtils.checkPermission(
        target: "Assignments", action: "doctorView"))) {
      Get.dialog(AssignmentsShowFilesCard());
    }else{
      Get.dialog(AssignmentsAddFilesCard());
    }
  }

  void routeStudentList(int? assignmentId) async {
    if (assignmentId == null) return;
    List<StudentAssignmentState>? items =
        await AssignmentsRepository.fetchAssignmentStudents(
                assignmentId: assignmentId)
            .then((e) => e.data);
    Get.to(AssignmentStudentList(
      items: items ?? [],
    ));
  }
}

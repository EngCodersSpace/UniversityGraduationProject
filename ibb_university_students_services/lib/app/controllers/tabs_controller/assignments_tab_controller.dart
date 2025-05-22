import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/pop_up_cards/loading_card.dart';
import 'package:ibb_university_students_services/app/models/attachment_file_model/attachment_file_model.dart';
import 'package:ibb_university_students_services/app/models/student_assignments_file_model/student_assignments_file_model.dart';
import 'package:ibb_university_students_services/app/repositories/assignments_repository.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/file_utils.dart';
import 'package:ibb_university_students_services/app/views/assignments_tab_view/assignments_view_components/add_and_update_assignments_card.dart';
import 'package:ibb_university_students_services/app/views/assignments_tab_view/assignments_view_components/show_files_card.dart';
import '../../models/assignment_model/assignment_model.dart';
import '../../models/doctor_model/doctor.dart';
import '../../models/helper_models/result.dart';
import '../../models/helper_models/student_assignment_state/student_assignment_state.dart';
import '../../models/level_model/level.dart';
import '../../models/section_model/section.dart';
import '../../models/student_model/student.dart';
import '../../models/subject_model/subject_model.dart';
import '../../repositories/level_repository.dart';
import '../../repositories/section_repository.dart';
import '../../repositories/subject_repository.dart';
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
  Rx<String?> selectedYear = Rx(null);
  Map<String, Subject>? subjects;
  List<DropdownMenuItem<String>> selectedSubjectsItems = [];
  Map<int, Section> sections = {};
  List<String> years = [];
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
  String fetchMode = "doctor";
  int? selectedAssignment;
  int? selectedState;

Future<void> setStudentSectionAndLevel()async{
  Student? student =
      await UserRepository.fetchUser().then((e) => e.data as Student);
  selectedDepartment.value = student?.section?.id;
  selectedLevel.value = student?.level?.id;
}
  @override
  void onInit() async {
    // await initSectionDropdownMenuList();
    // (years.isNotEmpty) ? selectedYear.value = years.first.value! : null;

    await initSectionDropdownMenuList();
    await initLevelDropdownMenuList();
    await initSubjectDropdownMenuList();
    await initYears();
    if (UserRepository.currentUserType() == Student) {
      await setStudentSectionAndLevel();
      fetchMode = "student";
    }
    await fetchAssignmentsData();
    super.onInit();
    loadingState.value = false;
  }

  @override
  void refresh({bool force = true}) async {
    loadingState.value = true;
    await fetchAssignmentsData(force: force);
    super.refresh();
    loadingState.value = false;
  }

  Future<void> fetchAssignmentsData({bool force = false}) async {
    if (selectedSubject.value == null) {
      await initSubjectDropdownMenuList();
      if (subjects?.values.isNotEmpty??false) {
        selectedSubject.value = subjects?.values.first.id;
      }
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

    if(fetchMode=="student"){
      await setStudentSectionAndLevel();
    }

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
    } else if (res.statusCode == 204) {
      assignments?.value = res.data ?? {};
      fieldMessage.value = "Empty";
      showSnakeBar(
          title: "Not Found Assignments ",
          message: "selected choose doesn't has assignments ");
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

  void changeYear(String? val) {
    if (val == null) return;
    selectedYear.value = val;
    fetchAssignmentsData();
  }

  Future<void> initSectionDropdownMenuList({bool force = false}) async {
    sections = await SectionRepository.fetchSections(hardFetch: force)
        .then((e) => e.data ?? {});
  }

  Future<void> initLevelDropdownMenuList({bool force = false}) async {
    List<Level> levelsData = await LevelRepository.fetchLevels(hardFetch: force)
        .then((e) => e.data?.values.toList() ?? []);
    levels = [];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (ScreenUtils.isPhoneScreen())
                  ? (Get.width / 5) - 30
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
  }

  Future<void> initSubjectDropdownMenuList() async {
    subjects = {};
    subjects =
    await SubjectRepository.fetchSubjects().then((e) => e.data ?? {});
    if ((subjects?.isNotEmpty ?? false) && subjects?.values.first != null) {
      selectedSubject = RxString(subjects!.values.first.id);
    } else {
      selectedSubject.value = null;
    }
  }

  Future<void> initYears() async {
    years = [];
    years =
    await AssignmentsRepository.fetchAssignmentYears().then((e)=>e.data??[]);
    if (years.isNotEmpty) {
      selectedYear = RxString(subjects!.values.first.id);
    } else {
      selectedYear.value = null;
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
      await AssignmentsRepository.uploadAttachmentFiles(
              attachment: file,
              sectionId: selectedDepartment.value!,
              levelId: selectedLevel.value!)
          .then((e) {
        assignments?.value[selectedAssignment]?.attachments?[file.id] = file;
        assignments?.value[selectedAssignment]?.attachments?.remove(oldId);
      });
    }
  }

  void uploadStudentAssignmentsFiles() async {
    if (selectedLevel.value == null) return;
    if (selectedDepartment.value == null) return;
    if (selectedAssignment == null) return;
    for (StudentAssignmentsFile file in (assignments?.value[selectedAssignment]!
            .studentsStatus?[selectedState]?.studentFiles?.values
            .toList() ??
        [])) {
      if (file.path == null || file.id > 0) {
        continue;
      }
      int? oldId = file.id;
      await AssignmentsRepository.uploadStudentAssignmentsFiles(
              files: file,
              assignmentId: selectedAssignment!,
              sectionId: selectedDepartment.value!,
              levelId: selectedLevel.value!)
          .then((e) {
        assignments?.value[selectedAssignment]!.studentsStatus?[selectedState]
            ?.studentFiles?[file.id] = file;
        assignments?.value[selectedAssignment]!.studentsStatus?[selectedState]
            ?.studentFiles
            ?.remove(oldId);
      });
    }
  }

  Future<void> pickAttachmentFiles() async {
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
            originName: result.files[i].name,
            path: result.files[i].path,
            assignmentId: selectedAssignment,
            status: RxString("Not Uploaded"));
        if(kIsWeb){
          file.downloaded.value = false;
        }else{
          file.downloaded.value = true;
        }


        assignments?.value[selectedAssignment]?.attachments?.forEach((i, e) {
          exist = (e.originName == file.originName);
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

  Future<void> pickStudentAssignmentsFiles() async {
    // Open file picker dialog
    Get.dialog(const PopUpLoadingCard());
    FilePickerResult? result;
    try {
      assignments?.value[selectedAssignment]?.studentsStatus?.values.first
          .studentFiles ??= {};
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
        StudentAssignmentsFile file = StudentAssignmentsFile(
            id: -result.files[i].name.hashCode,
            originName: result.files[i].name,
            path: result.files[i].path,
            studentAssignmentId: assignments?.value[selectedAssignment]
                ?.studentsStatus?[selectedState]?.studentId,
            status: RxString("Not Uploaded"));
        file.downloaded.value = true;

        assignments?.value[selectedAssignment]?.studentsStatus?.values.first
            .studentFiles
            ?.forEach((i, e) {
          exist = (e.path?.split("/").last == file.path?.split("/").last);
        });
        if (!exist) {
          assignments?.value[selectedAssignment]?.studentsStatus?.values.first
              .studentFiles?[file.id] = file;
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

  void openFile(int id,String? path) async {
    if(id>0){
      await FileUtils.openFile(path);
    }else{
      await FileUtils.openFile(path,baseFolderPath: "");
    }
  }

  void downloadAssignmentFile(AttachmentFile file) async{
    await AssignmentsRepository.downloadAttachmentFiles(file: file);
  }

  void downloadStudentAssignmentFile(StudentAssignmentsFile file) {
    if (selectedLevel.value == null) return;
    if (selectedDepartment.value == null) return;
    AssignmentsRepository.downloadStudentAssignmentsFiles(
        file: file,
        sectionId: selectedDepartment.value!,
        levelId: selectedLevel.value!);
  }

  void _moreEdit(Map<String, dynamic>? data) {
    selectedAssignment = data?["assignment_id"];
    mode = "Edit";
    titleController.text = assignments?.value[selectedAssignment]?.title ?? "";
    dueDateController.text =
        assignments?.value[selectedAssignment]?.dueDate ?? "";
    Get.dialog(const PopUpIAddAndUpdateAssignmentsCard());
  }

  void _moreDelete(Map<String, dynamic>? data) async {
    selectedAssignment = data?["assignment_id"];
    Result<void> res = await AssignmentsRepository.deleteAssignment(
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
  }

  void _moreDeleteAttachmentFile(Map<String, dynamic>? data) async {
    if (data == null) return;
    if (data["id"] < 0) {
      assignments?.value[selectedAssignment]?.attachments?.remove(data["id"]);
      update(["AttachmentPiker"]);
    } else {
      Result res = await AssignmentsRepository.deleteAssignmentFile(
          assignmentId: selectedAssignment!, id: data["id"]);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        assignments?.value[selectedAssignment]?.attachments?.remove(data["id"]);
        update(["AttachmentPiker"]);
      } else {
        showSnakeBar(message: "Delete File Failed");
      }
    }
  }

  void _moreDeleteAttachmentFileFromStorage(Map<String, dynamic>? data) async {
    if (data == null) return;
    bool res = await FileUtils.deleteFile(filePath: assignments?.value[selectedAssignment]?.attachments?[data["id"]]?.path);
    if(res){
      showSnakeBar(message: "File Deleted");
      await assignments?.value[selectedAssignment]?.attachments?[data["id"]]?.checkDownloaded();
    }
  }

  void _moreDeleteStudentAssignmentFile(Map<String, dynamic>? data) async {
    if (data == null) return;
    if (data["id"] < 0) {
      assignments?.value[selectedAssignment]?.studentsStatus?[selectedState]
          ?.studentFiles
          ?.remove(data["id"]);
      update(["AttachmentPiker"]);
    } else {
      Result res = await AssignmentsRepository.deleteAssignmentFile(
          assignmentId: selectedAssignment!, id: data["id"]);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        assignments?.value[selectedAssignment]?.studentsStatus?[selectedState]
            ?.studentFiles
            ?.remove(data["id"]);
        update(["AttachmentPiker"]);
      } else {
        showSnakeBar(message: "Delete File Failed");
      }
    }
  }

  void _moreDeleteStudentAssignmentFileFromStorage(Map<String, dynamic>? data) async {
    if (data == null) return;
    if (data["id"] < 0) {
      showSnakeBar(message: "File not Store Yet");
    } else {
      bool res = await FileUtils.deleteFile(filePath: assignments?.value[selectedAssignment]?.studentsStatus?[selectedState]
          ?.studentFiles?[data["id"]]?.path);
      if(res){
        showSnakeBar(message: "File Deleted");
        await assignments?.value[selectedAssignment]?.studentsStatus?[selectedState]
            ?.studentFiles?[data["id"]]?.checkDownloaded();
      }
      }
    }


  void _moreSetCompletion(bool stat, Map<String, dynamic>? data) async {
    if (data?["assignment_id"] == null) return;
    if (((data?["studentsStatus"] ?? {}) as Map).isEmpty) return;
    int? studentId =
        ((data?["studentsStatus"] ?? {}) as Map<int, StudentAssignmentState>)
            .values
            .first
            .studentId;
    int? statId =
        ((data?["studentsStatus"] ?? {}) as Map<int, StudentAssignmentState>)
            .values
            .first
            .id;
    if (studentId == null) return;
    if (statId == null) return;
    Result res = await AssignmentsRepository.changeStudentCompletion(
        id: data!["assignment_id"],
        studentId: studentId,
        stateId: statId,
        state: stat);
    Navigator.of(Get.overlayContext!).pop();
    if (res.statusCode == 200) {
      assignments?.value[data["assignment_id"]]?.studentsStatus?[statId]
          ?.isCompleted = stat;
      assignments?.refresh();
    }
  }

  void more(String val, {Map<String, dynamic>? data}) async {
    switch (val) {
      case "Edit":
        _moreEdit(data);
        break;
      case "Delete":
        _moreDelete(data);
        break;
      case "DeleteAttachmentFile":
        _moreDeleteAttachmentFile(data);
        break;
        case "DeleteAttachmentFileFromStorage":
        _moreDeleteAttachmentFileFromStorage(data);
        break;
      case "DeleteStudentAssignmentFileFromStorage":
        _moreDeleteStudentAssignmentFileFromStorage(data);
        break;
      case "DeleteStudentAssignmentFile":
        _moreDeleteStudentAssignmentFile(data);
        break;
      case "reUploadFile":
        break;
      case "setComplete":
        _moreSetCompletion(true, data);
        break;
      case "setNotComplete":
        _moreSetCompletion(false, data);
        break;
    }
  }

  void changeState(String val, int? studentId, int? statusId) async {
    if (studentId == null) return;
    if (statusId == null) return;
    if (selectedAssignment == null) return;
    if (val == "Accept") {
      Result res = await AssignmentsRepository.changeStudentState(
          id: selectedAssignment!,
          studentId: studentId,
          stateId: statusId,
          state: "accept");
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        assignments?.value[selectedAssignment]?.studentsStatus?[statusId]
            ?.state = "accept";
        update(["statusTextBuilder"]);
      }
    } else if (val == "Reject") {
      Result res = await AssignmentsRepository.changeStudentState(
          id: selectedAssignment!,
          studentId: studentId,
          stateId: statusId,
          state: "reject");
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        assignments?.value[selectedAssignment]?.studentsStatus?[statusId]
            ?.state = "reject";
        update(["statusTextBuilder"]);
      }
    }
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
      if (mode == "Add") {
        Result<Assignment> res = await AssignmentsRepository.createAssignment(
          sectionId: selectedDepartment.value!,
          levelId: selectedLevel.value!,
          subjectId: selectedSubject.value!,
          title: titleController.text,
          assignmentDate: DateTime.now().toString(),
          assignmentsDueDate: dueDateController.text,
          sectionsAndLevels: groups,
        );
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
            title: titleController.text,
            assignmentDate: DateTime.now().toString(),
            assignmentsDueDate: dueDateController.text,
            sectionsAndLevels: groups,
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

  void showAttachmentsFiles(int? assignmentId) async {
    selectedAssignment = assignmentId;
    for (AttachmentFile file
    in assignments?.value[selectedAssignment]?.attachments?.values ??
        []) {
      await file.checkDownloaded();
    }
    if (UserRepository.currentUserType() == Doctor) {
      Get.dialog(AssignmentsAddFilesCard());
    } else {
      Get.dialog(AssignmentsShowFilesCard());
    }
  }

  void showStudentFiles(int? assignmentId, {int? stateId}) async {
    selectedAssignment = assignmentId;
    selectedState = stateId;
    for (StudentAssignmentsFile file in assignments?.value[selectedAssignment]
            ?.studentsStatus?[selectedState]?.studentFiles?.values ??
        []) {
      await file.checkDownloaded();
    }
    if (UserRepository.currentUserType() == Doctor) {
      Get.dialog(AssignmentsShowFilesCard());
    } else {
      Get.dialog(AssignmentsAddFilesCard());
    }
  }

  void routeStudentList(int? assignmentId) async {
    selectedAssignment = assignmentId;
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

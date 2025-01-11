import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/models/assignment_model.dart';
import 'package:ibb_university_students_services/app/services/assignments_services.dart';
import 'package:ibb_university_students_services/app/services/subject_services.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import '../../models/result.dart';
import '../../models/subject_model.dart';
import '../../utils/snake_bar.dart';

class AssignmentsTabController extends GetxController {
  RxBool loadingState = true.obs;
  RxInt selected = 3.obs;
  RxString fieldMessage = "".obs;
  Rx<String?> selectedSubject = Rx(null);
  List<DropdownMenuItem<String>> subjectsItems = [];
  List<DropdownMenuItem<String>> selectedSubjectsItems = [];
  Rx<Map<int, Assignment>>? assignments = Rx({});

  @override
  void onInit() async {
    // await initSectionDropdownMenuList();
    // (years.isNotEmpty) ? selectedYear.value = years.first.value! : null;
    await initSubjectDropdownMenuList();
    await fetchAssignmentsData();
    super.onInit();
    loadingState.value = false;
  }

  @override
  void refresh() async{
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

  void changeSubject(String? val) async {
    if (val == null) return;
    selectedSubject.value = val;
    await fetchAssignmentsData();
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
                style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h4),
              )),
        );
        selectedSubjectsItems.add(DropdownMenuItem<String>(
          value: id,
          child: SizedBox(
            width: Get.width*0.55,
            child: CustomText(
              subject.subjectName ?? "",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3),
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
        ));
      }
    }

    selectedSubject = RxString(subjectsIds.first);
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

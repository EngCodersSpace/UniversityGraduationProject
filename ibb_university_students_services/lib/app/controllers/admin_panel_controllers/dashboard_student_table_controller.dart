// ignore: implementation_imports
import 'dart:async';

import 'package:flutter/src/widgets/editable_text.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';

class DashboardStudentTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  RxMap<int, Student> student = RxMap({});
  RxInt availableRows = 0.obs;
  RxString fieldMessage = "".obs;
  RxBool loadingState = true.obs;
  Timer? _debounce;

  @override
  void onInit() {
    //
    super.onInit();
  }

  Future<void> fetchStudentData({bool showSnakeBars = true}) async {
    Result res = await UserRepository.fetchDashboardStudent();
    if (res.statusCode == 200) {
      student.value = res.data["students"];
      availableRows.value = res.data["totalStudent"] ?? 0;
    } else if (res.statusCode == 404) {
      student.value = {};
      availableRows.value = 0;
      fieldMessage.value = "this section and level not has Lectures";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Lectures",
            message: "this section and level doesn't has Lectures ");
      }
    } else {
      student.value = {};
      availableRows.value = res.data["totalLectures"] ?? 0;
      fieldMessage.value = "fetching lectures failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Lectures Failed",
            message: "fetching lectures failed please check connection ");
      }
    }
    update(["DataTable"]);
  }

  @override
  void export() {}

  @override
  void import() {}

  String prevTxt = "";

  @override
  void onSearch() {
    if (searchController.text == prevTxt) return;
    prevTxt = searchController.text;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 600), () async {
      await fetchStudentData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void onClose() {
    //
    super.onClose();
  }
}

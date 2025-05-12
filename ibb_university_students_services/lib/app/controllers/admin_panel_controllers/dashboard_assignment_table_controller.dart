import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';

class DashboardAssignmentTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool loadingstate = true.obs;
  Timer? _debounce;

  @override
  void onInit() async {
    searchController.addListener(() => onSearch());
    await fetchAssignmentData();
    loadingstate.value = false;
    super.onInit();
  }

  @override
  void refresh() async {
    await fetchAssignmentData();
    super.refresh();
  }

  Future<void> fetchAssignmentData() async {}

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
      await fetchAssignmentData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/repositories/level_repository.dart';
import 'package:ibb_university_students_services/app/repositories/section_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

class DashboardGradTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  RxBool loadingState = true.obs;
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedTerm = "".obs;
  RxString selectedOrder = "subject_id".obs;
  RxString selectedSort = "DESC".obs;
  Timer? _debounce;
  List<DropdownMenuItem<int>> sections = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> term = [
    DropdownMenuItem<String>(
        value: "",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "All",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Term 1",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "1st",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Term 2",
        child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "2ec",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
  ];
  List<DropdownMenuItem<String>> orderBy = [
    DropdownMenuItem<String>(
        value: "student_id",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Student",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "subject_id",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Subject",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    // DropdownMenuItem<String>(
    //     value: "lecture_room",
    //     child: SizedBox(
    //         width: (Get.width / 8) * 0.6,
    //         child: CustomText(
    //           "Lecture Room",
    //           style: AppTextStyles.mainStyle(
    //             textHeader: AppTextHeaders.h6Bold,
    //           ),
    //         ))),
    // DropdownMenuItem<String>(
    //     value: "subject_id",
    //     child: SizedBox(
    //         width: (Get.width / 8) * 0.6,
    //         child: CustomText(
    //           "Subject",
    //           style: AppTextStyles.mainStyle(
    //             textHeader: AppTextHeaders.h6Bold,
    //           ),
    //         ))),
  ];
  List<DropdownMenuItem<String>> sort = [
    DropdownMenuItem<String>(
        value: "DESC",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Descending",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "ASC",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Ascending",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
  ];
  @override
  // ignore: unnecessary_overrides
  void onInit() async {
    searchController.addListener(() {
      onSearch();
    });
    await initLevelDashboardMenuList();
    await initSectionDashboardMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty) ? selectedSection.value = sections.first.value : null;
    await fetchGradData();
    loadingState.value = false;
    super.onInit();
  }

  @override
  void refresh() async {
    await fetchGradData();
  }

  Future<void> fetchGradData({bool showSnakeBars = true}) async {
    if (selectedLevel.value == null) {
      await initLevelDashboardMenuList();
      if (levels.isNotEmpty) {
        selectedLevel.value = levels.first.value;
      }
    }

    if (selectedSection.value == null) {
      await initSectionDashboardMenuList();
      if (sections.isNotEmpty) {
        selectedSection.value = sections.first.value;
      }
    }

    if (selectedLevel.value == null || selectedSection.value == null) {
      return;
    }
  }

  void changeSection(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
    await fetchGradData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchGradData();
  }

  void changeTerm(String? val) async {
    if (val == null) return;
    selectedTerm.value = val;
    fetchGradData();
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchGradData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchGradData();
  }

  Future<void> initSectionDashboardMenuList({bool force = false}) async {
    Map<int, Section> sectionsData =
        await SectionRepository.fetchSections(hardFetch: force)
            .then((e) => e.data ?? {});
    sections = [
      DropdownMenuItem<int>(
          value: 0,
          child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "All",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h6Bold),
            ),
          )),
    ];
    for (Section section in sectionsData.values.toList()) {
      sections.add(
        DropdownMenuItem<int>(
            value: section.id,
            child: SizedBox(
              width: (Get.width / 6) * 0.5,
              child: CustomText(
                section.name ?? "unknown",
                style:
                    AppTextStyles.mainStyle(textHeader: AppTextHeaders.h6Bold),
              ),
            )),
      );
    }
    selectedSection.value = sectionsData.values.first.id;
  }

  Future<void> initLevelDashboardMenuList({bool force = false}) async {
    List<Level> levelsData = await LevelRepository.fetchLevels(hardFetch: force)
        .then((e) => e.data ?? []);
    levels = [
      DropdownMenuItem<int>(
          value: 0,
          child: SizedBox(
            width: (Get.width / 8) * 0.4,
            child: CustomText(
              "All",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h6Bold),
            ),
          )),
    ];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (Get.width / 8) * 0.4,
              child: CustomText(
                level.name ?? "unknown",
                style:
                    AppTextStyles.mainStyle(textHeader: AppTextHeaders.h6Bold),
              ),
            )),
      );
    }
    selectedLevel.value = levelsData.first.id;
  }

  Future<void> addClick() async {}
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
      await fetchGradData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void onClose() {}
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_text_v2.dart';
import '../../models/helper_models/result.dart';
import '../../models/lecture_model/lecture_model.dart';
import '../../models/level_model/level.dart';
import '../../models/section_model/section.dart';
import '../../repositories/lecture_repository.dart';
import '../../repositories/level_repository.dart';
import '../../repositories/section_repository.dart';
import '../../styles/text_styles.dart';
import '../../utils/snake_bar.dart';

class DashbordLectureTableController extends GetxController {
  Lecture? lecture;
  RxString fieldMessage = "".obs;
  RxString searchFild = "".obs;
  RxBool lodingState = true.obs;
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  RxString selectedOrder = "".obs;
  RxString selectedSort = "".obs;
  List<DropdownMenuItem<int>> sections = [];
  List<DropdownMenuItem<int>> levels = [];
  List<DropdownMenuItem<String>> term = [
    DropdownMenuItem<String>(
        value: "Term 1",
        child: SizedBox(
            width: (Get.width / 6) * 0.6,
            child: CustomText(
              "1st",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "Term 2",
        child: SizedBox(
            width: (Get.width / 6) * 0.6,
            child: CustomText(
              "2ec",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
  ];
  List<DropdownMenuItem<String>> orderby = [
    DropdownMenuItem<String>(
        value: "lecture_time",
        child: SizedBox(
            width: (Get.width / 6) * 0.6,
            child: CustomText(
              "Lecture Time",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "lecture_day",
        child: SizedBox(
            width: (Get.width / 6) * 0.6,
            child: CustomText(
              "Lecture Day",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "lecture_room",
        child: SizedBox(
            width: (Get.width / 6) * 0.6,
            child: CustomText(
              "Lecture Room",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "subject_id",
        child: SizedBox(
            width: (Get.width / 6) * 0.6,
            child: CustomText(
              "Subject",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
  ];
  List<DropdownMenuItem<String>> sort = [
    DropdownMenuItem<String>(
        value: "DESC",
        child: SizedBox(
            width: (Get.width / 6) * 0.6,
            child: CustomText(
              "Descending",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "ASC",
        child: SizedBox(
            width: (Get.width / 6) * 0.6,
            child: CustomText(
              "Ascending",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h5Bold,
              ),
            ))),
  ];

  @override
  void onInit() async {
    await initSectionDashboardMenuList();
    await initLevelDashboardMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty) ? selectedSection.value = sections.first.value : null;
    await fetchDashboardData();
    lodingState.value = false;
    super.onInit();
  }

  void refesh() async {
    await fetchDashboardData();
  }

  Future fetchDashboardData() async {
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

    if (selectedSection.value == null || selectedLevel.value == null) {
      return;
    }

    Result res = await LectureRepository.fetchDashboardLecture(
        sectionId: selectedSection.value!,
        levelId: selectedLevel.value!,
        term: selectedTerm.value,
        order: selectedOrder.value,
        sort: selectedSort.value,
        hardFetch: false);
    if (res.statusCode == 200) {
      lecture = res.data;
    } else if (res.statusCode == 404) {
      lecture = null;
      fieldMessage.value = "this section and level not has Lectures";
      showSnakeBar(
          title: "Not Found Lectures",
          message: "this section and level doesn't has Lectures ");
    } else {
      lecture = null;
      fieldMessage.value = "fetching lectures failed please check connection";
      showSnakeBar(
          title: "Fetch Lectures Failed",
          message: "fetching lectures failed please check connection ");
    }
  }

  void changeSection(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
    await fetchDashboardData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchDashboardData();
  }

  Future<void> initSectionDashboardMenuList({bool force = false}) async {
    List<Section> sectionsData =
        await SectionRepository.fetchSections(hardFetch: force)
            .then((e) => e.data ?? []);
    sections = [];
    for (Section section in sectionsData) {
      sections.add(
        DropdownMenuItem<int>(
            value: section.id,
            child: SizedBox(
              width: (Get.width / 7) * 0.6,
              child: CustomText(
                section.name ?? "unknown",
                style:
                    AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5Bold),
              ),
            )),
      );
    }
    selectedSection.value = sectionsData.first.id;
  }

  Future<void> initLevelDashboardMenuList({bool force = false}) async {
    List<Level> levelsData = await LevelRepository.fetchLevels(hardFetch: force)
        .then((e) => e.data ?? []);
    levels = [];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (Get.width / 7) * 0.6,
              child: CustomText(
                level.name ?? "unknown",
                style:
                    AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5Bold),
              ),
            )),
      );
    }
    selectedLevel.value = levelsData.first.id;
  }

  @override
  void onClose() {}
}

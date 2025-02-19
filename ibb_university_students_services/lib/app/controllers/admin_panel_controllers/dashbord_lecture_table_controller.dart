import 'dart:async';

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
import 'header_of_view_controller_interface.dart';

class DashboardLectureTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));

  double get height => Get.height;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxMap<int, Lecture> lectures = RxMap({});
  RxSet<int> selectedRows = RxSet({});
  RxInt availableRows = 0.obs;
  int currentPage = 1;
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  RxString fieldMessage = "".obs;
  RxBool loadingState = true.obs;
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedTerm = "Term 1".obs;
  RxString selectedOrder = "lecture_time".obs;
  RxString selectedSort = "DESC".obs;
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
        value: "lecture_time",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Lecture Time",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "lecture_day",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Lecture Day",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "lecture_room",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Lecture Room",
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
  List<DataColumn> kTableColumn = [];
  ScrollController horizontal = ScrollController();
  ScrollController vertical = ScrollController();
  RxBool selectAll = false.obs;
  Timer? _debounce;

  @override
  void onInit() async {
    searchController.addListener(() {
      onSearch();
    });

    kTableColumn = <DataColumn>[
      DataColumn(
        label: Obx(() => Checkbox(
              value: selectAll.value,
              onChanged: (isSelected) {
                if (isSelected == null) return;
                selectAll.value = isSelected;
              },
            )),
      ),
      DataColumn(
        label: CustomText(
          "Lecture ID",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        numeric: true,
      ),
      DataColumn(
          label: CustomText(
        "Subject",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
        label: CustomText(
          "Doctor ID",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Duration",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        // numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Start Time",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        // numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Hall",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
        // numeric: true,
      ),
      DataColumn(
        label: CustomText(
          "Decsription",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
    ];
    await initSectionDashboardMenuList();
    await initLevelDashboardMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty) ? selectedSection.value = sections.first.value : null;
    await fetchDashboardData();
    loadingState.value = false;
    super.onInit();
    // filteredlectures.assignAll(lectures);
  }

  @override
  void refresh() async {
    await fetchDashboardData();
  }

  void onRowChange(int? value) async {
    if (value != null) {
      rowsPerPage.value = value;
      await fetchDashboardData();
      update(["DataTable"]);
    }
  }

  Future<void> fetchDashboardData({bool showSnakeBars = true}) async {
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
        sectionId: (selectedSection.value == 0) ? null : selectedSection.value,
        levelId: (selectedLevel.value == 0) ? null : selectedLevel.value,
        term: (selectedTerm.value == "") ? "" : selectedTerm.value,
        order: selectedOrder.value,
        limit: rowsPerPage.value,
        sort: selectedSort.value,
        page: currentPage,
        search: searchController.text,
        hardFetch: false);
    if (res.statusCode == 200) {
      lectures.value = res.data["lectures"] ?? {};
      availableRows.value = res.data["totalLectures"];
      update(["DataTable"]);
    } else if (res.statusCode == 404) {
      lectures.value = {};
      fieldMessage.value = "this section and level not has Lectures";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Lectures",
            message: "this section and level doesn't has Lectures ");
      }
    } else {
      lectures.value = {};
      fieldMessage.value = "fetching lectures failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Lectures Failed",
            message: "fetching lectures failed please check connection ");
      }
    }
  }

  void onPageChange(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchDashboardData();
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

  void changeTerm(String? val) async {
    if (val == null) return;
    selectedTerm.value = val;
    fetchDashboardData();
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchDashboardData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchDashboardData();
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

  @override
  TextEditingController searchController = TextEditingController(text: "");

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
      await fetchDashboardData();
    });
  }

  void addLecture() {}

  @override
  void onClose() {
    searchController.dispose();
  }
}

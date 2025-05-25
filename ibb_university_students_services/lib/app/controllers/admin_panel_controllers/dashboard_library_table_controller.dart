import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/library_files_model/library_files_model.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/models/subject_model/subject_model.dart';
import 'package:ibb_university_students_services/app/repositories/level_repository.dart';
import 'package:ibb_university_students_services/app/repositories/library_repository.dart';
import 'package:ibb_university_students_services/app/repositories/section_repository.dart';
import 'package:ibb_university_students_services/app/repositories/subject_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/library_table_view/library_table_component/add_library_table_card.dart';

class DashboardLibraryTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  RxMap<int, LibraryFile> library = RxMap({});
  RxString faildMessage = "".obs;
  RxSet<int> selectedRows = RxSet({});
  RxInt availableRows = 0.obs;
  ScrollController vertical = ScrollController();
  ScrollController horizontal = ScrollController();
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  int currentPage = 1;
  RxBool selectAll = false.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool loadingstate = true.obs;
  Rx<int?> selectedSection = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedTerm = "".obs;
  RxString selectedOrder = "id".obs;
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
        value: "id",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "ID",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "edition",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Edition",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "added_by",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Added By",
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
  Timer? _debounce;

  //popup card component
  Map<String, Subject> subjects = {};
  Map<int, Section> section = <int, Section>{}.obs;
  Map<int, RxBool> level = {};
  String mode = "add";
  Rx<String?> subjectId = Rx(null);
  Rx<int?> sectionId = Rx(null);
  Rx<int?> levelId = Rx(null);
  RxString? selectedAddSubjectId;
  Rx<int?> selectedCategory = Rx(0);
  List<String> categories = [
    "Lecture",
    "Reference",
    "Exams Forms",
  ];
  List<PlatformFile> selectedFiles = [];
  RxList<Map<String, int>> groups = RxList();
  RxMap<String, RxMap<int, LibraryFile>> books = RxMap();

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
        "ID",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Section",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Level",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Title",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Author",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "pages",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Edation",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Category",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Size",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Path",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Image",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Added By",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Subject id",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
      DataColumn(
          label: CustomText(
        "Name",
        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      )),
    ];
    await initLevelDashboardMenuList();
    await initSectionDashboardMenuList();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty) ? selectedSection.value = sections.first.value : null;
    await fetchLibraryData();
    loadingstate.value = false;
    super.onInit();
  }

  @override
  void refresh() async {
    await fetchLibraryData();
    super.refresh();
  }

  Future<void> fetchLibraryData({bool showSnakeBars = true}) async {
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

    Result res = await LibraryRepository.fetchDashboardLibrary(
      sectionId: (selectedSection.value == 0) ? null : selectedSection.value,
      levelId: (selectedLevel.value == 0) ? null : selectedLevel.value,
      order: selectedOrder.value,
      sort: selectedSort.value,
      search: searchController.text,
      limit: rowsPerPage.value,
      page: currentPage,
      hardFetch: false,
    ); //assigning values to variables
    if (res.statusCode == 200) {
      library.value = res.data["library"] ?? {};
      availableRows.value = res.data["totalbooks"] ?? 0;
    } else if (res.statusCode == 404) {
      library.value = {};
      availableRows.value = 0;
      faildMessage.value = "this section and level not have Books";
      if (showSnakeBars) {
        showSnakeBar(
          title: "Not Found Books",
          message: "this section and level not have Books",
        );
      }
    } else {
      library.value = {};
      availableRows.value = 0;
      faildMessage.value = "fetching Books faild please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Books Faild",
            message: "fetching Books faild please check connection");
      }
    }
    update(["DataTable"]);
  }

  void fileDelete(int index) {
    selectedFiles.removeAt(index);
    update(["BooksPiker"]);
  }

  void filesMore(String? val, int index) {
    switch (val) {
      case "reName":
        break;
      case "Delete":
        fileDelete(index);
        break;
    }
  }

  Future<void> pickFiles() async {
    // Open file picker dialog
    // Get.dialog(const PopUpLoadingCard());
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: [
            'pdf',
            // PDF files
            'doc',
            'docx',
            // Microsoft Word
            'xls',
            'xlsx',
            // Microsoft Excel
            'ppt',
            'pptx',
            // Microsoft PowerPoint
            'txt',
            // Plain text files
            'rtf',
            // Rich Text Format
            'odt',
            'ods',
            'odp',
            // OpenDocument formats (LibreOffice, OpenOffice)
            'csv',
            // Comma-Separated Values
            'md',
            // Markdown files
            'html',
            'htm',
            // HTML documents
            'json',
            'xml',
            // Structured data files
            'epub',
            'mobi',
            'azw',
            // eBook formats
          ]);
    } catch (e) {
      showSnakeBar(
          title: "Loading Files Failed",
          message: "check your connection and try again");
    }
    // Navigator.of(Get.overlayContext!).pop();
    if (result != null) {
      bool exist = false;
      for (int i = 0; i < result.count; i++) {
        for (PlatformFile e in selectedFiles) {
          exist = (e.name == result.files[i].name);
        }
        if (!exist) {
          selectedFiles.add(result.files[i]);
        } else {
          showSnakeBar(message: "This File Already Exist");
        }
      }
      update(["BooksPiker"]);
    }
  }

  void delGroup(int index) {
    groups.removeAt(index);
  }

  void changeSelectedCategory(int? val) async {
    if (val == null) return;
    selectedCategory.value = val;
  }

  void onRowChange(int? val) async {
    if (val != null) {
      rowsPerPage.value = val;
      await fetchLibraryData();
      update(["DataTable"]);
    }
  }

  void onPageChange(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchLibraryData();
  }

  void changeSection(int? val) async {
    if (val == null) return;
    selectedSection.value = val;
    await fetchLibraryData();
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
    await fetchLibraryData();
  }

  void changeTerm(String? val) async {
    if (val == null) return;
    selectedTerm.value = val;
    fetchLibraryData();
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchLibraryData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchLibraryData();
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
    List<Level> levelData = await LevelRepository.fetchLevels(hardFetch: force)
        .then((e) => e.data?.values.toList() ?? []);
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
    for (Level level in levelData) {
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
    selectedLevel.value = levelData.first.id;
  }

  Future<void> addClick() async {
    await getSection();
    await getLevel();
    await getSubject();
    Get.dialog(AddLibraryTableCard());
  }

  Future<void> getSubject() async {
    subjects = {};
    subjects =
        await SubjectRepository.fetchSubjects().then((e) => e.data ?? {});
    if ((subjects.isNotEmpty)) {
      subjectId = RxString(subjects.values.first.id);
    } else {
      subjectId.value = null;
    }
  }

  Future<void> getSection() async {
    section = await SectionRepository.fetchSections(hardFetch: false)
        .then((e) => e.data ?? {});
    section[-1] = Section(id: -1, nameData: {"en": "All"});
    sectionId.value = -1;
  }

  Future<void> getLevel() async {
    List<Level> levelsData = await LevelRepository.fetchLevels()
        .then((e) => e.data?.values.toList() ?? []);
    level = {};
    for (Level leveli in levelsData) {
      level[leveli.id] = false.obs;
    }
    level[-1] = false.obs;
    levelId.value = -1;
  }

  void addGroup(int sectionId, int levelId) {
    if (groups.any((map) =>
        map["section_id"] == sectionId && map["level_id"] == levelId)) {
      showSnakeBar(message: "Group Already Exists");
      return;
    }
    groups.insert(
      0,
      {"section_id": sectionId, "level_id": levelId},
    );
  }

  Future<void> addBook() async {
    if (groups.isEmpty) {
      showSnakeBar(
          title: "Validation Error", message: "Should add at least one group");
      return;
    }
    if (selectedAddSubjectId == null) {
      showSnakeBar(
          title: "Validation Error", message: "Should select subject ");
      return;
    }
    for (PlatformFile file in (selectedFiles)) {
      List<LibraryFile> files = await LibraryRepository.uploadLibraryFile(
              file: file,
              groups: groups.value = [
                {"section_id": sectionId.value!, "level_id": levelId.value!}
              ],
              category: categories[selectedCategory.value ?? 0],
              subjectId: selectedAddSubjectId?.value)
          .then((e) => e.data ?? []);
      for (LibraryFile e in files) {
        books[e.category] ??= RxMap({});
        books[e.category]?[e.id] = e;
      }
    }
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
      await fetchLibraryData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void onClose() {
    searchController.dispose();
  }
}

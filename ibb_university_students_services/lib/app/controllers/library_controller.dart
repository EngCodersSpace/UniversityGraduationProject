import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/repositories/library_repository.dart';
import 'package:ibb_university_students_services/app/views/library_view/components/book_filter_card.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/lecture_tab.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/refreneces_tab.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/exam_forms_tab.dart';
import '../components/custom_text_v2.dart';
import '../models/helper_models/result.dart';
import '../models/level_model/level.dart';
import '../models/library_files_model/library_files_model.dart';
import '../models/section_model/section.dart';
import '../repositories/level_repository.dart';
import '../repositories/section_repository.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';
import '../utils/snake_bar.dart';
import '../views/library_view/components/add_books_card.dart';
import '../views/library_view/components/book_info_card.dart';

class LibraryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool loadingState = true.obs;
  RxString fieldMessage = "".obs;
  TabController? tapController;
  TextEditingController searchText = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String mode = "add";
  List<PlatformFile> selectedFiles = [];
  Rx<int?> selectedDepartment = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  Rx<int?> selectedCategory = Rx(0);
  RxInt selectedShowOption = 2.obs;
  RxString selectedSortOption = "title".obs;
  RxInt sortDirection = 0.obs;
  PageController booksPagesController = PageController();
  PageController notesPagesController = PageController();
  PageController refPagesController = PageController();
  Map<int, Section> sections = {};
  List<DropdownMenuItem<int>> levels = [];

  List<Border> borders = [];
  final List<int?> showOptions = [0, 1, 2];
  Map<String, List<String>> sortOptions = {
    "title": ["A to Z", "Z to A"],
    "size": ["Smallest", "Largest"],
    "page": ["Lowest", "Highest"],
    "date": ["Oldest", "Newest"],
  };
  RxMap<int, LibraryFile> books = RxMap();
  RxList<Widget> myTabs = RxList([
    const LecturesTab(),
    const ReferencesTab(),
    const ExamFormsTab(),
  ]);
  List<String> categories = [
    "Lecture",
    "Reference",
    "Exams Forms",
  ];
  LibraryFile? selectedBook;

  @override
  void onInit() async {
    // TODO: implement onInit
    loadingState.value = false;
    tapController = TabController(
      length: 3,
      vsync: this,
    );
    await LibraryRepository.openBox();
    await initSectionDropdownMenuList();
    await initLevelDropdownMenuLists();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (sections.isNotEmpty)
        ? selectedDepartment.value = sections.values.toList().first.id
        : null;
    BorderSide borderSide =
        BorderSide(color: AppColors.inverseCardColor, width: 1.0);
    borders = [
      Border(
        top: borderSide,
        right: borderSide,
        bottom: borderSide,
      ),
      Border(
        top: borderSide,
        left: borderSide,
        bottom: borderSide,
      ),
    ];
    await fetchLibraryData();
    super.onInit();
    loadingState.value = false;
  }


  @override
  void refresh() async{
    await fetchLibraryData();
  }

  Future<void> fetchLibraryData({bool force = false}) async {
    if (selectedLevel.value == null) {
      await initLevelDropdownMenuLists();
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

    if (selectedDepartment.value == null || selectedLevel.value == null) return;

    Result res = await LibraryRepository.streamFetchLibraryFilesGroup(
      sectionId: selectedDepartment.value!,
      levelId: selectedLevel.value!,
      category: categories[selectedCategory.value!],
      destination: books,
      hardFetch: force,
    );
    if (res.statusCode == 200) {

    } else if (res.statusCode == 204) {
      books.value = res.data ?? {};
      fieldMessage.value = "this section and level not has Document";
      showSnakeBar(
          title: "Not Found Document  ",
          message: "this section and level doesn't has Document ");
    } else {
      fieldMessage.value =
          "fetching assignments failed please check connection";
      showSnakeBar(
          title: "Fetch Library Document Failed",
          message: "fetching Document failed please check connection ");
    }
  }

  Future<void> initSectionDropdownMenuList({bool force = false}) async {
    sections = await SectionRepository.fetchSections(hardFetch: force)
        .then((e) => e.data ?? {});
    sections[-1] = Section(id: -1,nameData: {"en":"All"});
  }

  Future<void> initLevelDropdownMenuLists() async {
    List<Level> levelsData =
        await LevelRepository.fetchLevels().then((e) => e.data ?? []);
    levels = [];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (Get.width * 0.5) * 0.75,
              child: CustomText(
                level.name ?? "unknown",
                style:
                    AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Bold),
              ),
            )),
      );
    }
    levels.add(
      DropdownMenuItem<int>(
          value: -1,
          child: SizedBox(
            width: (Get.width * 0.5) * 0.75,
            child: CustomText(
              "All",
              style:
              AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Bold),
            ),
          )),
    );
    if (levelsData.isNotEmpty) {
      selectedLevel.value = levelsData.first.id;
    }
  }

  void changeDepartment(int? val) async {
    if (val == null) return;
    selectedDepartment.value = val;
  }

  void changeSelectedSortOption(String? val) async {
    if (val == null) return;
    selectedSortOption.value = val;
  }

  void changeSelectedSortDirection(int? val) async {
    if (val == null) return;
    sortDirection.value = val;
  }

  void changeSelectedShowOption(int? val) {
    if (val == null) return;
    selectedShowOption.value = val;
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
  }

  void showBookInfo(LibraryFile book) {
    selectedBook = book;
    Get.dialog(PopUpBookInfoCard());
  }

  void searching(String? val) {}

  void filtering(String? val) {}

  void filteringIconClick() {
    Get.dialog(PopUpBookFilterCard());
  }

  void addIconClick() async {
    await Get.dialog(BooksAddFilesCard());
  }

  void filesMore(String? val, int index) {
    switch (val) {
      case "reName":
        break;
      case "Delete":
        break;
    }
  }

  void fileRename() {}

  void libraryMore(String? val) async {
    switch (val) {
      case "add":
        mode = "add";
        await Get.dialog(BooksAddFilesCard());
        selectedFiles = [];
        break;
      case "addReq":
        mode = "addReq";
        await Get.dialog(BooksAddFilesCard());
        selectedFiles = [];
        break;
      case "downloadHis":
        break;
      case "uploadHis":
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
      showSnakeBar(message: "Loading Files Failed");
    }
    // Navigator.of(Get.overlayContext!).pop();
    if (result != null) {
      bool exist = false;
      for (int i = 0; i < result.count; i++) {
        for (PlatformFile e in selectedFiles) {
          exist = (e.path?.split("/").last ==
              result.files[i].path?.split("/").last);
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

  void uploadBooks() {}

  void closeAddBooksDialog() {
    Navigator.of(Get.overlayContext!).pop();
  }

  @override
  void onClose() {
    LibraryRepository.closeBox();
    tapController?.dispose();
    super.onClose();
  }
}

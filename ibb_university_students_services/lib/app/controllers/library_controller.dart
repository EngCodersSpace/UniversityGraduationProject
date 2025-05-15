import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/repositories/library_repository.dart';
import 'package:ibb_university_students_services/app/utils/screen_utils.dart';
import 'package:ibb_university_students_services/app/views/library_view/components/book_filter_card.dart';
import 'package:ibb_university_students_services/app/views/library_view/components/web_add_books_card.dart';
import 'package:ibb_university_students_services/app/views/library_view/components/web_book_filter_card.dart';
import 'package:ibb_university_students_services/app/views/library_view/components/web_book_info_card.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/lecture_tab.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/exam_forms_tab.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/refreneces_tab.dart';
import '../models/helper_models/result.dart';
import '../models/level_model/level.dart';
import '../models/library_files_model/library_files_model.dart';
import '../models/section_model/section.dart';
import '../models/subject_model/subject_model.dart';
import '../repositories/level_repository.dart';
import '../repositories/section_repository.dart';
import '../repositories/subject_repository.dart';
import '../styles/app_colors.dart';
import '../utils/file_utils.dart';
import '../utils/snake_bar.dart';
import '../views/library_view/components/add_books_card.dart';
import '../views/library_view/components/book_info_card.dart';

class LibraryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool loadingState = true.obs;
  RxString fieldMessage = "".obs;
  TabController? tapController;
  TextEditingController searchText = TextEditingController();
  RxString? selectedSubjectId = "all-option".obs;
  RxString? selectedAddSubjectId;
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
  Map<int, RxBool> levels = {};
  Map<String, Subject> subjects = {};
  RxList<Map<String, int>> groups = RxList();

  List<String> categories = [
    "Lecture",
    "Reference",
    "Exams Forms",
  ];
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
    LecturesTab(),
    const ReferencesTab(),
    const ExamFormsTab(),
  ]);
  LibraryFile? selectedBook;

  @override
  void onInit() async {
    loadingState.value = false;
    tapController = TabController(
      length: 3,
      vsync: this,
    );
    await LibraryRepository.openBox();
    await initSectionDropdownMenuList();
    await initLevelDropdownMenuLists();
    subjects =
        await SubjectRepository.fetchSubjects().then((e) => e.data ?? {});
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
  void refresh() async {
    fetchLibraryData(force: true);
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> fetchLibraryData({bool force = false}) async {
    if (selectedLevel.value == null) {
      await initLevelDropdownMenuLists();
      if (levels.isNotEmpty) {
        selectedLevel.value = levels.keys.first;
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
      fieldMessage.value = "Empty ";
    } else {
      fieldMessage.value = "fetching Library Document please check connection";
      showSnakeBar(
          title: "Fetch Library Document Failed",
          message: "fetching Document failed please check connection ");
    }
  }

  Future<void> initSectionDropdownMenuList({bool force = false}) async {
    sections = await SectionRepository.fetchSections(hardFetch: force)
        .then((e) => e.data ?? {});
    sections[-1] = Section(id: -1, nameData: {"en": "All"});
    selectedDepartment.value = -1;
  }

  Future<void> initLevelDropdownMenuLists() async {
    List<Level> levelsData = await LevelRepository.fetchLevels()
        .then((e) => e.data?.values.toList() ?? []);
    levels = {};
    for (Level level in levelsData) {
      levels[level.id] = false.obs;
    }
    levels[-1] = false.obs;
    selectedLevel.value = -1;
  }

  void changeDepartment(int? val) async {
    if (val == null) return;
    selectedDepartment.value = val;
  }

  void changeSelectedCategory(int? val) async {
    if (val == null) return;
    selectedCategory.value = val;
  }

  void changeSelectedSortOption(String? val) async {
    if (val == null) return;
    selectedSortOption.value = val;
    switch (val) {
      case "title":
        books.value = Map<int, LibraryFile>.fromEntries(books.entries.toList()
          ..sort((a, b) => (sortDirection.value == 0)
              ? (a.value.title
                      ?.toLowerCase()
                      .compareTo(b.value.title?.toLowerCase() ?? "") ??
                  0)
              : (b.value.title
                      ?.toLowerCase()
                      .compareTo(a.value.title?.toLowerCase() ?? "") ??
                  0)));
        break;
      case "page":
        books.value = Map<int, LibraryFile>.fromEntries(books.entries.toList()
          ..sort((a, b) => (sortDirection.value == 0)
              ? (a.value.numberOfPages?.compareTo(b.value.numberOfPages ?? 0) ??
                  0)
              : (b.value.numberOfPages?.compareTo(a.value.numberOfPages ?? 0) ??
                  0)));
        break;
      case "size":
        books.value = Map<int, LibraryFile>.fromEntries(books.entries.toList()
          ..sort((a, b) => (sortDirection.value == 0)
              ? (a.value.fileSize?.compareTo(b.value.fileSize ?? 0) ?? 0)
              : (b.value.fileSize?.compareTo(a.value.fileSize ?? 0) ?? 0)));
        break;
    }
  }

  void changeSelectedSortDirection(int? val) async {
    if (val == null) return;
    sortDirection.value = val;
    changeSelectedSortOption(selectedSortOption.value);
  }

  void changeSelectedShowOption(int? val) {
    if (val == null) return;
    selectedShowOption.value = val;
  }

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
  }

  void showBookInfo(LibraryFile book) async {
    selectedBook = book;
    await selectedBook?.checkDownloaded();
    (ScreenUtils.isPhoneScreen())
        ? Get.dialog(PopUpBookInfoCard())
        : Get.dialog(WebBookInfoCard());
  }

  void searching(String? val) {
    update();
  }

  void filteringIconClick() {
    (ScreenUtils.isPhoneScreen())
        ? Get.dialog(PopUpBookFilterCard())
        : Get.dialog(WebBookFilterCard());
  }

  void addIconClick() async {
    (ScreenUtils.isPhoneScreen())
        ? await Get.dialog(BooksAddFilesCard())
        : await Get.dialog(WebAddBooksCard());
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

  void fileRename() {}

  void fileDelete(int index) {
    selectedFiles.removeAt(index);
    update(["BooksPiker"]);
  }

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
      showSnakeBar(title: "Loading Files Failed",message: "check your connection and try again");
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

  void uploadBooks() async {
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
              groups: groups,
              category: categories[selectedCategory.value ?? 0],
              subjectId: selectedAddSubjectId?.value)
          .then((e) => e.data ?? []);
      for (LibraryFile e in files) {
        books[e.id] = e;
      }
    }
  }

  void downloadBooks() async {
    if (selectedBook == null) return;
    LibraryRepository.downloadLibraryFile(file: selectedBook!);
  }

  void openFile() async {
    if (selectedBook?.filePath == null) return;

    await FileUtils.openFile(selectedBook?.filePath);
  }

  void deleteBooksFromStorage() async {
    if (selectedBook?.filePath == null) return;
    bool res = await FileUtils.deleteFile(filePath: selectedBook!.filePath);
    if(res){
      showSnakeBar(message: "File Deleted");
      await selectedBook?.checkDownloaded();
    }
  }
  void deleteBooksFromServer() async {
    if (selectedBook?.id == null) return;
    Result res = await LibraryRepository.deleteLibraryBook(bookId: selectedBook!.id);
    Navigator.of(Get.overlayContext!).pop();
    if(res.statusCode == 200){
      Navigator.of(Get.overlayContext!).pop();
      showSnakeBar(title: "Delete successfully", message: "File deleted from Server");
      books.remove(selectedBook?.id);

    }else{
      showSnakeBar(title: "Delete Failed",message: "Deleting file from server Failed");
    }

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

  void delGroup(int index) {
    groups.removeAt(index);
  }

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

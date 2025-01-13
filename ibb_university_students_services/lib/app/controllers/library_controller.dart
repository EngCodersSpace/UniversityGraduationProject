import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/views/library_view/components/book_filter_card.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/lecture_tab.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/refreneces_tab.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/exam_forms_tab.dart';

import '../components/custom_text_v2.dart';
import '../models/level_model/level.dart';
import '../models/section_model/section.dart';
import '../services/level_services.dart';
import '../services/section_services.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';
import '../views/library_view/components/book_info_card.dart';

class LibraryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tapController;

  Rx<int?> selectedDepartment = Rx(null);
  Rx<int?> selectedLevel = Rx(null);
  RxString selectedSortOption = "title".obs;
  RxInt sortDirection = 0.obs;
  PageController booksPagesController = PageController();
  PageController notesPagesController = PageController();
  PageController refPagesController = PageController();
  List<DropdownMenuItem<int>> departments = [];
  List<DropdownMenuItem<int>> levels = [];
  List<Border> borders =[];
  Map<String,List<String>> sortOptions = {
    "title":["A to Z","Z to A"],
    "size":["Smallest","Largest"],
    "page":["Lowest","Highest"],
    "date":["Oldest","Newest"],
  };

  RxList books = [
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {
      "name": "bookknc zxnnznxlknnn",
      "image": "assets/images/services_cards/result.png"
    },
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
  ].obs;
  RxList<Widget> myTabs = RxList([
    const LecturesTab(),
    const ReferencesTab(),
    const ExamFormsTab(),
  ]);
  Map<String, dynamic> selectedBook = {};

  @override
  void onInit() async{
    // TODO: implement onInit
    tapController = TabController(
      length: 3,
      vsync: this,
    );
    await initSectionDropdownMenuList();
    await initLevelDropdownMenuLists();
    (levels.isNotEmpty) ? selectedLevel.value = levels.first.value : null;
    (departments.isNotEmpty)
        ? selectedDepartment.value = departments.first.value
        : null;
    BorderSide borderSide = BorderSide(
        color:AppColors.inverseCardColor,
        width: 1.0);
    borders = [
      Border(
        top: borderSide,
        right: borderSide,
        bottom: borderSide,
      ),
      Border(
        top: borderSide,
        left:borderSide,
        bottom: borderSide,
      ),


    ];
    super.onInit();
  }

  Future<void> initSectionDropdownMenuList() async {
    List<Section> sectionsData = await SectionServices.fetchSections()
        .then((e) => e.data?.values.toList() ?? []);
    departments = [];
    for (Section section in sectionsData) {
      departments.add(DropdownMenuItem<int>(
        value: section.id,
        child: SizedBox(
          width: (Get.width / 3.3) * 0.75,
          child: CustomText(
            section.name ?? "unknown".tr,
            style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3),
          ),
        ),
      ));
    }
    selectedDepartment.value = sectionsData.first.id;
  }

  Future<void> initLevelDropdownMenuLists() async {
    List<Level> levelsData = await LevelServices.fetchLevels()
        .then((e) => e.data?.values.toList() ?? []);
    // List<String> yearData =
    //     await AppDataServices.fetchLectureYears().then((e) => e.data ?? []);
    levels = [];
    for (Level level in levelsData) {
      levels.add(
        DropdownMenuItem<int>(
            value: level.id,
            child: SizedBox(
              width: (Get.width / 3.3) * 0.75,
              child: CustomText(
                level.name ?? "unknown",
                style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3),
              ),
            )),
      );
    }
    selectedLevel.value = levelsData.first.id;
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

  void changeLevel(int? val) async {
    if (val == null) return;
    selectedLevel.value = val;
  }

  void showBookInfo(Map<String, dynamic> book) {
    selectedBook = book;
    Get.dialog(PopUpBookInfoCard());
  }

  void searching(String? val) {}

  void filtering(String? val) {}

  void filteringIconClick() {
    Get.dialog(PopUpBookFilterCard());
  }

  void more() {}

  @override
  void onClose() {
    tapController?.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/books_tab.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/notes_tab.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_tabs/ref_tab.dart';

import '../views/library_view/components/book_info_card.dart';

class LibraryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tapController;

  PageController booksPagesController = PageController();
  PageController notesPagesController = PageController();
  PageController refPagesController = PageController();
  RxList books = [
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
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
    {"name": "book", "image": "assets/images/services_cards/result.png"},
  ].obs;
  RxList<Widget> myTabs = RxList([
    const BooksTab(),
    const NotesTab(),
    const RefTab(),
  ]);
  Map<String,dynamic> selectedBook = {};
  @override
  void onInit() {
    // TODO: implement onInit
    tapController = TabController(
      length: 3,
      vsync: this,
    );
    super.onInit();
  }

  void showBookInfo(Map<String,dynamic> book) {
    selectedBook = book;
    Get.dialog(PopUpBookInfoCard());
  }

  void searching(String? val) {}

  @override
  void onClose() {
    tapController?.dispose();
    super.onClose();
  }
}

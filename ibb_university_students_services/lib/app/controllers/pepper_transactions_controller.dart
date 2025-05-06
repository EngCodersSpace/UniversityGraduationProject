import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles/app_colors.dart';
import '../views/pepper_transactions_view/pepper_transactions_view_components/transaction_filter_card.dart';


class PepperTransactionsController extends GetxController {

  RxBool loadingState = false.obs;
  List transactions = [1,2];
  List<String> status = ["all","pending","rejected","accepted","committed"];
  TextEditingController searchText = TextEditingController();
  FocusNode searchFocus = FocusNode();
  RxString selectedSortOption = "title".obs;
  RxString selectedFilterOption = "all".obs;
  RxInt sortDirection = 0.obs;
  final List<int?> showOptions = [0, 1, 2];
  Map<String, List<String>> sortOptions = {
    "title": ["A to Z", "Z to A"],
    "size": ["Smallest", "Largest"],
    "page": ["Lowest", "Highest"],
    "date": ["Oldest", "Newest"],
  };
  List<Border> borders = [];


  @override
  void onInit() {
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
    super.onInit();
  }

  void searching(String? val) {}

  void changeSelectedSortOption(String? val) async {
    if (val == null) return;
    selectedSortOption.value = val;
    // switch (val) {
    //   case "title":
    //     books.value = Map<int, LibraryFile>.fromEntries(books.entries.toList()
    //       ..sort((a, b) => (sortDirection.value == 0)
    //           ? (a.value.title
    //           ?.toLowerCase()
    //           .compareTo(b.value.title?.toLowerCase() ?? "") ??
    //           0)
    //           : (b.value.title
    //           ?.toLowerCase()
    //           .compareTo(a.value.title?.toLowerCase() ?? "") ??
    //           0)));
    //     break;
    //   case "page":
    //     books.value = Map<int, LibraryFile>.fromEntries(books.entries.toList()
    //       ..sort((a, b) => (sortDirection.value == 0)
    //           ? (a.value.numberOfPages?.compareTo(b.value.numberOfPages ?? 0) ??
    //           0)
    //           : (b.value.numberOfPages?.compareTo(a.value.numberOfPages ?? 0) ??
    //           0)));
    //     break;
    //   case "size":
    //     books.value = Map<int, LibraryFile>.fromEntries(books.entries.toList()
    //       ..sort((a, b) => (sortDirection.value == 0)
    //           ? (a.value.fileSize?.compareTo(b.value.fileSize ?? 0) ?? 0)
    //           : (b.value.fileSize?.compareTo(a.value.fileSize ?? 0) ?? 0)));
    //     break;
    // }
  }

  void changeSelectedSortDirection(int? val) async {
    if (val == null) return;
    sortDirection.value = val;
    changeSelectedSortOption(selectedSortOption.value);
  }

  void changeSelectedFilterOption(String? val) {
    if (val == null) return;
    selectedFilterOption.value = val;
  }

  void filteringIconClick() {
    Get.dialog(PopUpTransactionFilterCard());
  }
}

import 'package:flutter/cupertino.dart';

abstract class HeaderOfViewControllerInterface {
  TextEditingController get searchController;
  void onSearch();
  void export();
  void import();
}

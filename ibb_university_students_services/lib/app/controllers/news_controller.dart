import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NewsController extends GetxController {
  RxBool initState = false.obs;
  TextEditingController searchText = TextEditingController();
  FocusNode searchFocus = FocusNode();

  quill.QuillController quillController =
      quill.QuillController.basic(config: quill.QuillControllerConfig());
  quill.QuillSimpleToolbar? quillConfig;

  @override
  void onInit() {
    super.onInit();
    initState.value = true;
  }

  void saveNewsContent() {
    quillController.readOnly = true;
    String js = jsonEncode(quillController.document.toDelta().toJson());
  }

  void searching(String? val) {
    update();
  }

  void loadNewsContent() {
    quillController.document = quill.Document.fromJson(jsonDecode("[]"));
  }
}

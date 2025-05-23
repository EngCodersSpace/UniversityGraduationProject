import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/repositories/news_repository.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/pop_up_cards/loading_card.dart';
import '../models/instructor_model/instructor_model.dart';
import '../models/news_model/news.dart';
import '../models/user_model/user.dart';
import '../utils/snake_bar.dart';

class NewsController extends GetxController {
  RxBool initState = false.obs;
  TextEditingController searchText = TextEditingController();
  FocusNode searchFocus = FocusNode();
  TextEditingController titleController =
      TextEditingController(text: "newTitle");
  FocusNode titleFocus = FocusNode();
  TextEditingController dateController = TextEditingController(
      text: DateTimeUtils.formatStringDateTime(
          time: DateTime.now().toIso8601String()));
  quill.QuillController quillController =
      quill.QuillController.basic(config: quill.QuillControllerConfig());
  FocusNode quillFocus = FocusNode();
  RxBool showToolBar = false.obs;
  RxBool editing = false.obs;
  RxBool creating = false.obs;
  Rx<Offset> toolbarPosition = Rx(Offset(20, 100));
  PlatformFile? imageFile;

  RxDouble progress = (-1.0).obs;
  RxString fieldMessage = "error".obs;
  Instructor? publisher;
  RxMap<int, News> news = RxMap({});
  int? selectedId;

  @override
  void onInit() async {
    quillController.readOnly = !editing.value;
    quillFocus.addListener(() {
      if (quillFocus.hasFocus) {
        showToolBar.value = true;
      } else {
        showToolBar.value = false;
        // Do something when unfocused
      }
    });
    super.onInit();
    initState.value = true;
  }

  @override
  void refresh() async {
    await fetchNews(force: true);
    super.refresh();
  }

  Future<void> fetchNews({int? limit, bool force = false}) async {
    Result<Map<int, News>> res =
        await NewsRepository.fetchNews(limit: limit,hardFetch: force);
    if (res.statusCode == 200) {
      news.value = res.data ?? {};
    } else if (res.statusCode == 404) {
      news.value = {};
      fieldMessage.value = "Empty";
    } else {
      news.value = {};
      fieldMessage.value = "fetching news failed please check connection";
      showSnakeBar(
          title: "Fetch News Failed",
          message: "fetching News failed please check connection ");
    }
  }

  Future<void> pickImage() async {
    Get.dialog(const PopUpLoadingCard());
    FilePickerResult? result;
    if (await Permission.storage.request().isGranted ||
        await Permission.photos.request().isGranted) {
      try {
        result = await FilePicker.platform.pickFiles(
          allowCompression: false,
          type: FileType.image,
        );
      } catch (e) {
        showSnakeBar(title: e.toString(), message: "Loading Files Failed");
      }
      Navigator.of(Get.overlayContext!).pop();
      if (result != null) {
        imageFile = result.files.first;
      }
    } else {
      showSnakeBar(
          title: "Failed Load Image", message: "photos access denied ");
    }
    update(["imagePicker"]);
  }

  void onDraggableCanceled(v, offset) {
    toolbarPosition.value = offset;
  }

  void toggleEdit() async {
    if (editing.value == true) {
      await saveNews();
    }
    if (creating.value == true) {
      createNews();
      return;
    }
    editing.value = !editing.value;
    quillController.readOnly = !editing.value;
  }

  Future<void> saveNews() async {
    if (selectedId == null) return;
    String content = jsonEncode(quillController.document.toDelta().toJson());
    Result res = await NewsRepository.updateNews(
        file: imageFile,
        title: titleController.text,
        content: content,
        progress: progress,
        id: selectedId!);
    Navigator.of(Get.overlayContext!).pop();
    progress.value = -1.0;
    if (res.statusCode == 201) {
      news;
      news[selectedId!] = res.data;
    }
  }

  Future<void> createNews() async {
    String content = jsonEncode(quillController.document.toDelta().toJson());
    print(content);
    return;
    Result<News> res = await NewsRepository.createNews(
        file: imageFile,
        title: titleController.text,
        content: content,
        progress: progress);
    Navigator.of(Get.overlayContext!).pop();
    progress.value = -1.0;
    if (res.statusCode == 201 && res.data != null) {
      news[res.data!.id] = res.data!;
    }
  }

  void searching(String? val) {
    update();
  }

  void createRoute() async {
    creating.value = true;
    quillController.readOnly= false;
    editing.value = true;
    selectedId = null;
    titleController.text = "Title";
    quillController.clear();
    dateController.text = DateTimeUtils.formatStringDateTime(
        time: DateTime.now().toIso8601String());
    User? user = await UserRepository.fetchUser().then((e) => e.data);
    if(user != null){
      publisher = Instructor(id: user.id,nameData: user.nameData);
    }
    await Get.toNamed("news");
    creating.value = false;
  }

  void openNews(int i) {
    selectedId = i;
    if(news[i] == null)return;
    if (news[i]?.content != null && news[i] != null) {
      quillController.document = quill.Document.fromJson(jsonDecode(news[i]!.content!));
    }
    titleController.text = news[i]?.title??"";
    dateController.text =  news[i]?.date ??"Unknown".tr;
    if(news[i]?.publisher != null){
      publisher = news[i]!.publisher;
    }
    Get.toNamed("news");
    // Get.to(PhonesCreateEditeNewsView());
  }
}

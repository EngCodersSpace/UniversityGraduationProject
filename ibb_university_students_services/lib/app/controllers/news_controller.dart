import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/repositories/news_repository.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/pop_up_cards/loading_card.dart';
import '../utils/snake_bar.dart';


class NewsController extends GetxController {
  RxBool initState = false.obs;
  TextEditingController searchText = TextEditingController();
  FocusNode searchFocus = FocusNode();
  TextEditingController titleController = TextEditingController(text: "newTitle");
  FocusNode titleFocus = FocusNode();
  TextEditingController dateController = TextEditingController(text: DateTime.now().toString());
  quill.QuillController quillController =
      quill.QuillController.basic(config: quill.QuillControllerConfig());
  FocusNode quillFocus = FocusNode();

  RxBool showToolBar = false.obs;
  RxBool editing = true.obs;
  Rx<Offset> toolbarPosition = Rx(Offset(20, 100));
  PlatformFile? imageFile ;
  RxDouble progress = (-1.0).obs;

  @override
  void onInit() async{
    quillController.readOnly = !editing.value;
    quillFocus.addListener((){
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
  void refresh() async{

    super.refresh();
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
        showSnakeBar(title: e.toString(),message: "Loading Files Failed");
      }
      Navigator.of(Get.overlayContext!).pop();
      if (result != null) {
        imageFile = result.files.first;
        }
    } else {
      showSnakeBar(title: "Failed Load Image",message: "photos access denied ");
    }
    update(["imagePicker"]);
    }
void onDraggableCanceled(v,offset){
  toolbarPosition.value = offset;
}

  void toggleEdit(){
    editing.value = !editing.value;
    quillController.readOnly = !editing.value;
  }

  void saveNews() async{
    String content = jsonEncode(quillController.document.toDelta().toJson());
    if(imageFile == null)return;
    Result res = await NewsRepository.createNews(file: imageFile!, title: titleController.text, content: content,progress: progress);
    progress.value = -1.0;
    if(res.statusCode == 201){

    }
  }

  void searching(String? val) {
    update();
  }

  void openNews(int i) {

    Get.toNamed("news");
    // Get.to(PhonesCreateEditeNewsView());
  }

  void loadNewsContent() {
    quillController.document = quill.Document.fromJson(jsonDecode("[]"));
  }
}

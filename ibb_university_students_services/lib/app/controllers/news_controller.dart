// import 'dart:convert';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:get/get.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:ibb_university_students_services/app/repositories/news_repository.dart';
// import 'package:path_provider/path_provider.dart';
//
// class NewsController extends GetxController {
//   final title = ''.obs;
//   final headerImagePath = ''.obs;
//   final quillController = quill.QuillController.basic();
//
//   Future<void> pickHeaderImage() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.image);
//     if (result != null && result.files.single.path != null) {
//       headerImagePath.value = result.files.single.path!;
//     }
//   }
//
//   Future<void> insertImage() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.image);
//     if (result != null && result.files.single.path != null) {
//       final file = File(result.files.single.path!);
//       final appDir = await getApplicationDocumentsDirectory();
//       final fileName = result.files.single.name;
//       final copiedFile = await file.copy('${appDir.path}/$fileName');
//       await NewsRepository.uploadImageToServer(file: PlatformFile(name: "", size: 0),newsId: 0);
//       quillController.document.insert(
//         quillController.selection.baseOffset,
//         quill.BlockEmbed.image(copiedFile.path),
//       );
//     }
//   }
//
//
// }

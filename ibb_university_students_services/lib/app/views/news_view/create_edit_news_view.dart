// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
//
//
// class CreateEditNewsView extends GetView {
//
//
//   const CreateEditNewsView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create / Edit Post'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: () {
//               final post = controller.exportPost();
//               // Save or upload `post`
//               print(post);
//             },
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             TextField(
//               decoration: const InputDecoration(hintText: 'Title'),
//               onChanged: (val) => controller.title.value = val,
//             ),
//             Obx(() => controller.headerImagePath.isNotEmpty
//                 ? Image.file(File(controller.headerImagePath.value), height: 150)
//                 : const SizedBox.shrink()),
//             Row(
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: controller.pickHeaderImage,
//                   icon: const Icon(Icons.image),
//                   label: const Text('Header Image'),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton.icon(
//                   onPressed: controller.insertImage,
//                   icon: const Icon(Icons.photo),
//                   label: const Text('Insert Image'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             QuillToolbar.simple(controller: controller.quillController),
//             Expanded(
//               child: quill.QuillEditor(
//                 controller: controller.quillController,
//                 scrollController: ScrollController(),
//                 focusNode: FocusNode(),
//                 autoFocus: false,
//                 readOnly: false,
//                 padding: const EdgeInsets.all(8),
//                 expands: true,
//                 embedBuilders: FlutterQuillEmbeds.builders(), // for image support
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

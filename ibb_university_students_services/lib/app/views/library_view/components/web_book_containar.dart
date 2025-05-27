// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/models/library_files_model/library_files_model.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import '../../../components/custom_text_v2.dart';
import '../../../services/http_provider.dart';

class WebBookContainar extends GetView<LibraryController> {
  WebBookContainar({required this.book, super.key});

  LibraryFile book;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.showBookInfo(book),
      child: SizedBox(
        width: Get.width / 7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: (Get.height / 6) * 0.6,
                width: (Get.height / 5) * 0.5,
                child: HttpProvider.httpImage(imageUrl: "get-imageOfbook?id=${book.id}"),),
            SizedBox(
              height: 5,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 10,
                maxWidth: 200,
              ),
              child: CustomText(
                book.title ?? "Unknown",
                maxLines: 2,
                style: AppTextStyles.mainStyle(
                    textHeader: AppTextHeaders.h3Normal),
              ),
            )
          ],
        ),
      ),
    );
  }
}

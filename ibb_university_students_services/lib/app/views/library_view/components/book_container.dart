// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/models/library_files_model/library_files_model.dart';
import 'package:ibb_university_students_services/app/services/http_provider.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import '../../../components/custom_text_v2.dart';

class BookContainer extends GetView<LibraryController> {
  BookContainer({required this.book, super.key});

  LibraryFile book ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.showBookInfo(book),
      child: SizedBox(
        width: Get.width / 3.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: (Get.height/5)*0.4,
              width: (Get.height/5)*0.3,
              child: HttpProvider.httpImage(imageUrl: "get-imageOfbook?id=${book.id}",secImageUrl: book.displayImage)
            ),
            SizedBox(
              height: 8,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 10,
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

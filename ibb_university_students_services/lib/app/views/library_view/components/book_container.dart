// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/models/library_files_model/library_files_model.dart';
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
              child: CachedNetworkImage(
                imageUrl: book.displayImage ?? "assets/images/library/file.png",
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                // height: (Get.height/5)*0.4,

                fit: BoxFit.cover,
              )
            ),
            SizedBox(
              height: 8,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 10
              ),
              child: CustomText(
                book.title ?? "Unknown",
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

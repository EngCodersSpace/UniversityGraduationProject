// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import '../../../components/custom_text_v2.dart';

class BookContainer extends GetView<LibraryController> {
  BookContainer({required this.book, super.key});

  Map<String, dynamic> book = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.showBookInfo(book),
      child: SizedBox(
        width: Get.width / 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: (Get.height/5)*0.45,
              child: Image(
                image: AssetImage(
                  book["image"] ?? "",
                ),
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: CustomText(
                book["name"] ?? "Unknown",
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

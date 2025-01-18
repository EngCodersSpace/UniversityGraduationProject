// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import '../../../components/custom_text_v2.dart';

class BookContainer extends GetView<LibraryController> {
  BookContainer({required this.book, super.key});
  Map<String,dynamic> book = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>controller.showBookInfo(book),
      child: SizedBox(
        width: Get.width / 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: Get.width/5,
              child: Image(
                image: AssetImage(
                  book["image"] ?? "",
                ),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Flexible(
                child: CustomText(
              book["name"] ?? "Unknown",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Normal),
            ))
          ],
        ),
      ),
    );
  }
}

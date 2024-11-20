// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';

import '../../../components/custom_text.dart';

class BookContainer extends GetView<LibraryController> {
  BookContainer({
    required this.bookName,
    required this.bookImgSrc,
    super.key});
  String bookImgSrc;
  String bookName ;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.showBookInfo,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            child: Image(
              image: AssetImage(
                bookImgSrc??"",
              ),
              fit: BoxFit.cover,
            ),
          ),
          MainText(bookName??"Unknown")
        ],
      ),
    );
    ;
  }
}

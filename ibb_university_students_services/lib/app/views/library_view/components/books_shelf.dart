import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';

import 'bookContainer.dart';

class BooksShelf extends GetView<LibraryController> {
  BooksShelf({
    required this.index,
    super.key});
  int index ;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          for (int i = index; (i < (index + 4)); i++)
            BookContainer(bookName: "book $i",bookImgSrc: "assets/images/library/istockphoto-867895848-612x612.jpg",),
        ]));
  }
}

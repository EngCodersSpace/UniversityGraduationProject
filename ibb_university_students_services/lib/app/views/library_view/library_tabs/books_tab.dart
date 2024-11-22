import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';

import '../../../components/custom_text.dart';
import '../../../globals.dart';
import '../components/bookContainer.dart';

class LecturesTab extends GetView<LibraryController> {
  const LecturesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PageView(
          controller: controller.booksPagesController,
          children: [
            for (int p = 0; p < controller.books.length; p += 16)
              Column(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/library/istockphoto-867895848-612x612.jpg"),
                            fit: BoxFit.fill),
                      ),
                      height: Get.height * 0.74,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: (Get.height * 0.74) * 0.04,
                          ),
                          for (int i = p;
                              (i < controller.books.length) && (i < p + 16);
                              i += 4) ...[
                            SizedBox(
                              height: (Get.height * 0.74) / 5,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    for (int j = i;
                                        (j < controller.books.length) &&
                                            (j < i + 4);
                                        j++)
                                      Obx(
                                        () => BookContainer(
                                          book: controller.books[j],
                                        ),
                                      )
                                  ]),
                            ),
                            SizedBox(
                              height: (Get.height * 0.68) / 26,
                            )
                          ],
                        ],
                      )),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/library/istockphoto-867895848-612x612_bottom.jpg"),
                            fit: BoxFit.fill),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.booksPagesController.previousPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.ease);
                            },
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: AppColors.backColor,
                            iconSize: 40,
                          ),
                          MainText("${(p ~/ 16) + 1}/${p + 1}"),
                          IconButton(
                              onPressed: () {
                                controller.booksPagesController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.ease);
                              },
                              icon: const Icon(Icons.arrow_forward_rounded),
                              color: AppColors.backColor,
                              iconSize: 40)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ));
  }
}

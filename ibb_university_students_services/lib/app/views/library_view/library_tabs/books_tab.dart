import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';

import '../components/bookContainer.dart';

class BooksTab extends GetView<LibraryController> {
  const BooksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller.booksPagesController,
      children: [
        for (int p = 0; p < 38; p += 20)
          Column(
            children: [
              for (int i = p; (i<38)&&(i < p + 20); i+=4)
                ...[
                  SizedBox(
                    height: (Get.height*0.68)/5.6,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int j = i; (j<38)&&(j < i + 4); j++)
                            Obx(()=>BookContainer(
                              bookName: "book $j".obs.value,
                              bookImgSrc: "assets/images/services_cards/result.png",
                            ),)
                        ]),
                  ),
                  if( i<38 && i!= p+4 )
                    ...[
                      SizedBox(height: (Get.height*0.68)/39,)
                    ]
                ]
            ],
          ),
      ],
    );
  }
}

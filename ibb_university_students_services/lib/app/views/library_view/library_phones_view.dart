import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';

import '../../components/custom_text.dart';
import '../../components/text_field.dart';
import '../../globals.dart';

class LibraryPhonesView extends GetView<LibraryController> {
  const LibraryPhonesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.mainCardColor,
          title: MainText(
            "Library",
            // textColor: AppColors.secTextColor,
          ),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.filter_list_alt)),
            IconButton(onPressed: (){}, icon: Icon(Icons.search_rounded)),
          ],
          backgroundColor: AppColors.inverseCardColor,
        ),
        body: Container(
          color: AppColors.inverseCardColor,
          child: Column(children: [
            Expanded(
              child: Column(
                children: [
                  TabBar(
                      controller: controller.tapController,
                      labelColor: AppColors.mainCardColor,
                      indicatorColor: AppColors.mainCardColor,
                      tabs: const [
                        Column(
                          children: [
                            Icon(Icons.library_books_outlined),
                            SizedBox(
                              height: 2,
                            ),
                            Text("Books"),
                            SizedBox(
                              height: 2,
                            ),
                          ],
                        ),
                        Column(
                          children: [

                            Icon(Icons.library_books_outlined),
                            SizedBox(
                              height: 2,
                            ),
                            Text("Notes"),
                          ],
                        ),
                        Column(
                          children: [

                            Icon(Icons.library_books_outlined),
                            SizedBox(
                              height: 2,
                            ),
                            Text("Ref"),
                          ],
                        )
                      ]),
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/library/5977d4803f1c826accafa7a49658ba81.jpg"),
                          fit: BoxFit.fill),
                    ),
                    height: Get.height * 0.68,
                    child: Obx(() => TabBarView(
                        controller: controller.tapController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: controller.myTabs.value)),
                  ),
                  Expanded(
                    child: Container(
                      decoration:  BoxDecoration(
                        color: AppColors.inverseCardColor
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: Colors.white70,
                            iconSize: 40,
                          ),

                          // MainText("${pageIndex+1}/${pagesLen![tabIndex]+1}"),

                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_forward_rounded),
                              color: Colors.white70,
                              iconSize: 40)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}

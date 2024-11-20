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
        body: Container(
      color: AppColors.inverseCardColor,
      child: Column(children: [
        Expanded(
          child: Column(
            children: [
              Container(
                  height: Get.height * 0.16,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/library/istockphoto-867895848-612x612_bottom.jpg"),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24,right: 24,top: 32 ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            MainText("Library"),
                            const SizedBox(width: 16,),
                            Expanded(
                              child: CustomTextFormField(
                                icon: Icons.search_rounded,
                                onChange: controller.searching,
                                labelText: "Search",
                                iconColor: AppColors.mainCardColor,
                              ),
                            ),
                            IconButton(onPressed: (){}, icon: Icon(Icons.filter_list_alt,color: AppColors.mainCardColor,))
                          ],


                        ),
                        const SizedBox(height: 8,),
                        TabBar(
                            controller: controller.tapController,
                            labelColor: AppColors.mainCardColor,
                            indicatorColor: AppColors.mainCardColor,
                            dividerHeight: 0,
                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelColor: AppColors.mainCardColor,
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
                      ],
                    ),
                  )),
              Expanded(
                child: Obx(() => TabBarView(
                    controller: controller.tapController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: controller.myTabs.value)),
              ),
            ],
          ),
        ),
      ]),
    ));
  }
}

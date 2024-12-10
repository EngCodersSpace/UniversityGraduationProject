import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import '../../components/text_field.dart';
import '../../styles/app_colors.dart';

class LibraryPhonesView extends GetView<LibraryController> {
  const LibraryPhonesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: Get.height * 0.18,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/library/istockphoto-867895848-612x612_bottom.jpg"),
                        fit: BoxFit.fill),
                  ),
                  padding: const EdgeInsets.only(left: 16, right: 8, top: 38),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.arrow_back_outlined,
                                color: AppColors.mainCardColor,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.filter_list_alt,
                                color: AppColors.mainCardColor,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.more_vert_outlined,
                                color: AppColors.mainCardColor,
                              )),
                          Expanded(
                            child: CustomTextFormField(
                              onChange: controller.searching,
                              labelText: "Search",
                              color: AppColors.mainCardColor,
                              prefixIcon: Icons.search_rounded,
                            ),
                          ),
                        ],
                      ),
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
                                Text("Lectures"),
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
                                Text("References"),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.library_books_outlined),
                                SizedBox(
                                  height: 2,
                                ),
                                Text("Exams Forms"),
                              ],
                            )
                          ]),
                    ],
                  )),
              SizedBox(
                height: Get.height * 0.82,
                child: TabBarView(
                    controller: controller.tapController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: controller.myTabs),
              ),
            ],
          ),
        ));
  }
}

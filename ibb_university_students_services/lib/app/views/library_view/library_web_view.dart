import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';

class LibraryWebView extends GetView<LibraryController> {
  const LibraryWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Get.height * 0.18,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/images/library/weblibrarybottom.png"),
                fit: BoxFit.fill,
              )),
              padding: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: controller.filteringIconClick,
                        icon: Icon(
                          Icons.filter_list_alt,
                          color: AppColors.mainCardColor,
                        ),
                        tooltip: "Filters",
                      ),
                      IconButton(
                        onPressed: controller.addIconClick,
                        icon: Icon(
                          Icons.add,
                          color: AppColors.mainCardColor,
                        ),
                        tooltip: "Add",
                      ),
                      SizedBox(
                        width: Get.width * 0.35,
                        child: Expanded(
                          child: CustomTextFormField(
                            controller: controller.searchText,
                            focusNode: controller.searchFocus,
                            onChange: (x) => controller.updatePages(),
                            onTapOutside: (e) {
                              controller.searchFocus.unfocus();
                            },
                            labelText: "Search",
                            labelStyle: TextStyle(
                                color: AppColors.mainTextColor, fontSize: 18),
                            color: AppColors.mainCardColor,
                            prefixIcon: Icons.search_rounded,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TabBar(
                      tabAlignment: TabAlignment.center,
                      controller: controller.tapController,
                      labelColor: AppColors.mainCardColor,
                      onTap: controller.refreshCurrentPage,
                      indicatorColor: AppColors.mainCardColor,
                      dividerHeight: 0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: AppColors.mainCardColor,
                      tabs: const [
                        Row(
                          children: [
                            Icon(
                              Icons.library_books_outlined,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Lectures",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.library_books_outlined,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "References",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.library_books_outlined,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Exams Forms",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ])
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.7,
              child: TabBarView(
                  controller: controller.tapController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: controller.myTabs),
            ),
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/images/library/weblibrarybottom.png"),
                    fit: BoxFit.fill),
              ),
              height: Get.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      controller
                          .myTabsControllers[controller.tapController!.index]
                          .previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.ease);
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.backColor,
                    iconSize: 30,
                  ),
                  SizedBox(
                    width: Get.width * 0.1,
                  ),
                  CustomText(
                    "0",
                    style: AppTextStyles.mainStyle(
                        textHeader: AppTextHeaders.h1Bold),
                  ),
                  SizedBox(
                    width: Get.width * 0.1,
                  ),
                  IconButton(
                      onPressed: () {
                        controller
                            .myTabsControllers[controller.tapController!.index]
                            .nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.ease);
                      },
                      icon: const Icon(Icons.arrow_forward_rounded),
                      color: AppColors.backColor,
                      iconSize: 30)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

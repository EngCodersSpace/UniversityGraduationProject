import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';

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
              height: Get.height * 0.2,
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
                            onChange: controller.searching,
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
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
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
                              "References",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
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
              height: Get.height * 0.6,
              child: TabBarView(
                  controller: controller.tapController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: controller.myTabs),
            ),
          ],
        ),
      ),
    );
  }
}

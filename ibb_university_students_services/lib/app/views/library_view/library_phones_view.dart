import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/library_controller.dart';
import '../../components/custom_text_v2.dart';
import '../../components/text_field.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

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
                              onPressed: controller.filteringIconClick,
                              icon: Icon(
                                Icons.filter_list_alt,
                                color: AppColors.mainCardColor,
                              )),
                          PopupMenuButton<String>(
                            onSelected: (val) => controller.libraryMore(val),
                            color: AppColors.inverseCardColor,
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                  value: "add",
                                  child: CustomText(
                                    "Upload New Books".tr,
                                    style: AppTextStyles.mainStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  )),
                              PopupMenuItem(
                                  value: "addReq",
                                  child: CustomText(
                                    "Books Add Request".tr,
                                    style: AppTextStyles.mainStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  )),
                              PopupMenuItem(
                                  value: "uploadHis",
                                  child: CustomText(
                                    "Uploads History".tr,
                                    style: AppTextStyles.mainStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  )),
                              PopupMenuItem(
                                  value: "uploadHis",
                                  child: CustomText(
                                    "Uploads History".tr,
                                    style: AppTextStyles.mainStyle(
                                        textHeader: AppTextHeaders.h3Bold),
                                  )),
                            ],
                            child: Icon(
                              Icons.more_vert,
                              color: AppColors.mainCardColor,
                              size: 25,
                            ),
                          ),
                          Expanded(
                            child: CustomTextFormField(
                              controller: controller.searchText,
                              focusNode: controller.searchFocus,
                              onChange: controller.searching,
                              onTapOutside: (e){controller.searchFocus.unfocus();},
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
                height: Get.height * 0.72,
                child: TabBarView(
                    controller: controller.tapController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: controller.myTabs),
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/images/library/istockphoto-867895848-612x612_bottom.jpg"),
                      fit: BoxFit.fill),
                ),
                height: Get.height * 0.1,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.booksPagesController
                            .previousPage(
                            duration: const Duration(
                                milliseconds: 400),
                            curve: Curves.ease);
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: AppColors.backColor,
                      iconSize: 40,
                    ),
                    CustomText(
                      "0",
                      style: AppTextStyles.mainStyle(
                          textHeader: AppTextHeaders.h1Bold),
                    ),
                    IconButton(
                        onPressed: () {
                          controller.booksPagesController
                              .nextPage(
                              duration: const Duration(
                                  milliseconds: 400),
                              curve: Curves.ease);
                        },
                        icon: const Icon(
                            Icons.arrow_forward_rounded),
                        color: AppColors.backColor,
                        iconSize: 40)
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

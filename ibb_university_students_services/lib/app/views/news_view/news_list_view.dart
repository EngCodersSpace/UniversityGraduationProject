import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/news_controller.dart';
import 'package:ibb_university_students_services/app/views/news_view/news_view_components/news_list_card.dart';
import '../../components/custom_text_v2.dart';
import '../../components/text_field.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

class PhonesNewsListView extends GetView<NewsController> {
   const PhonesNewsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => (controller.initState.value)
          ? Container(
              color: AppColors.tabBackColor,
              child: SafeArea(
                minimum: EdgeInsets.all(8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              color: AppColors.inverseCardColor,
                            )),
                        IconButton(
                            onPressed: controller.createRoute,
                            icon: Icon(
                              Icons.add,
                              color: AppColors.inverseCardColor,
                            )),
                        Expanded(
                          child: CustomTextFormField(
                            controller: controller.searchText,
                            focusNode: controller.searchFocus,
                            onChange: controller.searching,
                            labelStyle: AppTextStyles.highlightStyle(
                                textHeader: AppTextHeaders.h3Normal),
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Normal),
                            onTapOutside: (e) {
                              controller.searchFocus.unfocus();
                            },
                            labelText: "Search",
                            color: AppColors.inverseCardColor,
                            prefixIcon: Icons.search_rounded,
                          ),
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: CustomText(
                            "News List",
                            style: AppTextStyles.highlightStyle(
                                textHeader: AppTextHeaders.h2Bold),
                          )),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: ()async=>controller.refresh(),
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              if (controller.news.isEmpty) ...[
                                SizedBox(
                                  height: Get.height * 0.2,
                                ),
                                Center(
                                    child: CustomText(
                                      controller.fieldMessage.value,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h2Bold),
                                    )),
                                IconButton(
                                    onPressed: () async => controller.refresh(),
                                    icon: const Icon(Icons.refresh))
                              ],
                              for (int i = (controller.news.length-1); i >= 0; i--) ...[
                                if((controller.news.values.toList()[i].title?.toLowerCase().contains(controller.searchText.text.toLowerCase())??false)||controller.searchText.text=="")...[
                                  NewsListCard(controller.news.values.toList()[i]),
                                  SizedBox(
                                    height: 8,
                                  )
                                ]
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            )),
    );
  }
}

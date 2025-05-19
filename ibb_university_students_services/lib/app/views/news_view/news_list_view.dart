import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/news_controller.dart';
import '../../components/custom_text_v2.dart';
import '../../components/text_field.dart';
import '../../services/http_provider.dart';
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
          child: Column(
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
                      onPressed: (){},
                      icon: Icon(
                        Icons.add,
                        color: AppColors.mainCardColor,
                      )),
                  Expanded(
                    child: CustomTextFormField(
                      controller: controller.searchText,
                      focusNode: controller.searchFocus,
                      onChange: controller.searching,
                      labelStyle: AppTextStyles.mainStyle(
                          textHeader: AppTextHeaders.h3Normal),
                      style: AppTextStyles.mainStyle(
                          textHeader: AppTextHeaders.h3Normal),
                      onTapOutside: (e) {
                        controller.searchFocus.unfocus();
                      },
                      labelText: "Search",
                      color: AppColors.mainCardColor,
                      prefixIcon: Icons.search_rounded,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
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

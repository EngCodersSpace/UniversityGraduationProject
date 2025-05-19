import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/news_controller.dart';
import '../../components/custom_text_v2.dart';
import '../../services/http_provider.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

class PhonesNewsView extends GetView<NewsController> {
  const PhonesNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Obx(() => (controller.initState.value)
          ? Container(
        color: AppColors.inverseCardColor.withAlpha(240),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () => controller.saveNewsContent(),
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: AppColors.mainCardColor,
                      )),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: Get.height * 0.24,
                width: Get.width * 0.86,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border:
                  Border.all(width: 3, color: AppColors.tabBackColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: HttpProvider.httpImage(
                    imageUrl: "",
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/news_full_back.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
                  decoration: BoxDecoration(
                    color: AppColors.tabBackColor,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Get.width * 0.07)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      CustomText(
                        "News of today title".tr,
                        style: AppTextStyles.secStyle(
                            textHeader: AppTextHeaders.h1Bold),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomText(
                        "By Shehab AL-Saidi - 2025-5-6".tr,
                        style: AppTextStyles.highlightStyle(
                            textHeader: AppTextHeaders.h3Bold),


                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Expanded(child: QuillEditor.basic(
                        controller: controller.quillController,
                        config: QuillEditorConfig(),
                      ))
                    ],
                  ),
                ),
              )
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

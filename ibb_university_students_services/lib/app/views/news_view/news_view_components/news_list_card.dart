import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/news_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';

import '../../../components/custom_text_v2.dart';
import '../../../services/http_provider.dart';
import '../../../styles/text_styles.dart';

class NewsListCard extends GetView<NewsController> {
  const NewsListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.85,
      decoration: BoxDecoration(
          color: AppColors.inverseCardColor.withAlpha(15),
          borderRadius: BorderRadius.circular(24)),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    "The Title of this News card ",
                    style: AppTextStyles.secStyle(
                        textHeader: AppTextHeaders.h2Bold),
                  ),
                  CustomText(
                    "By Shehab AL-Saidi",
                    style: AppTextStyles.highlightStyle(
                        textHeader: AppTextHeaders.h3Normal),
                  ),
                  CustomText(
                    "2025/5/19",
                    style: AppTextStyles.highlightStyle(
                        textHeader: AppTextHeaders.h3Normal),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

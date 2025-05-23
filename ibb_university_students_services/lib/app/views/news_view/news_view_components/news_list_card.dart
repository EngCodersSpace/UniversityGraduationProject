// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/news_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';

import '../../../components/custom_text_v2.dart';
import '../../../models/news_model/news.dart';
import '../../../services/http_provider.dart';
import '../../../styles/text_styles.dart';
import '../../../utils/date_time_utils.dart';

class NewsListCard extends GetView<NewsController> {
  News news;
  NewsListCard(this.news, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.openNews(news.id),
      child: Container(
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
                  imageUrl: "Get-imageOfnew?id=${news.id}",
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
                      news.title??"Unknown".tr,
                      style: AppTextStyles.secStyle(
                          textHeader: AppTextHeaders.h2Bold),
                    ),
                    CustomText(
                      "${"By".tr} ${news.publisher?.name}",
                      style: AppTextStyles.highlightStyle(
                          textHeader: AppTextHeaders.h3Normal),
                    ),
                    CustomText(
                      "${"At".tr} ${news.date??"0000-00-00"}",
                      style: AppTextStyles.highlightStyle(
                          textHeader: AppTextHeaders.h3Normal),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(icon: Icon(Icons.delete), onPressed: ()=>controller.deleteNews(news.id))
          ],
        ),
      ),
    );
  }
}

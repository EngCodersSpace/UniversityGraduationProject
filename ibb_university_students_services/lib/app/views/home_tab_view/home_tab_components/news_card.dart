// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ibb_university_students_services/app/services/http_provider.dart';

import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class NewsCard extends StatelessWidget {
  NewsCard({
    required this.height,
    required this.width,
    this.text = "Title and description of the news",
    this.imageUrl,
    this.onTap,
    super.key,
  });

  String text;
  double height;
  double width;
  String? imageUrl;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: height - 30,
              decoration: BoxDecoration(
                  color: AppColors.inverseCardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 2))
                  ]),
            ),
            Container(
              height: height - 33,
              width: width - 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: HttpProvider.httpImage(
                imageUrl: imageUrl ?? "",
                errorWidget: (context, url, error) => Image.asset(
                  "assets/images/news_full_back.jpg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              height: height - 30,
              decoration: BoxDecoration(
                color: AppColors.coverColor.withAlpha(40),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            Container(
              height: height - 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  // AppColors.inverseCardColor.withAlpha((255*0.2).toInt()),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withAlpha((255*0.3).toInt()),
                  Colors.black.withAlpha((255*0.5).toInt()),
                  Colors.black.withAlpha((255*0.6).toInt()),
                  Colors.black.withAlpha((255*0.7).toInt()),
                ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                ),
                // color: AppColors.coverColor,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(left: 4, right: 4, bottom: 24),
                  child: CustomText(
                    text,
                    style: AppTextStyles.mainStyle(
                      textHeader: AppTextHeaders.h1Bold,
                      height: 0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

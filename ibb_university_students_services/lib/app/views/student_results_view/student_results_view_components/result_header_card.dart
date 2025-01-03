

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class ResultHeaderCard extends StatelessWidget {

  const ResultHeaderCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.inverseCardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 5),
          )
        ],
        border: Border.all(color: AppColors.inverseCardColor,width: 0.5),
        borderRadius:
        const BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8),topRight: Radius.circular(16),bottomRight: Radius.circular(0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: ((Get.width-16)*2.5)/7,
            child: CustomText(
              "Subject Name",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*0.55)/7,
            child: CustomText(
              "Units",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*1.25)/7,
            child: CustomText(
              "Practicality\n(30)",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*1.25)/7,
            child: CustomText(
              "Final Exam\n(70)",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*0.55)/7,
            child: CustomText(
              "Sum\n(100)",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
        ],
      ),
    );
  }
}

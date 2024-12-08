// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:intl/intl.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../models/exam_model.dart';
import '../../../styles/text_styles.dart';

class ResultCard extends StatelessWidget {
  ResultCard({
    super.key,
    this.type = "even",
  });

  DateFormat timeFormat = DateFormat("hh:mm a");
  String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: (type == "even")
            ? AppColors.mainCardColor.withOpacity(0.8):AppColors.inverseCardColor,

        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 5),
          )
        ],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(0)),
      ),
      child: (type == "even")?Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: ((Get.width-16)*2)/7,
            child: CustomText(
              "Power Systems",
              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*0.55)/7,
            child: CustomText(
              "2",
              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*1.45)/7,
            child: CustomText(
              "30",
              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*1.45)/7,
            child: CustomText(
              "70",
              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*0.55)/7,
            child: CustomText(
              "100",
              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h5),
            ),
          ),

        ],
      ):Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: ((Get.width-16)*2)/7,
            child: CustomText(
              "Power Systems of the world",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*0.55)/7,
            child: CustomText(
              "2",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*1.45)/7,
            child: CustomText(
              "30",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*1.45)/7,
            child: CustomText(
              "70",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*0.55)/7,
            child: CustomText(
              "100",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),

        ],
      ),
    );
  }
}

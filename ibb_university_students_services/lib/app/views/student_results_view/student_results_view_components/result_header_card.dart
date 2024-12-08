

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:intl/intl.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../models/exam_model.dart';
import '../../../styles/text_styles.dart';

class ResultHeaderCard extends StatelessWidget {

  const ResultHeaderCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: ((Get.width-16)*2)/7,
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
            width: ((Get.width-16)*1.45)/7,
            child: CustomText(
              "Practicality",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*1.45)/7,
            child: CustomText(
              "Final Exam",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
          SizedBox(
            width: ((Get.width-16)*0.55)/7,
            child: CustomText(
              "Sum",
              style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5),
            ),
          ),
        ],
      ),
    );
  }
}

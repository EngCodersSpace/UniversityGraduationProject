// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/text_styles.dart';

class PaymentLevelCard extends GetView {
  String title;
  List<StudentFee> payments;

  PaymentLevelCard({required this.title, required this.payments, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: CustomText(
        title,
        style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h2Bold),
      ),
      backgroundColor: AppColors.inverseCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      collapsedIconColor: AppColors.mainCardColor,
      iconColor: AppColors.mainCardColor,
      collapsedBackgroundColor: AppColors.inverseCardColor,
      childrenPadding: const EdgeInsets.all(8),
      children: [
        CustomText(
          title,
          style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h2Bold),
        ),
        CustomText(
          title,
          style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h2Bold),
        ),
        CustomText(
          title,
          style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h2Bold),
        ),
      ],
    );
  }
}

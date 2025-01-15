// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custom_text_v2.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class SortIcon extends GetView {
  SortIcon({required this.icon, this.selected = false,this.onTap, required this.title, super.key});

  String title;
  IconData icon;
  bool selected;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: (selected)?Colors.blueAccent:AppColors.inverseCardColor,
          ),
          CustomText(
            title,
            style: AppTextStyles.customColorStyle(textHeader: AppTextHeaders.h5Bold, color: (selected)?Colors.blueAccent:AppColors.inverseCardColor,),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/init_app_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';

import '../../styles/text_styles.dart';

class SplashScreen extends GetView<InitAppController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.tabBackColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/ibb_university_logo.png",
                  fit: BoxFit.fitHeight),
              CustomText("Student Services Application",style: AppTextStyles.secStyle(
                  textHeader: AppTextHeaders.h3Bold),)
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/academic_card_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_tabs/academic_card_info.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_tabs/academic_card_last_payment.dart';

class AcademicCardWebView extends GetView<AcademicCardController> {
  const AcademicCardWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          "Academic Card",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold),
        ),
        backgroundColor: AppColors.tabBackColor,
      ),
      body: Obx(
        () => (controller.loadingState.value)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Builder(
                builder: (ctx) => Container(
                  padding: EdgeInsets.all(24),
                  color: AppColors.tabBackColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.7,
                        child: AcademicCardInfo(),
                      ),
                      SizedBox(
                        width: Get.width * 0.7,
                        child: AcademicCardLastPayment(),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

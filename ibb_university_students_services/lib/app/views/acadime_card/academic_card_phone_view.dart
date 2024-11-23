import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/globals.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_tabs/academic_card_info.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_tabs/academic_card_last_payment.dart';

class AcademicCardPhoneView extends GetView {
  const AcademicCardPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: MainText(
            "Academic Card",
            textColor: AppColors.secTextColor,
          ),
          backgroundColor: AppColors.tabBackColor,
        ),
        body: Builder(
            builder: (ctx) => Container(
              color: AppColors.tabBackColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       SizedBox(
                        height: Get.height*0.65,
                          child: const TabBarView(
                              children: [
                            Center(
                              child: AcademicCardInfo()
                            ),
                            Center(
                              child: AcademicCardLastPayment()
                            )
                          ])),
                      TabPageSelector(
                        selectedColor: AppColors.inverseCardColor,
                      ),
                      SizedBox(
                        height: Get.height*0.1,
                      )
                    ],
                  ),
            )),
      ),
    );
  }
}

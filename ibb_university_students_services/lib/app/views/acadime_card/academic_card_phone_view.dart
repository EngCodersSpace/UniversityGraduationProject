import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/academic_card_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_tabs/academic_card_info.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_tabs/academic_card_last_payment.dart';

class AcademicCardPhoneView extends GetView<AcademicCardController> {
  const AcademicCardPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: MainText(
              "Academic Card",
              textColor: AppColors.secTextColor,
            ),
            backgroundColor: AppColors.tabBackColor,
          ),
          body: Obx(()=>(controller.loadingState.value)?const Center(child: CircularProgressIndicator(),):
            Builder(
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
                        SizedBox(
                          height: Get.height*0.03,
                        ),
                        TabPageSelector(
                          selectedColor: AppColors.inverseCardColor,
                        ),

                      ],
                    ),
              )),
        ),
      )
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/academic_card_controller.dart';
import 'package:ibb_university_students_services/app/models/doctor_model/doctor.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_tabs/academic_card_last_payment.dart';
import 'academic_card_tabs/doctor_academic_card_info.dart';
import 'academic_card_tabs/student_academic_card_info.dart';

class AcademicCardWebView extends GetView<AcademicCardController> {
  const AcademicCardWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => (controller.loadingState.value)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Builder(
                builder: (ctx) => Container(
                  color: AppColors.tabBackColor,
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      if (controller.user is Doctor) ...[
                        SizedBox(
                          width: Get.width * 0.4,
                          height: Get.height * 0.4,
                          child: const Center(child: DoctorAcademicCardInfo()),
                        ),
                      ] else ...[
                        Column(
                          children: [
                            SizedBox(
                              width: Get.width * 0.4,
                              height: Get.height * 0.4,
                              child: StudentAcademicCardInfo(),
                            ),
                            SizedBox(
                              height: Get.height * 0.03,
                            ),
                            SizedBox(
                              width: Get.width * 0.4,
                              height: Get.height * 0.4,
                              child: AcademicCardLastPayment(),
                            ),
                          ],
                        )
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

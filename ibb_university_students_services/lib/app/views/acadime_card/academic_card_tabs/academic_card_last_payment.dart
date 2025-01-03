import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/academic_card_controller.dart';
import 'package:ibb_university_students_services/app/models/student_model.dart';

import '../../../components/custom_text.dart';
import '../../../styles/app_colors.dart';

class AcademicCardLastPayment extends GetView<AcademicCardController> {
  const AcademicCardLastPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(()=>SizedBox(
      width: Get.width * 0.88,
      child: Card(
          color: Colors.white,
          elevation: 8,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(24)),
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RotatedBox(
                            quarterTurns: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SecText(
                                  "10,000 YR",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                SecText(
                                  "  :المبلغ",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SecText(
                                  "الثاني",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                SecText(
                                  "  :القسط",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RotatedBox(
                            quarterTurns: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SecText(
                                  "مستجد",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                SecText(
                                  "  :الحالة الدراسية",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SecText(
                                  controller.user?.value.section?.nameData?["ar"]??"??",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                SecText(
                                  "  :التخصص",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if(controller.user?.value is Student)...[
                                  SecText(
                                    (controller.user?.value as Student).level?.name??"??",
                                    textColor: AppColors.inverseCardColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ]else...[
                                  SecText("??")
                                ],                                 
                                SecText(
                                  "  :المستوى",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RotatedBox(
                            quarterTurns: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SecText(
                                  "2024 / 10 / 25",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                SecText(
                                  "  :تاريخ الاصدار",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SecText(
                                  "2024 / 2023",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                SecText(
                                  "  :العام الجامعي",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/ibb_university_logo.png",
                              ),
                              fit: BoxFit.contain,
                              opacity: 0.25,
                            )
                        ),
                      )
                  )
                ],
              ),
            ),
          )),
    ));
  }
}

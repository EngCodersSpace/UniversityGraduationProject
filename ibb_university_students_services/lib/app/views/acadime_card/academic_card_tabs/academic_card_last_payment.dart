import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/academic_card_controller.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/text_styles.dart';

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
                                CustomText(
                                  "10,000 YR",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
                                ),
                                CustomText(
                                  "  :المبلغ",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
                                ),
                              ],
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomText(
                                  "الثاني",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
                                ),
                                CustomText(
                                  "  :القسط",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
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
                                CustomText(
                                  "مستجد",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
                                ),
                                CustomText(
                                  "  :الحالة الدراسية",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
                                ),
                              ],
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomText(
                                  controller.user?.value.section?.nameData?["ar"]??"??",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
                                ),
                                CustomText(
                                  "  :التخصص",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
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
                                  CustomText(
                                    (controller.user?.value as Student).level?.name??"??",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
                                  ),
                                ]else...[
                                  CustomText("??")
                                ],                                 
                                CustomText(
                                  "  :المستوى",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
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
                                CustomText(
                                  "2024 / 10 / 25",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
                                ),
                                CustomText(
                                  "  :تاريخ الاصدار",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
                                ),
                              ],
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomText(
                                  "2024 / 2023",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
                                ),
                                CustomText(
                                  "  :العام الجامعي",
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/academic_card_controller.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import 'package:ibb_university_students_services/app/utils/date_time_utils.dart';
import 'package:ibb_university_students_services/app/utils/maping_data.dart';
import 'package:ibb_university_students_services/app/utils/screen_utils.dart';
import '../../../components/custom_text_v2.dart';
import '../../../styles/text_styles.dart';

class AcademicCardLastPayment extends GetView<AcademicCardController> {
  const AcademicCardLastPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (ScreenUtils.isPhoneScreen())
        ? SizedBox(
            width: Get.width * 0.88,
            child: Card(
                color: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(24)),
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
                                          "${controller.lastFee?.value.payedAmount} YR",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
                                      CustomText("  :المبلغ",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
                                    ],
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomText(
                                          mappingTerms(
                                              controller.lastFee?.value.term,
                                              lang: 'ar'),
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
                                      CustomText("  :القسط",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
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
                                          mappingStudentState((controller
                                                      .user?.value as Student)
                                                  .repeatYearsCount ??
                                              0),
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
                                      CustomText("  :الحالة الدراسية",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
                                    ],
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomText(
                                          controller.user?.value.section
                                                  ?.nameData?["ar"] ??
                                              "??",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
                                      CustomText("  :التخصص",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
                                    ],
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (controller.user?.value
                                          is Student) ...[
                                        CustomText(
                                            (controller.user?.value as Student)
                                                    .level
                                                    ?.name ??
                                                "??",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h2Bold)),
                                      ] else ...[
                                        CustomText("??")
                                      ],
                                      CustomText("  :المستوى",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
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
                                          controller
                                                  .lastFee?.value.paymentDate ??
                                              "Unknown".tr,
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
                                      CustomText("  :تاريخ الاصدار",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
                                    ],
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomText(
                                          DateTimeUtils.calcUniversityYear(
                                              (controller.user?.value
                                                          as Student)
                                                      .enrollmentYear ??
                                                  "",
                                              (controller.user?.value
                                                          as Student)
                                                      .level
                                                      ?.id ??
                                                  0,
                                              (controller.user?.value
                                                          as Student)
                                                      .repeatYearsCount ??
                                                  0),
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
                                      CustomText("  :العام الجامعي",
                                          style: AppTextStyles.secStyle(
                                              textHeader:
                                                  AppTextHeaders.h2Bold)),
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
                              )),
                            ))
                      ],
                    ),
                  ),
                )),
          )
        : RotatedBox(
            quarterTurns: 3,
            child: SizedBox(
              width: Get.width * 0.5,
              child: Card(
                  color: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(24)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomText(
                                            "${controller.lastFee?.value.payedAmount} YR",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                        CustomText("  :المبلغ",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                      ],
                                    ),
                                  ),
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomText(
                                            mappingTerms(
                                                controller.lastFee?.value.term,
                                                lang: 'ar'),
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                        CustomText("  :القسط",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomText(
                                            mappingStudentState((controller
                                                        .user?.value as Student)
                                                    .repeatYearsCount ??
                                                0),
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                        CustomText("  :الحالة الدراسية",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                      ],
                                    ),
                                  ),
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomText(
                                            controller.user?.value.section
                                                    ?.nameData?["ar"] ??
                                                "??",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                        CustomText("  :التخصص",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                      ],
                                    ),
                                  ),
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (controller.user?.value
                                            is Student) ...[
                                          CustomText(
                                              (controller.user?.value
                                                          as Student)
                                                      .level
                                                      ?.name ??
                                                  "??",
                                              style: AppTextStyles.secStyle(
                                                  textHeader:
                                                      AppTextHeaders.h3Bold)),
                                        ] else ...[
                                          CustomText("??")
                                        ],
                                        CustomText("  :المستوى",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomText(
                                            controller.lastFee?.value
                                                    .paymentDate ??
                                                "Unknown".tr,
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                        CustomText("  :تاريخ الاصدار",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                      ],
                                    ),
                                  ),
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomText(
                                            DateTimeUtils.calcUniversityYear(
                                                (controller.user
                                                            ?.value as Student)
                                                        .enrollmentYear ??
                                                    "",
                                                (controller.user?.value
                                                            as Student)
                                                        .level
                                                        ?.id ??
                                                    0,
                                                (controller.user?.value
                                                            as Student)
                                                        .repeatYearsCount ??
                                                    0),
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
                                        CustomText("  :العام الجامعي",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                    AppTextHeaders.h3Bold)),
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
                                )),
                              ))
                        ],
                      ),
                    ),
                  )),
            ),
          ));
  }
}

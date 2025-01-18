// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:intl/intl.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class PaymentsCard extends StatelessWidget {
  Rx<StudentFee> studentFee;

  PaymentsCard({
    required this.studentFee,
    super.key,
  });

  DateFormat timeFormat = DateFormat("hh:mm a");

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.only(bottom: 10),
          margin:  const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.mainCardColor,
            border: Border(
              bottom: BorderSide(
                  color: AppColors.inverseCardColor, width: 2, strokeAlign: 1),
              right: BorderSide(
                  color: AppColors.inverseCardColor, width: 2, strokeAlign: 1),
              left: BorderSide(
                  color: AppColors.inverseCardColor, width: 2, strokeAlign: 1),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 5),
              )
            ],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.inverseCardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.mainCardColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CustomText(studentFee.value.paymentDate ?? "",style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Normal,),),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.mainCardColor,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(32)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CustomText("Level ${(studentFee.value.levelId??0)+1}".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Normal,),),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.mainCardColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CustomText("Term ${studentFee.value.term}".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Normal,),),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomText(
                      "Receipt Number : ${studentFee.value.receiptNumber ?? "Unknown".tr}",
                      style: AppTextStyles.mainStyle(
                          textHeader: AppTextHeaders.h2Bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            "Total Amount",
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Bold),
                          ),
                          CustomText(
                            "${studentFee.value.totalAmount ?? "Unknown".tr} YR",
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Bold),
                          ),

                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            "Payed Amount",
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Bold),
                          ),
                          CustomText(
                            "${studentFee.value.payedAmount ?? "Unknown".tr} YR",
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Bold),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            "Remain Amount",
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Bold),
                          ),
                          CustomText(
                            "${studentFee.value.remainAmount ?? "Unknown".tr} YR",
                            style: AppTextStyles.secStyle(
                                textHeader: AppTextHeaders.h3Bold),
                          ),
                        ],
                      ),
                    ]
                ),
              )
            ],
          ),
        ));
  }
}

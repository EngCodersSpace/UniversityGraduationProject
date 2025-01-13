import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/payments_controller.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/payments_view/payments_view_components/payment_card.dart';

class PaymentsPhoneView extends GetView<PaymentsController> {
  const PaymentsPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tabBackColor,
        title: CustomText("Student Payments",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2),),
      ),
      body: Container(
        color: AppColors.tabBackColor,
        // margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for(int i = 0; i < 5; i++)...[
                PaymentsCard(studentFee: Rx(StudentFee(id: 1,
                    term: 2,
                    levelId: i,
                    payedAmount: 10000,
                    totalAmount: 10000,
                    paymentDate: "2024-10-10",
                    paymentState: "Payed",
                    receiptNumber: "1056896247",
                    remainAmount: 0))),
                const SizedBox(height: 24,)
              ]
            ],
          ),
        ),
      ),
    );
  }
}

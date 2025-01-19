import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/payments_controller.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/permission_checker.dart';
import 'package:ibb_university_students_services/app/views/payments_view/payments_view_components/payment_card.dart';

import '../../components/buttons.dart';
import '../../components/text_field.dart';
import '../../utils/validators.dart';

class PaymentsPhoneView extends GetView<PaymentsController> {
  const PaymentsPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tabBackColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.inverseIconColor,
                    size: 30,
                  )),
              const SizedBox(width: 32,),
              CustomText(
                "Student Payments".tr,
                style: AppTextStyles.secStyle(
                    textHeader: AppTextHeaders.h2Bold),
              ),
            ],
          ),
          if (PermissionUtils.checkPermission(
              target: "Payments", action: "studentSearch")) ...[
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextFormField(
                  controller: controller.id,
                  validator: (id) => Validators.validateID(id),
                  labelText: "Student ID".tr,
                  icon: Icons.account_circle_outlined,
                  color: AppColors.inverseIconColor,
                  width: Get.width * 0.65,
                  onFieldSubmitted: (e) {},
                ),
                CustomButton(
                  onPress: controller.findButtonClick,
                  text: "Find".tr,
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  "Payments".tr,
                  style: AppTextStyles.highlightStyle(
                      textHeader: AppTextHeaders.h2Bold),
                ),
                if ((PermissionUtils.checkPermission(
                    target: "Exams", action: "add")))
                  CustomButton(
                    onPress: controller.addButtonClick,
                    text: "Add Exam".tr,
                  ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => controller.refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (int i = 0; i < 5; i++) ...[
                      PaymentsCard(
                          studentFee: Rx(StudentFee(
                              id: 1,
                              term: 2,
                              levelId: i,
                              payedAmount: 10000,
                              totalAmount: 10000,
                              paymentDate: "2024-10-10",
                              paymentState: "Payed",
                              receiptNumber: "1056896247",
                              remainAmount: 0))),
                      const SizedBox(
                        height: 24,
                      )
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

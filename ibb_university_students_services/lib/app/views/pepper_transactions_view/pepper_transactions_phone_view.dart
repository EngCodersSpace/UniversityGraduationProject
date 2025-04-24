import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/pepper_transactions_controller.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';


class PepperTransactionsPhoneView extends GetView<PepperTransactionsController> {
  const PepperTransactionsPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.tabBackColor,
        padding: const EdgeInsets.all(16),
        child: Obx(() => (controller.loadingState.value)
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Placeholder(),)
    );
  }
}

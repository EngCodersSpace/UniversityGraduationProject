import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/controllers/academic_card_controller.dart';
import 'package:ibb_university_students_services/app/controllers/student_fees_controller.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/validators.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_tabs/academic_card_info.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_tabs/academic_card_last_payment.dart';
import 'package:ibb_university_students_services/app/views/student_fees_view/student_fees_view_components/student_fees_card.dart';

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        height: Get.height * 0.1,
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.mainCardColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 5),
                            )
                          ],
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(32)),
                        ),
                        child: Expanded(
                          child: GetBuilder<StudentFeeController>(
                              builder: (controller) {
                            return Row(
                              children: [
                                if (UserRepository.checkPermission(
                                    target: "Payments",
                                    action: "studentSearch")) ...[
                                  CustomTextFormField(
                                    controller: controller.idController,
                                    validator: (id) =>
                                        Validators.validateID(id),
                                    labelText: "Student ID",
                                    keyboardType: TextInputType.number,
                                    color: AppColors.inverseIconColor,
                                    width: Get.width * 0.3,
                                    onFieldSubmitted: (e) =>
                                        controller.findButtonClick(),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.02,
                                  ),
                                  CustomButton(
                                    onPress: controller.findButtonClick,
                                    text: "Find".tr,
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.2,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if ((UserRepository.checkPermission(
                                          target: "StudentFee",
                                          action: "write")))
                                        CustomButton(
                                          onPress: controller.addButtonClick,
                                          text: "Add Payment".tr,
                                        ),
                                    ],
                                  ),
                                ]
                              ],
                            );
                          }),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: Get.width * 0.4,
                                height: Get.height * 0.4,
                                child: AcademicCardInfo(),
                              ),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                              SizedBox(
                                width: Get.width * 0.4,
                                height: Get.height * 0.4,
                                child: AcademicCardLastPayment(),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                child: GetBuilder<StudentFeeController>(
                                    builder: (controller) {
                                  return RefreshIndicator(
                                    onRefresh: () async => controller.refresh(),
                                    child: SingleChildScrollView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      clipBehavior: Clip.antiAlias,
                                      child: Obx(
                                        () => Column(
                                          children: [
                                            if (controller
                                                .studentFees.isEmpty) ...[
                                              SizedBox(
                                                height: Get.height * 0.2,
                                              ),
                                              Center(
                                                  child: CustomText(
                                                controller.fieldMessage.value,
                                                style: AppTextStyles.secStyle(
                                                    textHeader:
                                                        AppTextHeaders.h2Bold),
                                              )),
                                              if (controller.studentId != null)
                                                IconButton(
                                                    onPressed: () async =>
                                                        controller.refresh(),
                                                    icon: const Icon(
                                                      Icons.refresh,
                                                      size: 40,
                                                    ))
                                            ],
                                            for (int i = 0;
                                                i <
                                                    (controller
                                                        .studentFees.length);
                                                i++) ...[
                                              StudentFeeCard(
                                                  studentFee: Rx<StudentFee>(
                                                      controller
                                                          .studentFees.values
                                                          .toList()[i])),
                                              const SizedBox(
                                                height: 24,
                                              )
                                            ]
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

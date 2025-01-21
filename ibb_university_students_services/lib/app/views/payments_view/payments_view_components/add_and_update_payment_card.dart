import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/payments_controller.dart';
import '../../../components/buttons.dart';
import '../../../components/text_field.dart';
import '../../../models/level_model/level.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';
import '../../../utils/date_time_utils.dart';

class PopUpIAddAndUpdatePaymentCard extends GetView<PaymentsController> {
  const PopUpIAddAndUpdatePaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "PopUpInsertCard",
          child: Material(
            color: AppColors.mainCardColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
                side: BorderSide(
                  color: AppColors.inverseCardColor,
                  width: 3,
                )),
            child: SizedBox(
                height: Get.height * 0.6,
                width: Get.width,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText("${controller.mode} Payment",
                              style: AppTextStyles.secStyle(
                                  textHeader: AppTextHeaders.h2Bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Level".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader:
                                          AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    width: 70,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                        BorderRadius.circular(24)),
                                    child: Center(
                                      child: Obx(() => DropdownButton<int>(
                                        value: controller.level.value,
                                        icon: Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color:
                                            AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor:
                                        AppColors.mainCardColor,
                                        onChanged: (val) {
                                          if (val == null) return;
                                          controller.level.value = val;
                                        },
                                        isExpanded: true,
                                        items: [
                                          for (Level level
                                          in (controller.levels ??
                                              [])) ...[
                                            DropdownMenuItem<int>(
                                                value: level.id,
                                                child: Center(
                                                  child: CustomText(
                                                    level.name ?? "",
                                                    style: AppTextStyles
                                                        .secStyle(
                                                        textHeader:
                                                        AppTextHeaders
                                                            .h3Bold),
                                                  ),
                                                )),
                                          ]
                                        ],
                                      )),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText("Semester".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader:
                                          AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    width: 80,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                        BorderRadius.circular(24)),
                                    child: Center(
                                      child: Obx(() => DropdownButton<String>(
                                        value:
                                        controller.selectedTerm.value,
                                        icon: Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color:
                                            AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor:
                                        AppColors.mainCardColor,
                                        onChanged: (val) {
                                          if (val == null) return;
                                          controller.selectedTerm.value =
                                              val;
                                        },
                                        isExpanded: true,
                                        items: [
                                          DropdownMenuItem<String>(
                                              value: "Term 1",
                                              child: Center(
                                                child: CustomText(
                                                  "1St",
                                                  style:
                                                  AppTextStyles.secStyle(
                                                      textHeader:
                                                      AppTextHeaders
                                                          .h3Bold),
                                                ),
                                              )),
                                          DropdownMenuItem<String>(
                                              value: "Term 2",
                                              child: Center(
                                                child: CustomText(
                                                  "2ec",
                                                  style:
                                                  AppTextStyles.secStyle(
                                                      textHeader:
                                                      AppTextHeaders
                                                          .h3Bold),
                                                ),
                                              )),
                                        ],
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Date".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.dateController,
                                // validator: controller.validateDate,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                                labelText: 'Date'.tr,
                                readOnly: true,
                                onTap: () => DateTimeUtils.datePiker(
                                    context, controller.dateController),
                                width: (Get.width - 12) * 0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Total\nAmount".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.totalAmountController,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                                // validator: controller.validateTime,
                                keyboardType: TextInputType.number,
                                labelText: "Total Amount".tr,
                                focusNode: controller.totalAmountFocus,
                                onFieldSubmitted: (e) {
                                  controller.payedAmountFocus.requestFocus();
                                },
                                width: (Get.width - 12) * 0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Payed\nAmount".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.payedAmountController,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                                // validator: controller.validateTime,
                                keyboardType: TextInputType.number,
                                labelText: "Payed Amount".tr,
                                focusNode: controller.payedAmountFocus,
                                onFieldSubmitted: (e) {
                                  controller.receiptNumberFocus.requestFocus();
                                },
                                width: (Get.width - 12) * 0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled,
                                    size: 40,
                                    color: AppColors.inverseIconColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Receipt\nNumber".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.receiptNumberController,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                                // validator: controller.validateTime,
                                keyboardType: TextInputType.number,
                                labelText: "Receipt Number".tr,
                                focusNode: controller.receiptNumberFocus,
                                onFieldSubmitted: (e) {
                                  controller.submit();
                                },
                                width: (Get.width - 12) * 0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                onPress: controller.submit,
                                text: (controller.mode).tr,
                              ),
                              CustomButton(
                                onPress: () => Get.back(result: null),
                                text: "Close".tr,
                              ),
                            ],
                          )
                        ],
                      ),
                    ))),
          ),
        ),
      ),
    );
  }
}

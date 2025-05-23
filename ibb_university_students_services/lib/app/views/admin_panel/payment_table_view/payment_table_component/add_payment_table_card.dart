import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_payment_table_controller.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/payment_table_view/payment_table_component/popup_add_payment_component.dart';

class PopUpAddPaymentCard extends GetView<DashboardPaymentTableController> {
  const PopUpAddPaymentCard({super.key});

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
                height: Get.height * 0.9,
                width: Get.width * 0.4,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PopupAddPaymentComponent(
                            name: "Student ID",
                            controlName: controller.studentId,
                            focusName: controller.idFocus,
                            inputType: TextInputType.number,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText("Level".tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h3Bold)),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                              Container(
                                width: Get.width * 0.23,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Obx(() => DropdownButton<int?>(
                                        value: controller.levelId.value,
                                        icon: Icon(Icons.arrow_drop_down_sharp,
                                            color: AppColors.inverseCardColor),
                                        underline: const SizedBox(),
                                        dropdownColor: AppColors.mainCardColor,
                                        onChanged: (val) {
                                          if (val == null) return;
                                          controller.levelId.value = val;
                                        },
                                        isExpanded: true,
                                        menuWidth: Get.width * 0.3,
                                        selectedItemBuilder: (_) {
                                          List<Widget> items = [];
                                          for (Level levelI
                                              in (controller.level ?? [])) {
                                            items.add(DropdownMenuItem<int?>(
                                              value: levelI.id,
                                              child: SizedBox(
                                                  width: Get.width * 0.28,
                                                  child: CustomText(
                                                    levelI.name ?? "Unknown".tr,
                                                    style:
                                                        AppTextStyles.secStyle(
                                                            textHeader:
                                                                AppTextHeaders
                                                                    .h3Bold),
                                                    softWrap: false,
                                                  )),
                                            ));
                                          }
                                          return items;
                                        },
                                        items: [
                                          for (Level levelI
                                              in (controller.level ?? [])) ...[
                                            DropdownMenuItem<int?>(
                                                value: levelI.id,
                                                child: Column(
                                                  children: [
                                                    CustomText(
                                                      levelI.name ?? "Unknown",
                                                      style: AppTextStyles
                                                          .secStyle(
                                                              textHeader:
                                                                  AppTextHeaders
                                                                      .h3Bold),
                                                    ),
                                                    // Divider(color: AppColors.highlightTextColor,)
                                                  ],
                                                )),
                                          ]
                                        ],
                                      )),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Term".tr,
                                style: AppTextStyles.secStyle(
                                    textHeader: AppTextHeaders.h3Bold),
                              ),
                              SizedBox(
                                width: Get.width * 0.002,
                              ),
                              Container(
                                // height: Get.height * 0.06,
                                width: Get.width * 0.23,
                                decoration: BoxDecoration(
                                  color: AppColors.mainIconColor,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(),
                                ),
                                child: Center(
                                  child: Obx(() => DropdownButton(
                                        items: controller.addterm,
                                        onChanged: controller.changeAddTerm,
                                        value: controller.addTerm.value,
                                        underline: const SizedBox(),
                                        iconEnabledColor:
                                            AppColors.inverseCardColor,
                                        dropdownColor: AppColors.mainCardColor,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          PopupAddPaymentComponent(
                              name: "Amount paid",
                              controlName: controller.amountPaid,
                              focusName: controller.amountFocus,
                              inputType: TextInputType.number),
                          PopupAddPaymentComponent(
                              name: "Payment date",
                              controlName: controller.payDate,
                              focusName: controller.dateFocus,
                              inputType: TextInputType.datetime),
                          PopupAddPaymentComponent(
                              name: "Reciept number",
                              controlName: controller.reciptNum,
                              focusName: controller.reciptFocus,
                              inputType: TextInputType.number),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                  onPress: controller.addPayment, text: "Add"),
                              CustomButton(
                                onPress: () =>
                                    Navigator.of(Get.overlayContext!).pop(),
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

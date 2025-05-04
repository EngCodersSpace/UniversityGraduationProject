import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/profile_tab_controller.dart';
import 'package:ibb_university_students_services/app/utils/validators.dart';
import '../../../components/buttons.dart';
import '../../../components/text_field.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/text_styles.dart';

class PopUpChangePasswordCard extends GetView<ProfileController> {
  const PopUpChangePasswordCard({super.key});



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

                )
            ),
            child: SizedBox(
                height: Get.height * 0.4,
                width: Get.width,
                child: SafeArea(
                    minimum: const EdgeInsets.all(12),
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText("Change Password".tr,
                              style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h2Bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Old Password".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.oldPassword,
                                isPassword: true,
                                validator: Validators.validatePassword,
                                labelText: "Old Password".tr,
                                keyboardType: TextInputType.text,
                                focusNode: controller.oldPasswordFocus,
                                onFieldSubmitted: (e) {
                                  controller.newPasswordFocus.requestFocus();
                                },
                                width: (Get.width-12)*0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("New Password".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.newPassword,
                                validator: Validators.validatePassword,
                                isPassword: true,
                                keyboardType: TextInputType.text,
                                labelText: "New Password".tr,
                                focusNode: controller.newPasswordFocus,
                                onFieldSubmitted: (e) {
                                  controller.passwordConfirmationFocus.requestFocus();
                                },
                                width: (Get.width-12)*0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText("Confirmation".tr, style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)),
                                ],
                              ),
                              CustomTextFormField(
                                controller: controller.passwordConfirmation,
                                validator: (conf)=>Validators.confirmPassword(controller.newPassword.text, conf??""),
                                isPassword: true,
                                keyboardType: TextInputType.text,
                                labelText: "Password Confirmation".tr,
                                focusNode: controller.passwordConfirmationFocus,
                                onFieldSubmitted: (e) {
                                  controller.changePassword();
                                },
                                width: (Get.width-12)*0.46,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                onPress: controller.changePassword,
                                text: "Change".tr,
                              ),
                              CustomButton(
                                onPress: () => Navigator.of(Get.overlayContext!).pop(),
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

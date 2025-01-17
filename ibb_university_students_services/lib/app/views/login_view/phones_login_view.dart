// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/validators.dart';

import '../../components/custom_text_v2.dart';
import '../../controllers/login_controller.dart';

class PhoneLoginView extends GetView<LoginController> {
  PhoneLoginView({
    super.key,
  });

  double height = Get.height;
  double width = (Get.width - 20);

  List<PopupMenuItem<String>> menuItems = [
    PopupMenuItem<String>(value: "en", child: CustomText("English")),
    PopupMenuItem<String>(value: "ar", child: CustomText("العربية")),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.loading.value)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: (height * 0.5),
                    width: width,
                    child: Image.asset("assets/images/login_background_1.jpeg",
                        fit: BoxFit.fill),
                  ),
                  SizedBox(
                    height: (height * 0.5),
                    width: width,
                  ),
                ],
              ),
              Container(color: AppColors.coverColor),
              SizedBox(
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    SizedBox(
                      height: height * 0.25,
                      child: Image.asset(
                          "assets/images/ibb_university_logo.png",
                          fit: BoxFit.fill),
                    ),
                    Container(
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                      child: Column(
                        children: [
                          CustomText(
                            "IBB",
                            style: AppTextStyles.mainStyle(
                                textHeader: AppTextHeaders.h1Bold),
                          ),
                          CustomText(
                            "UNIVERSITY",
                            style: AppTextStyles.mainStyle(
                                textHeader: AppTextHeaders.h1Bold),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Expanded(child: Container()),
                  Obx(
                    () => Container(
                        width: Get.width,
                        constraints: BoxConstraints(
                          minHeight: height * controller.heightScale.value,
                          maxHeight: height *0.62
                        ),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.backColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                        ),
                        child: Form(
                          key: controller.formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width*0.2,
                                    child: PopupMenuButton<String>(
                                      initialValue:
                                      Get.locale?.languageCode.toString(),
                                      itemBuilder: (BuildContext context) =>
                                      menuItems,
                                      color: AppColors.mainCardColor,
                                      onSelected: (lang) {
                                        controller.changeLang(lang);
                                      },
                                      child: Row(
                                        children: (Get.locale?.languageCode
                                            .toString() ==
                                            "en")
                                            ? [
                                          const Icon(
                                            Icons.language,
                                            color: Colors.blueGrey,
                                          ),
                                          CustomText(
                                            "English",
                                            style: AppTextStyles.secStyle(
                                                textHeader:
                                                AppTextHeaders.h3Bold),
                                          ),
                                        ]
                                            : [
                                          const Icon(Icons.language,color: Colors.blueGrey,),
                                          CustomText("العربية",
                                              style: AppTextStyles.secStyle(
                                                  textHeader:
                                                  AppTextHeaders.h3Bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.53,
                                    child: CustomText(
                                      'login'.tr,
                                      style: AppTextStyles.secStyle(
                                          textHeader: TextHeaders(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.6 * 0.1,
                              ),
                              CustomTextFormField(
                                controller: controller.id,
                                validator: (id) => Validators.validateID(id),
                                labelText: "User ID".tr,
                                icon: Icons.account_circle_outlined,
                                color: AppColors.inverseIconColor,
                                focusNode: controller.idFocus,
                                onFieldSubmitted: (e) {
                                  controller.idFocus.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(controller.passwordFocus);
                                },
                                onTap: () {
                                  controller.heightScale.value = 0.8;
                                },
                                onTapOutside: (e) {
                                  controller.idFocus.unfocus();
                                  controller.heightScale.value = 0.6;
                                },
                              ),
                              SizedBox(
                                height: height * 0.6 * 0.05,
                              ),
                              CustomTextFormField(
                                controller: controller.password,
                                validator: (pwd) =>
                                    Validators.validatePassword(pwd),
                                labelText: "Password".tr,
                                icon: Icons.key_sharp,
                                color: AppColors.inverseIconColor,
                                isPassword: true,
                                focusNode: controller.passwordFocus,
                                onTap: () {
                                  controller.heightScale.value = 0.8;
                                },
                                onTapOutside: (e) {
                                  controller.passwordFocus.unfocus();
                                  controller.heightScale.value = 0.6;
                                },
                                onFieldSubmitted: (str) {
                                  controller.heightScale.value = 0.6;
                                  controller.onLogin();
                                },
                              ),
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: TextButton(
                                  onPressed: () => controller.forgotPassword,
                                  child: CustomText("Forgot Password?".tr,
                                      style: AppTextStyles.linkStyle(
                                          textHeader: AppTextHeaders.h3Normal)),
                                ),
                              ),
                              if (controller.loggingFiled.value) ...[
                                CustomText("Login Filed",
                                    style: AppTextStyles.failedAndErrorStyle(
                                        textHeader: AppTextHeaders.h3Normal)),
                                CustomText(controller.loggingFiledMessage.value,
                                    style: AppTextStyles.failedAndErrorStyle(
                                        textHeader: AppTextHeaders.h3Normal)),
                              ],
                              SizedBox(
                                height: height * 0.05,
                              ),
                              Obx(() => (controller.logging.value)
                                  ? CustomButton(
                                      onPress: controller.onLogin,
                                      text: 'logging'.tr,
                                      icon: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          color: AppColors.backColor,
                                        ),
                                      ),
                                      size: Size(width * 0.8, 50),
                                    )
                                  : CustomButton(
                                      onPress: controller.onLogin,
                                      text: 'login'.tr,
                                      icon: (Get.locale.toString() == "en_US")
                                          ? Icon(
                                              Icons.login,
                                              color: AppColors.mainTextColor,
                                            )
                                          : RotatedBox(
                                              quarterTurns: 2,
                                              child: Icon(Icons.login,
                                                  color:
                                                      AppColors.mainTextColor)),
                                      size: Size(width * 0.8, 50))),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomText("Remember me".tr,
                                      style: AppTextStyles.linkStyle(
                                          textHeader: AppTextHeaders.h3Normal)),
                                  Checkbox(
                                      value: controller.rememberMe.value,
                                      onChanged: controller.toggleRememberMe),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                            ],
                          ),
                        )),
                  )
                ],
              )
            ],
          ));
  }
}

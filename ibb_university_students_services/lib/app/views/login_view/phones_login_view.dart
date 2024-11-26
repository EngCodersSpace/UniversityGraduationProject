// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/globals.dart';

import '../../controllers/login_controller.dart';

class PhoneLoginView extends GetView<LoginController> {
  PhoneLoginView({
    super.key,
  });

  double height = Get.height;
  double width = Get.width;

  List<PopupMenuItem<String>> menuItems = [
    PopupMenuItem<String>(value: "en", child: SecText("En")),
    PopupMenuItem<String>(value: "ar", child: SecText("Ar")),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                child: Image.asset("assets/images/ibb_university_logo.png",
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
                    MainText(
                      "IBB",
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                    MainText(
                      "UNIVERSITY",
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
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
        Obx(
          () => Container(
              width: width,
              height: height * controller.heightScale.value,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Form(
                key: controller.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width * 0.35 * 0.2,
                        ),
                        MainText('login'.tr,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            textColor: Colors.black),
                        PopupMenuButton<String>(
                          initialValue: Get.locale?.languageCode.toString(),
                          itemBuilder: (BuildContext context) => menuItems,
                          onSelected: (lang) {
                            controller.changeLang(lang);
                          },
                          child: Row(
                            children:
                                (Get.locale?.languageCode.toString() == "en")
                                    ? [
                                        const Icon(Icons.language),
                                        SecText("En"),
                                      ]
                                    : [
                                        SecText("Ar"),
                                        const Icon(Icons.language),
                                      ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.6 * 0.1,
                    ),
                    CustomTextFormField(
                      controller: controller.id,
                      validator: (id) => controller.validateID(id),
                      labelText: 'studentid'.tr,
                      icon: Icons.account_circle_outlined,
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
                      validator: (pwd) => controller.validatePassword(pwd),
                      labelText: 'password'.tr,
                      icon: Icons.key_sharp,
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
                        child: SecText(
                          "forgotPassword?".tr,
                          textColor: AppColors.linkTextColor,
                        ),
                      ),
                    ),
                    if(controller.loggingFiled.value)...[
                      SecText("Login Filed",textColor: Colors.redAccent,),
                      SecText(controller.loggingFiledMessage.value,textColor: Colors.redAccent),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SecText("Remember me",textColor: AppColors.linkTextColor),
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
    );
  }
}

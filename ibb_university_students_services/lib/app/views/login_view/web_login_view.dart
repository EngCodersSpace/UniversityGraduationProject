// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/utils/validators.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_v2.dart';
import '../../components/text_field.dart';
import '../../controllers/login_controller.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

class WebLoginView extends GetView<LoginController> {
  WebLoginView({
    super.key,
  });

  double height = Get.height;
  double width = Get.width;

  List<PopupMenuItem<String>> menuItems = [
    PopupMenuItem<String>(
        value: "en",
        child: CustomText("En",
            style: AppTextStyles.secStyle(
              textHeader: AppTextHeaders.h3Normal,
            ))),
    PopupMenuItem<String>(
        value: "ar",
        child: CustomText("Ar",
            style: AppTextStyles.secStyle(
              textHeader: AppTextHeaders.h3Normal,
            ))),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          child: Image.asset("assets/images/ibb_background_6.jpeg",
              fit: BoxFit.fill),
        ),
        Container(
          color: AppColors.coverColor.withValues(alpha: 0.0),
        ),
        Container(
          color: AppColors.coverColor.withValues(alpha: 0.0),
        ),
        Container(
          color: AppColors.coverColor.withValues(alpha: 0.0),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              Image.asset("assets/images/ibb_university_logo.png",
                  fit: BoxFit.fitHeight),
              //container hold universityName
              Container(
                decoration: const BoxDecoration(
                    gradient: RadialGradient(
                        colors: [
                      Colors.transparent,
                      Colors.black87,
                      Colors.black54
                    ],
                        center: Alignment.bottomCenter,
                        focal: Alignment.bottomCenter,
                        radius: 0.1,
                        focalRadius: 1)),
                child: Column(
                  children: [
                    CustomText(
                      "IBB",
                      style: AppTextStyles.mainStyle(textHeader: TextHeaders(fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                    CustomText(
                      "UNIVERSITY",
                      style: AppTextStyles.mainStyle(textHeader: TextHeaders(fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              Container(
                  width: width * 0.25,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.backColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Form(
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // SizedBox(
                            //   width: ((width * 0.35) - 194) * (1 / 3),
                            // ),
                            SizedBox(
                              width: ((width * 0.35) - 194) * (1 / 3),
                            ),
                            SizedBox(
                              width: ((width * 0.35) - 194) * (1 / 3),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText('login'.tr,
                                        style: AppTextStyles.secStyle(
                                          textHeader: AppTextHeaders.h2Bold,
                                        )),
                                  ]),
                            ),
                            SizedBox(
                              width: ((width * 0.35) - 194) * (1 / 3),
                              child: PopupMenuButton<String>(
                                initialValue:
                                    Get.locale?.languageCode.toString(),
                                itemBuilder: (BuildContext context) =>
                                    menuItems,
                                onSelected: (lang) {
                                  controller.changeLang(lang);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children:
                                      (Get.locale?.languageCode.toString() ==
                                              "en")
                                          ? [
                                              const Icon(Icons.language),
                                              CustomText("En"),
                                            ]
                                          : [
                                              CustomText("Ar"),
                                              const Icon(Icons.language),
                                            ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.6 * 0.1,
                        ),
                        CustomTextFormField(
                          width: width,

                          controller: controller.id,
                          validator: (id) => Validators.validateID(id),
                          labelText: "User ID".tr,
                          //icon: Icons.account_circle_outlined,
                        ),
                        SizedBox(
                          height: height * 0.6 * 0.05,
                        ),
                        CustomTextFormField(
                            controller: controller.password,
                            validator: (pwd) =>
                                Validators.validatePassword(pwd),
                            labelText: "Password".tr,
                            //icon: Icons.key_sharp,
                            //icon: Icons.key_sharp,
                            //icon: Icons.key_sharp,
                            isPassword: true,
                            onFieldSubmitted: (e) {
                              controller.onLogin();
                            }),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: () => controller.forgotPassword,
                            child: CustomText("Forgot Password?".tr,
                                style: AppTextStyles.highlightStyle(
                                  textHeader: AppTextHeaders.h6Bold,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.6 * 0.1,
                        ),
                        Obx(() => (controller.logging.value)
                            ? CustomButton(
                                onPress: controller.onLogin,
                                text: 'logging',
                                icon: CircularProgressIndicator(
                                  color: AppColors.backColor,
                                ),
                                size: Size(width * 0.8, 40),
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
                                            color: AppColors.mainTextColor)),
                                size: Size(width * 0.15, 40),
                              )),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomText("Remember me",
                                style: AppTextStyles.linkStyle(
                                  textHeader: AppTextHeaders.h3Normal,
                                )),
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
            ],
          ),
        )
      ],
    );
  }
}

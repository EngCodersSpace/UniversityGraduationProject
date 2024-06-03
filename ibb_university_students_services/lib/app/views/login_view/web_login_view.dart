// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/buttons.dart';
import '../../components/custom_text.dart';
import '../../components/text_field.dart';
import '../../controllers/login_controller.dart';
import '../../globals.dart';

class WebLoginView extends StatelessWidget {
  WebLoginView({
    super.key,
    this.height,
    this.width,
  });

  double? height;
  double? width;
  LoginController controller = Get.find();

  List<PopupMenuItem<String>> menuItems = [
    PopupMenuItem<String>(value: "en", child: SecText("En")),
    PopupMenuItem<String>(value: "ar", child: SecText("Ar")),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          child:
              Image.asset("assets/images/login_background_1.jpeg", fit: BoxFit.fill),
        ),
        Container(
          color: const Color.fromRGBO(0, 191, 255, 0.25),
        ),
        Column(
          children: [
            SizedBox(
              height: height! * 0.05,
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
                  MainText(
                    "IBB",
                    fontWeight: FontWeight.bold,
                    fontSize: height! * 0.15 / 4,
                  ),
                  MainText(
                    "UNIVERSITY",
                    fontWeight: FontWeight.bold,
                    fontSize: height! * 0.15 / 4,
                  ),
                ],
              ),
            ),

            Container(
                width: width! * 0.35,
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
                          SizedBox(
                            width: width! * 0.35 * 0.2,
                          ),
                          MainText('login'.tr,
                              fontWeight: FontWeight.bold,
                              fontSize: height! * 0.15 / 4,
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
                        height: height! * 0.6 * 0.1,
                      ),
                      CustomTextFormField(
                          controller: controller.id,
                          validator: (id) => controller.validateID(id),
                          labelText: 'studentid'.tr,
                          icon: Icons.account_circle_outlined,
                          ),
                      SizedBox(
                        height: height! * 0.6 * 0.05,
                      ),
                      CustomTextFormField(
                          controller: controller.password,
                          validator: (pwd) => controller.validatePassword(pwd),
                          labelText: 'password'.tr,
                          icon: Icons.key_sharp,
                          isPassword: true,
                          onFieldSubmitted: (e) {
                            controller.onLogin();
                          }),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: ()=>controller.forgotPassword,
                          child: SecText("forgotPassword?".tr,textColor: AppColors.linkTextColor,),
                        ),
                      ),
                      SizedBox(
                        height: height! * 0.6 * 0.1,
                      ),
                      Obx(() => (controller.logging.value)
                          ? BasicButton(
                              onPress: controller.onLogin,
                              text: 'logging',
                              icon: CircularProgressIndicator(
                                color: AppColors.backColor,
                              ),
                              size: Size(width! * 0.8, 40),
                            )
                          : BasicButton(
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
                              size: Size(width! * 0.8, 40),
                            ))
                    ],
                  ),
                )),
          ],
        )
      ],
    );
  }
}

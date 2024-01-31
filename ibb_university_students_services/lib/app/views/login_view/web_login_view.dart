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

  @override
  Widget build(BuildContext context) {
    double containerScale = 0.50;
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          child:
              Image.asset("assets/images/loginbackimage.jpg", fit: BoxFit.fill),
        ),
        Container(
          color: const Color.fromRGBO(0, 191, 255, 0.25),
        ),
        Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height! * 0.05,
                ),
                Image.asset("assets/images/ibb_university_logo.png",
                    fit: BoxFit.fitHeight),
                MainText("IBB", fontWeight: FontWeight.bold, fontSize: 28),
                MainText("UNIVERSITY",
                    fontWeight: FontWeight.bold, fontSize: 28)
              ],
            ),
            Container(
              height: (height! * containerScale),
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
                    MainText('login'.tr,
                        fontWeight: FontWeight.bold,
                        fontSize: height! * 0.15 / 4,
                        textColor: Colors.black),
                    SizedBox(
                      height: height! * 0.6 * 0.1,
                    ),
                    CustomTextFormField(
                      controller: controller.ID,
                      validator: (id)=>controller.validateID(id),
                      labelText: 'studentid'.tr,
                      icon: Icons.account_circle_outlined,
                    ),
                    SizedBox(
                      height: height! * 0.6 * 0.05,
                    ),
                    CustomTextFormField(
                      controller: controller.password,
                      validator: (pwd)=>controller.validatePassword(pwd),
                      labelText: 'password'.tr,
                      icon: Icons.key_sharp,
                      isPassword: true,
                    ),
                    SizedBox(
                      height: height! * 0.6 * 0.1,
                    ),
                    Obx(() => (controller.logging.value)
                        ? BasicButton(
                      onPress: (){},
                      text: 'logging',
                      icon: const CircularProgressIndicator(),
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
              )
            ),
          ],
        )
      ],
    );
  }

  void loginButton() {
    if (Get.locale.toString() == "en_US") {
      Get.updateLocale(const Locale('ar'));
    } else {
      Get.updateLocale(const Locale('en_US'));
    }
  }
}

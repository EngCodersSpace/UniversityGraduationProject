// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/globals.dart';

import '../../controllers/login_controller.dart';

class PhoneLoginView extends StatelessWidget {
  PhoneLoginView({
    super.key,
    this.height,
    this.width,
  });

  double? height;
  double? width;
  double? fontScale;

  LoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    fontScale = width! / 767;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            SizedBox(
              height: (height! * 0.5),
              width: width,
              child: Image.asset("assets/images/loginbackimage.jpg",
                  fit: BoxFit.fill),
            ),
            SizedBox(
              height: (height! * 0.5),
              width: width,
            ),
          ],
        ),
        Container(
          color: const Color.fromRGBO(0, 191, 255, 0.25),
        ),
        Column(
          children: [
            SizedBox(
              height: height! * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: height! * 0.25,
                    child: Image.asset("assets/images/ibb_university_logo.png",
                        fit: BoxFit.fill),
                  ),
                  MainText("IBB",
                      fontWeight: FontWeight.bold,
                      fontSize: height! * 0.15 / 4),
                  MainText(
                    "UNIVERSITY",
                    fontWeight: FontWeight.bold,
                    fontSize: height! * 0.15 / 4,
                  ),
                ],
              ),
            ),
            Container(
                width: width,
                height: height! * 0.6,
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
                              text: 'logging'.tr,
                              icon:  SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: AppColors.backColor,
                                ),
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
                ))
          ],
        )
      ],
    );
  }


}

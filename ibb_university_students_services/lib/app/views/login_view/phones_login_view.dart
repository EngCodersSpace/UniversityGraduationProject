// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/components/text_field.dart';
import 'package:ibb_university_students_services/app/globals.dart';

class PhoneLoginView extends StatelessWidget {
   PhoneLoginView({
    super.key,
    this.height,
    this.width,
  });
  double? height;
  double? width;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding:  EdgeInsets.all(width!*0.05),
      color: AppColors.mainTextColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: BasicButton(onPress: () {}, text: "phoneView")),
          MainText('title'.tr, textColor: Colors.red),
          SecText("ok"),
          CustomTextFormField(icon: Icons.account_box,labelText: "UserName"),
          CustomTextFormField(icon: Icons.key_sharp,labelText: "Password",isPassword: true),
        ],
      ),
    );
  }
}

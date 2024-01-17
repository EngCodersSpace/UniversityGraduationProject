import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/globals.dart';

class PhoneLoginView extends StatelessWidget {
  const PhoneLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mainTextColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: BasicButton(onPress: () {}, text: "phoneView")),
            MainText('title'.tr,textColor: Colors.red),
            SecText("ok"),
          ],
        ),
    );
  }
}

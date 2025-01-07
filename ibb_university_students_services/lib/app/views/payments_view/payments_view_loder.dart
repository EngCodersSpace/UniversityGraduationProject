// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibb_university_students_services/app/views/payments_view/payments_phone_view.dart';
import 'package:ibb_university_students_services/app/views/payments_view/payments_web_view.dart';

import '../../utils/screen_utils.dart';

class PaymentsViewLoader extends StatelessWidget {
  const PaymentsViewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (ScreenUtils.isPhoneScreen()) {
            return   PaymentsPhoneView();
          } else {
            return   PaymentsWebView();
          }
        },
      ),
    );
  }
}

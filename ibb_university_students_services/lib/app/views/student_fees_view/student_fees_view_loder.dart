// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/screen_utils.dart';
import 'student_fees_phone_view.dart';
import 'student_fees_web_view.dart';

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
            return   StudentFeesPhoneView();
          } else {
            return   StudentFeesWebView();
          }
        },
      ),
    );
  }
}

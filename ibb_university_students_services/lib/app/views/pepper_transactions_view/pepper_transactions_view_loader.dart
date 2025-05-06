// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/screen_utils.dart';
import 'pepper_transactions_phone_view.dart';
import 'pepper_transactions_web_view.dart';

class PepperTransactionsViewLoader extends StatelessWidget {
  const PepperTransactionsViewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (ScreenUtils.isPhoneScreen()) {
            return   PepperTransactionsPhoneView();
          } else {
            return   PepperTransactionsWebView();
          }
        },
      ),
    );
  }
}

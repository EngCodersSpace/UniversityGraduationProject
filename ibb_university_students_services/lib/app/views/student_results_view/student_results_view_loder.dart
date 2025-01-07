// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/screen_utils.dart';
import 'student_results_phones_view.dart';


class StudentResultViewLoader extends StatelessWidget {
  const StudentResultViewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (ScreenUtils.isPhoneScreen()) {
            return   PhoneStudentResultView();
          } else {
            return   Placeholder();
          }
        },
      ),
    );
  }
}

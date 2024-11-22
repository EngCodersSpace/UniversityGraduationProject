// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_phone_view.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_web_view.dart';

class AcademicCardViewLoader extends StatelessWidget {
  const AcademicCardViewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 768 && constraints.maxHeight <= 1025) {
            return   AcademicCardPhoneView();
          } else {
            return   AcademicCardWebView();
          }
        },
      ),
    );
  }
}

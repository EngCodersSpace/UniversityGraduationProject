// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibb_university_students_services/app/views/study_plane/study_plane_web_view.dart';
import '../../utils/screen_utils.dart';
import 'study_plane_phones_view.dart';

class StudyPlaneViewLoader extends StatelessWidget {
  const StudyPlaneViewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (ScreenUtils.isPhoneScreen()) {
            return PhoneStudyPlaneView();
          } else {
            return WebStudyPlaneView();
          }
        },
      ),
    );
  }
}

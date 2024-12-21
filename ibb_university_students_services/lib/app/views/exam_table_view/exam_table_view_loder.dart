// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'exam_table_phones_view.dart';
import 'exam_table_web_view.dart';

class ExamTableViewLoader extends StatelessWidget {
  const ExamTableViewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 768 && constraints.maxHeight <= 1025) {
            return PhoneExamTableView();
          } else {
            return ExamTableWebView();
          }
        },
      ),
    );
  }
}

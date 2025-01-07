import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibb_university_students_services/app/utils/screen_utils.dart';
import 'package:ibb_university_students_services/app/views/main_view/phones_main_view.dart';
import 'package:ibb_university_students_services/app/views/main_view/web_main_view.dart';

class MainViewLoader extends StatelessWidget {
  const MainViewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (ScreenUtils.isPhoneScreen()) {
            return  PhoneMainView();
          } else {
            return   WebMainView();
          }
        },
      ),
    );
  }
}


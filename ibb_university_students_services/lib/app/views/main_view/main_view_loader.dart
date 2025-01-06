import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/views/main_view/phones_main_view.dart';
import 'package:ibb_university_students_services/app/views/main_view/web_main_view.dart';

class MainViewLoader extends StatelessWidget {
  const MainViewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (Get.width <= 768 && Get.height <= 1025) {
            return PhoneMainView();
          } else {
            return WebMainView();
          }
        },
      ),
    );
  }
}

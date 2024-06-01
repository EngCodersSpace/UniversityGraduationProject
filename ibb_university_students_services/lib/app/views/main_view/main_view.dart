import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibb_university_students_services/app/views/main_view/phones_main_view.dart';
import 'package:ibb_university_students_services/app/views/main_view/web_main_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 767 && constraints.maxHeight <= 1024) {
            return  PhoneMainView(height:constraints.maxHeight,width: constraints.maxWidth,);
          } else {
            return  WebMainView(height: constraints.maxHeight,width: constraints.maxWidth,);
          }
        },
    );
  }
}


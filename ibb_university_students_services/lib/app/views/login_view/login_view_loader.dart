import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibb_university_students_services/app/views/login_view/phones_login_view.dart';
import 'package:ibb_university_students_services/app/views/login_view/web_login_view.dart';

class LoginViewLoader extends StatelessWidget {
  const LoginViewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 768 && constraints.maxHeight <= 1025) {
            return PhoneLoginView();
          } else {
            return WebLoginView();
          }
        },
      ),
    );
  }
}

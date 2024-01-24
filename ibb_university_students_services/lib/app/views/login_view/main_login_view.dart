import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibb_university_students_services/app/views/login_view/phones_login_view.dart';
import 'package:ibb_university_students_services/app/views/login_view/web_login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 767 && constraints.maxHeight <= 1024) {
            return  PhoneLoginView(height: constraints.maxHeight,width: constraints.maxWidth,);
          } else {
            return  WebLoginView(height: constraints.maxHeight,width: constraints.maxWidth,);
          }
        },
      ),
    );
  }
}

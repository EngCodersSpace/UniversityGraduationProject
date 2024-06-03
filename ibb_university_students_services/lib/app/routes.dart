import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/bindings/login_binding.dart';
import 'package:ibb_university_students_services/app/views/login_view/forgot_password_view.dart';
import 'package:ibb_university_students_services/app/views/login_view/main_login_view.dart';
import 'package:ibb_university_students_services/app/views/main_view/main_view.dart';

import 'bindings/main_binding.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginPage(),
      binding: LoginViewBinding(),
    ),
    GetPage(
      name: '/main',
      page: () => const MainPage(),
      binding: MainViewBinding(),
    ),
    GetPage(
      name: '/forgotPassword',
      page: () => const ForgotPasswordView(),
    ),
    // Add more routes here
  ];
}

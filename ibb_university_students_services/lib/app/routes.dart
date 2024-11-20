import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/bindings/library_binding.dart';
import 'package:ibb_university_students_services/app/bindings/login_binding.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_view_loder.dart';
import 'package:ibb_university_students_services/app/views/login_view/forgot_password_view.dart';
import 'package:ibb_university_students_services/app/views/login_view/login_view_loader.dart';
import 'package:ibb_university_students_services/app/views/main_view/main_view_loader.dart';

import 'bindings/main_binding.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginViewLoader(),
      binding: LoginViewBinding(),
    ),
    GetPage(
      name: '/main',
      page: () => const MainViewLoader(),
      binding: MainViewBinding(),
    ),
    GetPage(
      name: '/forgotPassword',
      page: () => const ForgotPasswordView(),
    ),

    GetPage(
      name: '/library',
      page: () => const LibraryViewLoader(),
      binding: LibraryBinding(),
    ),
    // Add more routes here
  ];
}

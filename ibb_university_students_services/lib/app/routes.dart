import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/bindings/login_binding.dart';
import 'package:ibb_university_students_services/app/views/login_view/main_login_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    // Add more routes here
  ];
}

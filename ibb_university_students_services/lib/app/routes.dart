import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/bindings/exam_table_binding.dart';
import 'package:ibb_university_students_services/app/bindings/library_binding.dart';
import 'package:ibb_university_students_services/app/bindings/login_binding.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_loder.dart';
import 'package:ibb_university_students_services/app/views/exam_table_view/exam_table_view_loder.dart';
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

    GetPage(
      name: '/academic_card',
      page: () => const AcademicCardViewLoader(),
      // binding: LibraryBinding(),
    ),
    GetPage(
      name: '/exam_table',
      page: () => const ExamTableViewLoader(),
      binding: ExamTableBinding(),
    ),
    GetPage(
      name: '/student_result',
      page: () => const ExamTableViewLoader(),
      binding: ExamTableBinding(),
    ),

    // Add more routes here
  ];
}

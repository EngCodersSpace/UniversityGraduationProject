import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/bindings/exam_table_binding.dart';
import 'package:ibb_university_students_services/app/bindings/init_app_binding.dart';
import 'package:ibb_university_students_services/app/bindings/library_binding.dart';
import 'package:ibb_university_students_services/app/bindings/login_binding.dart';
import 'package:ibb_university_students_services/app/bindings/pepper_transactions_binding.dart';
import 'package:ibb_university_students_services/app/bindings/student_result_binding.dart';
import 'package:ibb_university_students_services/app/bindings/study_plane_binding.dart';
import 'package:ibb_university_students_services/app/views/acadime_card/academic_card_loder.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/doctor_table_view/doctor_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/main_view/dashboard_main_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/role_table_view/role_users_table_view.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/student_table_view/student_table_view.dart';
import 'package:ibb_university_students_services/app/views/exam_table_view/exam_table_view_loder.dart';
import 'package:ibb_university_students_services/app/views/library_view/library_view_loder.dart';
import 'package:ibb_university_students_services/app/views/login_view/forgot_password_view.dart';
import 'package:ibb_university_students_services/app/views/login_view/login_view_loader.dart';
import 'package:ibb_university_students_services/app/views/main_view/main_view_loader.dart';
import 'package:ibb_university_students_services/app/views/news_view/news_list_view.dart';
import 'package:ibb_university_students_services/app/views/news_view/phones_news_view.dart';
import 'package:ibb_university_students_services/app/views/pepper_transactions_view/pepper_transactions_view_loader.dart';
import 'package:ibb_university_students_services/app/views/splash_screen/splash_screen.dart';
import 'package:ibb_university_students_services/app/views/student_fees_view/student_fees_view_loder.dart';
import 'package:ibb_university_students_services/app/views/student_results_view/student_results_view_loder.dart';
import 'package:ibb_university_students_services/app/views/study_plane/study_plane_view_loder.dart';
import 'bindings/academic_card_binding.dart';
import 'bindings/main_binding.dart';
import 'bindings/student_fees_binding.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/splash_screen',
      page: () =>  SplashScreen(),
      binding: InitAppBinding(),
    ),

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
      binding: AcademicCardBinding(),
    ),
    GetPage(
      name: '/exam_table',
      page: () => const ExamTableViewLoader(),
      binding: ExamTableBinding(),
    ),
    GetPage(
      name: '/student_result',
      page: () => const StudentResultViewLoader(),
      binding: StudentResultBinding(),
    ),
    GetPage(
      name: '/news',
      page: () => const PhonesNewsView(),
      // binding: NewsViewBinding(),
    ),
    GetPage(
      name: '/news_list',
      page: () => const PhonesNewsListView(),
      // binding: NewsViewBinding(),
    ),
    GetPage(
      name: '/student_payments',
      page: () => const PaymentsViewLoader(),
      binding: StudentFeesBinding(),
    ),
    GetPage(
      name: "/dashboard_main_view",
      page: () => DashboardMainView(),
      binding: MainViewBinding(),
    ),
    GetPage(
      name: "/dashboard_role_user_view",
      page: () => RoleUsersTableView(),
      binding: MainViewBinding(),
    ),
    GetPage(
      name: "/dashboard_doctor_view",
      page: () => DoctorTableView(),
      binding: MainViewBinding(),
    ),
    GetPage(
      name: "/dashboard_student_view",
      page: () => StudentTableView(),
      binding: MainViewBinding(),
    ),
    GetPage(
      name: "/study_plane",
      page: () => StudyPlaneViewLoader(),
      binding: StudyPlaneBinding(),
    ),
    GetPage(
      name: "/pepper_transactions",
      page: () => PepperTransactionsViewLoader(),
      binding: PepperTransactionsBinding(),
    ),

    // Add more routes here
  ];
}

class RouteGuard extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    // Example: Redirect if user navigates directly
    if (previousRoute == null && route.settings.name != '/') {
      Future.delayed(Duration.zero, () {
        Get.offAllNamed('/splash_screen'); // Redirect to home
      });
    }
  }
}

import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_doctor_table_controller.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_main_controller.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_student_table_controller.dart';
import '../controllers/main_controller.dart';
import '../controllers/news_controller.dart';
import '../controllers/tabs_controller/assignments_tab_controller.dart';
import '../controllers/tabs_controller/home_tab_controller.dart';
import '../controllers/tabs_controller/notification_tab_controller.dart';
import '../controllers/tabs_controller/profile_tab_controller.dart';
import '../controllers/tabs_controller/lecture_table_tab_view_controller.dart';

class MainViewBinding implements Bindings {
  @override
  void dependencies(){
    Get.put<MainController>(MainController());
    Get.lazyPut<HomeTabController>(() => HomeTabController());
    Get.lazyPut<AssignmentsTabController>(() => AssignmentsTabController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<LectureController>(() => LectureController());
    // Get.lazyPut<LibraryController>(() => LibraryController());
    // Get.lazyPut<LibraryController>(() => LibraryController());
    // Get.lazyPut<StudentResultController>(() => StudentResultController());
    // Get.lazyPut<AcademicCardController>(() => AcademicCardController());
    Get.lazyPut<NotificationTabController>(() => NotificationTabController());
    Get.lazyPut<DashboardMainController>(() => DashboardMainController());
    // Get.lazyPut<DashboardRoleUsersTableController>(
    //     () => DashboardRoleUsersTableController());
    Get.lazyPut<DashboardDoctorTableController>(
        () => DashboardDoctorTableController());
    Get.lazyPut<DashboardStudentTableController>(
        () => DashboardStudentTableController());
    Get.put<NewsController>(NewsController(),permanent: true);
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/dashboard_doctor_table_controller.dart';
import 'package:ibb_university_students_services/app/utils/internet_connection_cheker.dart';

import 'dashboard_exam_table_controller.dart';
import 'dashboard_grad_table_controller.dart';
import 'dashboard_library_table_controller.dart';
import 'dashboard_notification_table_controller.dart';
import 'dashboard_payment_table_controller.dart';
import 'dashboard_phone_number_table_controller.dart';
import 'dashboard_student_table_controller.dart';
import 'dashboard_study_plan_table_controller.dart';
import 'dashboard_subjects_table_controller.dart';
import 'dashbord_lecture_table_controller.dart';

class DashboardMainController extends GetxController {
  RxInt selectedindex = 0.obs;
  RxBool connected = false.obs;

  @override
  void onInit() async {
    connected.value = await checkInternetConnection();
    Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {
        connected.value = false;
      } else {
        connected.value = true;
      }
    });
    changetableindex(selectedindex.value);
    super.onInit();
  }

  void changetableindex(int index) {
    GetxController? controller;
    switch (index) {
      case 0:
        // ignore: unnecessary_null_comparison
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<DashboardDoctorTableController>(
          DashboardDoctorTableController(),
        );
        break;
      case 1:
        // ignore: unnecessary_null_comparison
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<DashboardStudentTableController>(
          DashboardStudentTableController(),
        );
        break;
      case 2:
        // ignore: unnecessary_null_comparison
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<DashboardSubjectsTableController>(
          DashboardSubjectsTableController(),
        );
        break;
      case 3:
        // ignore: unnecessary_null_comparison
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<DashboardStudyPlanTableController>(
          DashboardStudyPlanTableController(),
        );
        break;
      case 4:
        // ignore: unnecessary_null_comparison
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<DashbordLectureTableController>(
          DashbordLectureTableController(),
        );
        break;
      case 5:
        // ignore: unnecessary_null_comparison
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<DashboardExamTableController>(
          DashboardExamTableController(),
        );
        break;
      case 6:
        // ignore: unnecessary_null_comparison
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<DashboardGradTableController>(
          DashboardGradTableController(),
        );
        break;
      case 7:
        // ignore: unnecessary_null_comparison
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<DashboardLibraryTableController>(
          DashboardLibraryTableController(),
        );
        break;
      case 8:
        // ignore: unnecessary_null_comparison
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<DashboardNotificationTableController>(
          DashboardNotificationTableController(),
        );
        break;
      case 9:
        // ignore: unnecessary_null_comparison
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<DashboardPhoneNumberTableController>(
          DashboardPhoneNumberTableController(),
        );
        break;
      case 10:
        // ignore: unnecessary_null_comparison
        if (controller != null) {
          controller.dispose();
        }
        controller = Get.put<DashboardPaymentTableController>(
          DashboardPaymentTableController(),
        );
        break;
    }
    selectedindex.value = index;
  }

  @override
  // ignore: unnecessary_overrides
  void onClose() {
    super.onClose();
  }
}

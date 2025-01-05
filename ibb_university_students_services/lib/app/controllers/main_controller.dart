import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_float_action_button_location.dart';

import '../views/acadime_card/academic_card_web_view.dart';
import '../views/exam_table_view/exam_table_web_view.dart';
import '../views/library_view/library_web_view.dart';
import '../views/student_results_view/student_results_web_view.dart';

class MainController extends GetxController {
  RxInt selectedIndex = 2.obs;
  late CustomFloatActionButtonLocation currentPos;
  RxBool loading = true.obs;
  @override
  void onInit() async {
    changeTabIndex(selectedIndex.value);
    super.onInit();
    loading.value = false;
  }

  // Method to change the selected index
  void changeTabIndex(int index) {
    if (index == 0) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.1) - 16, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.9) - 28, y: Get.height - (Get.height * 0.1));
    } else if (index == 1) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.32) - 23, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.71) - 28, y: Get.height - (Get.height * 0.1));
    } else if (index == 2) {
      currentPos = CustomFloatActionButtonLocation(
          x: (Get.width * 0.45), y: Get.height - (Get.height * 0.1));
    } else if (index == 3) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.71) - 28, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.32) - 23, y: Get.height - (Get.height * 0.1));
    } else if (index == 4) {
      (Get.locale?.languageCode == 'en')
          ? currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.9) - 28, y: Get.height - (Get.height * 0.1))
          : currentPos = CustomFloatActionButtonLocation(
              x: (Get.width * 0.1) - 16, y: Get.height - (Get.height * 0.1));
    }
    // index
    selectedIndex.value = index;
  }

  void putControllers(int index) {
    switch (index) {
      case 5:
        Get.put(
          const LibraryWebView(),
        );
        // selectedIndex.value = index;
        break;
      case 6:
        Get.put(
          ExamTableWebView(),
        );
        break;
      case 7:
        Get.put(
          const StudentResultsWebView(),
        );
        break;
      case 8:
        Get.put(
          const AcademicCardWebView(),
        );
        break;
    }
    selectedIndex.value = index;
  }

  @override
  void onClose() {}
}

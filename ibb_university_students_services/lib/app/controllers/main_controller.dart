import 'package:get/get.dart';

class MainController extends GetxController {

  RxInt selectedIndex = 0.obs;
  // Define a list of screens
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }


  // Method to change the selected index
  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  void onClose() {}
}

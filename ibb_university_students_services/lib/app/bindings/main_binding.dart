import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../controllers/tabs_controller/home_tab_controller.dart';
import '../controllers/tabs_controller/notification_tab_controller.dart';
import '../controllers/tabs_controller/profile_tab_controller.dart';
import '../controllers/tabs_controller/table_tab_view_controller.dart';

class MainViewBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<MainController>(MainController());
    Get.lazyPut<HomeTabController>(() =>HomeTabController());
    Get.lazyPut<ProfileController>(() =>ProfileController());
    Get.lazyPut<TableTabController>(() =>TableTabController());
    Get.lazyPut<NotificationTabController>(() =>NotificationTabController());
  }
}
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/notification_model/notification_model.dart';
import 'package:ibb_university_students_services/app/repositories/notifictaion_repository.dart';
import '../../models/helper_models/result.dart';
import '../../utils/snake_bar.dart';

class NotificationTabController extends GetxController {
  Map<String, Notification> notificationGroups = {};
  RxBool loadingState = true.obs;
  String today = "";
  @override
  void onInit() async{
    Result res = await NotificationRepository.fetchNotifications();
    if(res.statusCode == 200){
      notificationGroups = res.data;
    } else if (res.statusCode == 404) {
      notificationGroups = {};
       // = "this student not has fees";
      showSnakeBar(
          title: "Not Found Fees", message: "this student not has fees");
    } else {
      notificationGroups = {};
      // fieldMessage.value = "fetching fees failed please check connection";
      showSnakeBar(
          title: "Fetch Fees Failed",
          message: "fetching fees failed please check connection ");
    }
    DateTime now = DateTime.now();
    today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    loadingState.value = false;
    super.onInit();
  }



  @override
  void onReady() {
    NotificationRepository.setNotificationsReadState();
  }
}

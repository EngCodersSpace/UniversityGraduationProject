import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/notification_model.dart';
import 'package:ibb_university_students_services/app/models/result.dart';
import 'package:ibb_university_students_services/app/services/notifictaion_services.dart';

class NotificationTabController extends GetxController {
  Map<String, List<Notification>> notificationGroups = {};
  RxBool loadingState = true.obs;
  String today = "";
  @override
  void onInit() async{
    Result res = await NotificationServices.fetchNotifications();
    if(res.statusCode == 200){
      notificationGroups = _groupNotifications(res.data);
    }
    DateTime now = DateTime.now();
    today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    print(today);
    loadingState.value = false;
    super.onInit();
  }

  Map<String, List<Notification>> _groupNotifications(List<Notification> notifications){
    Map<String, List<Notification>> groupedNotifications = {};

    for (Notification notification in notifications) {
      String date = notification.date?.value??"-1";
      if (groupedNotifications.containsKey(date)) {
        groupedNotifications[date]!.add(notification);
      } else {
        groupedNotifications[date] = [notification];
      }
    }
    return groupedNotifications;
  }
  @override
  void onClose() {}
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/notification_model/notification_model.dart'
    as model;
import 'package:ibb_university_students_services/app/repositories/notifictaion_repository.dart';
import 'package:ibb_university_students_services/app/views/notification_tab_view/notification_tab_components/add_notifications_target_card.dart';
import '../../models/helper_models/result.dart';
import '../../utils/snake_bar.dart';

class NotificationTabController extends GetxController {
  Map<String, Map<int, model.Notification>> notificationGroups = {};
  RxBool loadingState = true.obs;
  String today = "";
  String yesterday = "";

  RxString mode = 'Group'.obs; // 'Single' or 'Group'
  TextEditingController receiverIdController = TextEditingController();
  FocusNode receiverIdFocus = FocusNode();
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocus = FocusNode();
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocus = FocusNode();

  RxString selectedTarget = 'student'.obs;
  RxList<String> selectedSections = <String>[].obs;
  RxList<String> selectedLevels = <String>[].obs;
  RxList<String> selectedRoles = <String>[].obs;

  final sections = [
    "section_1",
    "section_2",
    "section_3",
    "section_4",
    "section_5"
  ];
  final levels = ["level_1", "level_2", "level_3", "level_4", "level_5"];
  final roles = ["role_1", "role_2", "role_3", "role_4", "role_5"];
  final targets = ["student", "doctor", "student || doctor"];

  @override
  void onInit() async {

    DateTime now = DateTime.now();
    await fetchNotification();
    today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    yesterday = '${now.year}-${now.month.toString().padLeft(2, '0')}-${(now.day-1).toString().padLeft(2, '0')}';
    loadingState.value = false;
    super.onInit();
  }

  Future<void> fetchNotification({bool force=false})async{
    Result res = await NotificationRepository.fetchNotifications(hardFetch: force);
    if (res.statusCode == 200) {
      groupNotifications(res.data);
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
  }
  @override
  void refresh({bool force = true})  async{
    loadingState.value = true;
    await fetchNotification(force: force);
    super.refresh();
    loadingState.value = false;
  }

  String buildConditionString() {
    final parts = <String>[];
    parts.add("(${selectedTarget.value})");

    if (selectedSections.isNotEmpty) {
      parts.add("(${selectedSections.join(" || ")})");
    }

    if ((selectedTarget.value.contains('student')) &&
        selectedLevels.isNotEmpty) {
      parts.add("(${selectedLevels.join(" || ")})");
    }

    if (selectedRoles.isNotEmpty) {
      parts.add("(${selectedRoles.join(" || ")})");
    }
    return parts.join(" && ");
  }

  void addNotificationClick() {
    Get.dialog(AddNotificationsTargetCard());
  }

  void groupNotifications(Map<int, model.Notification> notifications) {
    for (model.Notification notification in notifications.values) {
      if (notification.createdAt == null) continue;

      if (!notificationGroups.containsKey(notification.createdAt?.split("T").first)) {
        notificationGroups[notification.createdAt!.split("T").first] = {};
      }
      notificationGroups[notification.createdAt!.split("T").first]?[notification.id] =
          notification;
    }
    notificationGroups = Map.fromEntries(
        notificationGroups.entries.toList()
          ..sort((a, b) => DateTime.parse(b.key).compareTo(DateTime.parse(a.key))) // newest first
    );
  }

  @override
  void onReady() {
    NotificationRepository.setNotificationsReadState();
  }
}

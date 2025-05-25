import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/notification_model/notification_model.dart'
    as model;
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/repositories/notifictaion_repository.dart';
import 'package:ibb_university_students_services/app/repositories/role_repository.dart';
import 'package:ibb_university_students_services/app/views/notification_tab_view/notification_tab_components/add_notifications_target_card.dart';
import '../../models/helper_models/result.dart';
import '../../models/level_model/level.dart';
import '../../models/role_model/role.dart';
import '../../repositories/level_repository.dart';
import '../../repositories/section_repository.dart';
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

  RxString selectedTarget = 'Students'.obs;
  RxList<String> selectedSections = <String>[].obs;
  RxList<String> selectedLevels = <String>[].obs;
  RxList<String> selectedRoles = <String>[].obs;

  Map<int, Section> sections = {};
  Map<int, Level> levels = {};
  Map<int, Role> roles = {};
  final Map<String, String> targets = {
    "Students": "'student' in topics",
    "Doctors": "'doctor' in topics",
    "Student And Doctors": "'student' in topics || 'doctor' in topics"
  };
  RxBool includeRole = false.obs;

  @override
  void onInit() async {
    DateTime now = DateTime.now();
    await initSections();
    await initLevels();
    await initRoles(force: true);
    await fetchNotification();
    today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    yesterday =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${(now.day - 1).toString().padLeft(2, '0')}';
    loadingState.value = false;
    super.onInit();
  }

  @override
  void refresh({bool force = true}) async {
    loadingState.value = true;
    await fetchNotification(force: force);
    super.refresh();
    loadingState.value = false;
  }

  Future<void> fetchNotification({bool force = false}) async {
    Result res =
        await NotificationRepository.fetchNotifications(hardFetch: force);
    if (res.statusCode == 200) {
      groupNotifications(res.data);
    } else if (res.statusCode == 404) {
      notificationGroups = {};
      // = "this student not has fees";
      showSnakeBar(
          title: "Not Found Notifications",
          message: "this student not has Notifications");
    } else {
      notificationGroups = {};
      // fieldMessage.value = "fetching Notifications failed please check connection";
      showSnakeBar(
          title: "Fetch Notifications Failed",
          message: "fetching Notifications failed please check connection ");
    }
  }

  Future<void> initSections({bool force = false}) async {
    sections = await SectionRepository.fetchSections(hardFetch: force)
        .then((e) => e.data ?? {});
  }

  Future<void> initLevels({bool force = false}) async {
    levels = await LevelRepository.fetchLevels(hardFetch: force)
        .then((e) => e.data ?? {});
  }

  Future<void> initRoles({bool force = false}) async {
    roles = await RoleRepository.fetchRoles(hardFetch: force)
        .then((e) => e.data ?? {});
  }

  void changeIncludeRole(bool? val) {
    if (val == null) return;
    includeRole.value = val;
  }

  void pushNotification() async {
    if (mode.value == "Group" && selectedSections.isEmpty) {
      showSnakeBar(
          title: "Validation Error",
          message: "programs required select at least one ");
      return;
    }
    if (mode.value == "Group" &&
        selectedTarget.value == "student" &&
        selectedLevels.isEmpty) {
      showSnakeBar(
          title: "Validation Error",
          message: "Levels required select at least one ");
      return;
    }
    if (mode.value == "Group" && selectedRoles.isEmpty) {
      showSnakeBar(
          title: "Validation Error",
          message: "Roles required select at least one ");
      return;
    }

    String? topics;
    int? receiverId;
    if (mode.value == "Single") {
      receiverId = int.tryParse(receiverIdController.text);
    } else if (mode.value == "Group") {
      topics = buildConditionString();
    }
    Result res = await NotificationRepository.pushNotification(
        title: titleController.text,
        message: messageController.text,
        topic: topics,
        receiverId: receiverId);
    Navigator.of(Get.overlayContext!).pop();
    if (res.statusCode == 200) {
      showSnakeBar(
          title: "successfully", message: "Notification push successfully");
    }
  }

  String buildConditionString() {
    final parts = <String>[];
    parts.add("(${targets[selectedTarget.value]})");

    if (selectedSections.isNotEmpty) {
      parts.add("('${selectedSections.join("'in topics || '")}' in topics)");
    }

    if ((selectedTarget.value.contains('Students')) &&
        selectedLevels.isNotEmpty) {
      parts.add("('${selectedLevels.join("' in topics || '")}' in topics)");
    }

    if (selectedRoles.isNotEmpty) {
      parts.add("('${selectedRoles.join(", in topics || '")}' in topics)");
    }
    return parts.join(" && ");
  }

  void addNotificationClick() {
    Get.dialog(AddNotificationsTargetCard());
  }

  void groupNotifications(Map<int, model.Notification> notifications) {
    for (model.Notification notification in notifications.values) {
      if (notification.createdAt == null) continue;

      if (!notificationGroups
          .containsKey(notification.createdAt?.split("T").first)) {
        notificationGroups[notification.createdAt!.split("T").first] = {};
      }
      notificationGroups[notification.createdAt!.split("T").first]
          ?[notification.id] = notification;
    }
    notificationGroups = Map.fromEntries(notificationGroups.entries.toList()
          ..sort((a, b) => DateTime.parse(b.key)
              .compareTo(DateTime.parse(a.key))) // newest first
        );
  }

  @override
  void onReady() {
    NotificationRepository.setNotificationsReadState();
  }
}

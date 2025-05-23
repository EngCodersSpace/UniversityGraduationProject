import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text_v2.dart';
import 'package:ibb_university_students_services/app/controllers/admin_panel_controllers/header_of_view_controller_interface.dart';
import 'package:ibb_university_students_services/app/models/helper_models/result.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/notification_model/notification_model.dart'
    as custom;
import 'package:ibb_university_students_services/app/models/role_model/role.dart';
import 'package:ibb_university_students_services/app/models/section_model/section.dart';
import 'package:ibb_university_students_services/app/repositories/level_repository.dart';
import 'package:ibb_university_students_services/app/repositories/notifictaion_repository.dart';
import 'package:ibb_university_students_services/app/repositories/role_repository.dart';
import 'package:ibb_university_students_services/app/repositories/section_repository.dart';
import 'package:ibb_university_students_services/app/styles/text_styles.dart';
import 'package:ibb_university_students_services/app/utils/snake_bar.dart';
import 'package:ibb_university_students_services/app/views/admin_panel/notification_table_view/notification_table_component/add_notification_table_card.dart';

class DashboardNotificationTableController extends GetxController
    implements HeaderOfViewControllerInterface {
  double get width => (Get.width - (Get.width * 0.2));
  double get height => Get.height;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxMap<int, custom.Notification> notifications = RxMap({});
  RxBool loadingState = true.obs;
  RxInt availableRows = 0.obs;
  RxString fieldMessage = "".obs;
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  ScrollController vertical = ScrollController();
  ScrollController horizontal = ScrollController();
  List<DataColumn> kTableColumn = [];
  int currentPage = 1;
  RxBool selectedAll = false.obs;
  RxSet selectedRow = RxSet({});
  Timer? _debounce;
  RxString selectedSort = "DESC".obs;
  RxString selectedOrder = "message_id".obs;
  RxString selectedType = "".obs;
  List<DropdownMenuItem<String>> orderBy = [
    DropdownMenuItem<String>(
        value: "message_id",
        child: SizedBox(
            width: (Get.width / 4) * 0.3,
            child: CustomText(
              "Message id",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "sender_id",
        child: SizedBox(
            width: (Get.width / 4) * 0.3,
            child: CustomText(
              "Sender",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "receiver_id",
        child: SizedBox(
            width: (Get.width / 4) * 0.3,
            child: CustomText(
              "Reciver",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "topic_name",
        child: SizedBox(
            width: (Get.width / 3) * 0.2,
            child: CustomText(
              "Topic name",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
  ];
  List<DropdownMenuItem<String>> sort = [
    DropdownMenuItem<String>(
        value: "DESC",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Descending",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "ASC",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Ascending",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
  ];
  List<DropdownMenuItem<String>> type = [
    DropdownMenuItem<String>(
        value: "",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "All",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "single",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Single",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
    DropdownMenuItem<String>(
        value: "topic",
        child: SizedBox(
            width: (Get.width / 8) * 0.6,
            child: CustomText(
              "Topic",
              style: AppTextStyles.mainStyle(
                textHeader: AppTextHeaders.h6Bold,
              ),
            ))),
  ];

  //popup add component
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController reciverController = TextEditingController();
  FocusNode titleFocus = FocusNode();
  FocusNode messageFocus = FocusNode();
  FocusNode reciverFocus = FocusNode();
  RxString mode = 'Group'.obs;
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
    searchController.addListener(() => onSearch());
    kTableColumn = <DataColumn>[
      DataColumn(
          label: Obx(() => Checkbox(
              value: selectedAll.value,
              onChanged: (isSelected) {
                if (isSelected == null) return;
                selectedAll.value = isSelected;
              }))),
      DataColumn(
        label: CustomText(
          "Message ID",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Sender id",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "reciver id",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Topic name",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Title",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      DataColumn(
        label: CustomText(
          "Message",
          style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
        ),
      ),
      // DataColumn(
      //   label: CustomText(
      //     "Type",
      //     style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold),
      //   ),
      // ),
    ];
    await initSections();
    await initLevels();
    await initRoles(force: true);
    await fetchNotificationData();
    loadingState.value = false;
    super.onInit();
  }

  @override
  void refresh() async {
    await fetchNotificationData();
    super.refresh();
  }

  Future<void> fetchNotificationData({bool showSnakeBars = true}) async {
    Result res = await NotificationRepository.fetchDashboardNotifications(
      type: (selectedType.value == "") ? "" : selectedType.value,
      order: selectedOrder.value,
      sort: selectedSort.value,
      limit: rowsPerPage.value,
      page: currentPage,
      search: searchController.text,
      hardFetch: false,
    );
    if (res.statusCode == 200) {
      notifications.value = res.data["notifications"] ?? {};
      availableRows.value = res.data["totalnotifications"] ?? 0;
    } else if (res.statusCode == 404) {
      notifications.value = {};
      availableRows.value = 0;
      update(["DataTable"]);
      fieldMessage.value = "There is no notifications here";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Not Found Notification",
            message: "this table doesn't has notifications ");
      }
    } else {
      notifications.value = {};
      fieldMessage.value =
          "fetching notifications failed please check connection";
      if (showSnakeBars) {
        showSnakeBar(
            title: "Fetch Notifications Failed",
            message: "fetching notifications failed please check connection ");
      }
    }
    update(["DataTable"]);
  }

  void onRowChange(int? value) async {
    if (value != null) {
      rowsPerPage.value = value;
      await fetchNotificationData();
      update(["DataTable"]);
    }
  }

  void onPageChange(int page) async {
    currentPage = (page ~/ rowsPerPage.value) + 1;
    await fetchNotificationData();
  }

  void changeSort(String? val) async {
    if (val == null) return;
    selectedSort.value = val;
    fetchNotificationData();
  }

  void changeOrder(String? val) async {
    if (val == null) return;
    selectedOrder.value = val;
    fetchNotificationData();
  }

  void changeType(String? val) async {
    if (val == null) return;
    selectedType.value = val;
    fetchNotificationData();
  }

  void addClick() async {
    Get.dialog(AddNotificationTableCard());
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
      receiverId = int.tryParse(reciverController.text);
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

  @override
  void export() {}

  @override
  void import() {}

  String prevTxt = "";

  @override
  void onSearch() {
    if (searchController.text == prevTxt) return;
    prevTxt = searchController.text;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 600), () async {
      await fetchNotificationData();
    });
  }

  @override
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void onClose() {}
}

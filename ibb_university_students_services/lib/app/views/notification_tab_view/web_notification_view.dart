import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/notification_tab_controller.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import 'package:ibb_university_students_services/app/views/notification_tab_view/notification_tab_components/notification_card.dart';

import '../../components/custom_text_v2.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

class WebNotificationView extends GetView<NotificationTabController> {
  const WebNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(() => (!controller.loadingState.value)
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            "Notifications".tr,
                            style: AppTextStyles.secStyle(
                              textHeader: AppTextHeaders.h1Bold,
                            ),
                          ),
                          if (UserRepository.checkPermission(
                              target: "notification", action: "write")) ...[
                            IconButton(
                                onPressed: controller.addNotificationClick,
                                icon: Icon(
                                  Icons.add_alert,
                                  color: AppColors.inverseIconColor,
                                ))
                          ]
                        ],
                      ),
                      SizedBox(height: 16),
                      if (UserRepository.checkPermission(
                          target: "notification", action: "write")) ...[
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (controller.sortDirection.value == 0) ...[
                                InkWell(
                                  onTap: () =>
                                      controller.changeSelectedSortDirection(0),
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 1.0,
                                        // Right side is intentionally left out
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: CustomText(
                                      "Received",
                                      style: AppTextStyles.customColorStyle(
                                        textHeader: AppTextHeaders.h2Bold,
                                        color:
                                            (controller.sortDirection.value ==
                                                    0)
                                                ? Colors.blueAccent
                                                : AppColors.inverseCardColor,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      controller.changeSelectedSortDirection(1),
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: controller.borders[0],
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: CustomText(
                                      "Sent",
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                InkWell(
                                  onTap: () =>
                                      controller.changeSelectedSortDirection(0),
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: controller.borders[1],
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: CustomText(
                                      "Received",
                                      style: AppTextStyles.secStyle(
                                        textHeader: AppTextHeaders.h2Bold,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      controller.changeSelectedSortDirection(1),
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 1.0,
                                        // Right side is intentionally left out
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: CustomText(
                                      "Sent",
                                      style: AppTextStyles.customColorStyle(
                                          textHeader: AppTextHeaders.h2Bold,
                                          color: (Colors.blueAccent)),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                      SizedBox(
                        height: Get.height * 0.04,
                      ),
                      GetBuilder<NotificationTabController>(
                        id: "notificationsList",
                        builder: (ctx) => Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async =>
                                controller.refresh(force: true),
                            child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (controller
                                        .notificationGroups.isEmpty) ...[
                                      SizedBox(
                                        height: Get.height * 0.2,
                                      ),
                                      Center(
                                          child: CustomText(
                                        "Empty".tr,
                                        style: AppTextStyles.secStyle(
                                            textHeader: AppTextHeaders.h2Bold),
                                      )),
                                      Center(
                                        child: IconButton(
                                            onPressed: () async =>
                                                controller.refresh(),
                                            icon: const Icon(
                                              Icons.refresh,
                                              size: 40,
                                            )),
                                      )
                                    ],
                                    for (String key in controller
                                        .notificationGroups.keys) ...[
                                      CustomText(
                                        (key.split("T").first ==
                                                controller.today)
                                            ? "Today".tr
                                            : (key.split("T").first ==
                                                    controller.yesterday)
                                                ? "Yesterday"
                                                : key.split("T").first,
                                        style: AppTextStyles.highlightStyle(
                                          textHeader: AppTextHeaders.h1Bold,
                                        ),
                                      ),
                                      for (int i = 0;
                                          i <
                                              (controller
                                                      .notificationGroups[key]
                                                      ?.length ??
                                                  0);
                                          i++)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            NotificationCard(
                                              title: controller
                                                      .notificationGroups[key]
                                                      ?.values
                                                      .toList()[i]
                                                      .title ??
                                                  "",
                                              message: controller
                                                      .notificationGroups[key]
                                                      ?.values
                                                      .toList()[i]
                                                      .message ??
                                                  "",
                                              author: controller
                                                      .notificationGroups[key]
                                                      ?.values
                                                      .toList()[i]
                                                      .sender
                                                      ?.name ??
                                                  "",
                                              time: controller
                                                      .notificationGroups[key]
                                                      ?.values
                                                      .toList()[i]
                                                      .createdAt
                                                      ?.split("T")
                                                      .last ??
                                                  "",
                                              readState: true,
                                            ),
                                          ],
                                        )
                                    ]
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()))));
  }
}

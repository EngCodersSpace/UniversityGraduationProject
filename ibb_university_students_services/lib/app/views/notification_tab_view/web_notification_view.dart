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
    return Container(
        color: AppColors.tabBackColor,
        height: Get.height,
        width: Get.width,
        child: Obx(() => (controller.loadingState.value)
            ? RefreshIndicator(
                onRefresh: () async => controller.refresh(
                  force: true,
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText(
                            "Notification".tr,
                            style: AppTextStyles.secStyle(
                              textHeader: AppTextHeaders.h3Bold,
                            ),
                          ),
                          if (UserRepository.checkPermission(
                              target: "notification", action: "write")) ...[
                            IconButton(
                              onPressed: controller.addNotificationClick,
                              icon: Icon(
                                Icons.add_alert_outlined,
                                color: AppColors.inverseIconColor,
                              ),
                            ),
                          ]
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.04,
                      ),
                      if (controller.notificationGroups.isEmpty) ...[
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
                              onPressed: () async => controller.refresh(),
                              icon: const Icon(
                                Icons.refresh,
                                size: 40,
                              )),
                        )
                      ],
                      for (String key
                          in controller.notificationGroups.keys) ...[
                        CustomText(
                          (key.split("T").first == controller.today)
                              ? "Today".tr
                              : (key.split("T").first == controller.yesterday)
                                  ? "Yesterday"
                                  : key.split("T").first,
                          style: AppTextStyles.highlightStyle(
                            textHeader: AppTextHeaders.h1Bold,
                          ),
                        ),
                        for (int i = 0;
                            i <
                                (controller.notificationGroups[key]?.length ??
                                    0);
                            i++)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NotificationCard(
                                title: controller
                                        .notificationGroups[key]?.values
                                        .toList()[i]
                                        .title ??
                                    "",
                                message: controller
                                        .notificationGroups[key]?.values
                                        .toList()[i]
                                        .message ??
                                    "",
                                author: controller
                                        .notificationGroups[key]?.values
                                        .toList()[i]
                                        .sender
                                        ?.name ??
                                    "",
                                time: controller.notificationGroups[key]?.values
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
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              )));
  }
}

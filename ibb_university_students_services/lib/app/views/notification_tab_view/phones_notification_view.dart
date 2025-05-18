// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import '../../components/custom_text_v2.dart';
import '../../styles/text_styles.dart';
import 'notification_tab_components/notification_card.dart';
import '../../controllers/tabs_controller/notification_tab_controller.dart';

class PhoneNotificationView extends GetView<NotificationTabController> {
  PhoneNotificationView({super.key});

  double height = Get.height;
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(() => (!controller.loadingState.value)
                ? RefreshIndicator(
                  onRefresh:()async=>controller.refresh(force: true),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            if (UserRepository.checkPermission(target: "notification", action: "write")) ...[
                              IconButton(
                                  onPressed: controller.addNotificationClick,
                                  icon: Icon(
                                    Icons.add_alert,
                                    color: AppColors.inverseIconColor,
                                  ))
                            ]
                          ],
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        if (controller
                            .notificationGroups
                            .isEmpty) ...[
                          SizedBox(
                            height: height * 0.2,
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
                            (key.split("T").first == controller.today) ? "Today".tr :(key.split("T").first == controller.yesterday)?"Yesterday": key.split("T").first,
                            style: AppTextStyles.highlightStyle(
                              textHeader: AppTextHeaders.h1Bold,
                            ),
                          ),
                          for (int i = 0;
                              i < (controller.notificationGroups[key]?.length??0);
                              i++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NotificationCard(
                                  message: controller
                                          .notificationGroups[key]?.values.toList()[i].message ??
                                      "",
                                  author: controller.notificationGroups[key]?.values.toList()[i]
                                          .sender?.name ??
                                      "",
                                  time: controller.notificationGroups[key]?.values.toList()[i]
                                          .createdAt?.split("T").last ??
                                      "",
                                  readState: true,
                                ),
                              ],
                            )
                        ]
                      ],
                    )),
                )
                : const Center(child: CircularProgressIndicator()))));
  }
}

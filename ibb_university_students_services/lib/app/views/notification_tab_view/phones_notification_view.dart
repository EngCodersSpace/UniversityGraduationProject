// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/globals.dart';
import '../../components/notification_card.dart';
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
                ? SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainText(
                            "Notifications",
                            textColor: AppColors.inverseMainTextColor,
                          ),
                          if(AppData.role == "doctor")...[
                            IconButton(onPressed: (){}, icon: Icon(Icons.add_alert,color: AppColors.inverseIconColor,))
                          ]

                        ],
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      for (String key
                          in controller.notificationGroups.keys) ...[
                        SecText(
                          (key == controller.today)?"Today":key,
                          textColor: AppColors.inverseSecTextColor,
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
                                  message: controller
                                          .notificationGroups[key]?[i]
                                          .message
                                          ?.value ??
                                      "",
                                  author: controller.notificationGroups[key]?[i]
                                          .author?.value ??
                                      "",
                                  time: controller.notificationGroups[key]?[i]
                                          .time?.value ??
                                      ""),
                            ],
                          )
                      ]
                    ],
                  ))
                : const Center(child: CircularProgressIndicator()))));
  }
}

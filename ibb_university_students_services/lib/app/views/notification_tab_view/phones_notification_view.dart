// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/services/user_services.dart';
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
                            "Notifications".tr,
                            textColor: AppColors.inverseMainTextColor,
                          ),
                          if(["teacher","doctor"].contains(UserServices.permission))...[
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
                          (key == controller.today)?"Today".tr:key,
                          textColor: AppColors.highlightTextColor,
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
                                      "",readState: controller.notificationGroups[key]?[i].readState?.value??true,),
                            ],
                          )
                      ]
                    ],
                  ))
                : const Center(child: CircularProgressIndicator()))));
  }
}

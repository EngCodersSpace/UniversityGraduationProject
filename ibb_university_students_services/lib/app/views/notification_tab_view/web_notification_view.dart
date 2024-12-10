import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/notification_tab_controller.dart';

import '../../styles/app_colors.dart';

class WebNotificationView extends GetView<NotificationTabController> {
  const WebNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.tabBackColor,
        height: Get.height,
        width: Get.width,
        child: Obx(() => (controller.loadingState.value)
            ? SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: Get.width * 0.2,
                    height: Get.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText("Notification".tr),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              )));
  }
}

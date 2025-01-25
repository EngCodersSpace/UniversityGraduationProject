import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/notification_tab_controller.dart';

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
                        CustomText("Notification".tr,style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold,),),
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

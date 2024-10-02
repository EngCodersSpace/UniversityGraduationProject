// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/components/notification_card.dart';
import 'package:ibb_university_students_services/app/globals.dart';
import '../../controllers/tabs_controller/notification_tab_controller.dart';

class PhoneNotificationView extends GetView<NotificationTabController> {
   PhoneNotificationView({super.key});
  double height = Get.height;
  double width = Get.width;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:  const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainText("Notifications",textColor: AppColors.inverseMainTextColor,),
            SizedBox(height: height*0.04,),
            SecText("Today", textColor: AppColors.inverseSecTextColor,),
            NotificationCard(message:"Notifictaion message ajcajsncjkncjnjancjnknjcsdjkncnsjancn",author:"Shehab", time:"10:00 PM"),
            SecText("Today", textColor: AppColors.inverseSecTextColor,),
          ],
        ),
      )
    );
  }
}

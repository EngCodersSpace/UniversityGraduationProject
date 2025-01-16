// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/main_controller.dart';
import 'package:ibb_university_students_services/app/views/assignments_tab_view/phone_assignments_tab_view.dart';
import 'package:ibb_university_students_services/app/views/lecture_table_tab_view/phones_lecture_table_tab_view.dart';
import 'package:ibb_university_students_services/app/views/notification_tab_view/phones_notification_view.dart';
import 'package:ibb_university_students_services/app/views/profile_tab_view/phones_profile_view.dart';
import '../../components/custom_text_v2.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';
import '../home_tab_view/phones_home_tab.dart';

class PhoneMainView extends GetView<MainController> {
  PhoneMainView({
    super.key,
  });

  double height = Get.height;
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    List iconFAB = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, color: AppColors.mainTextColor),
          CustomText(
            "Notification".tr,
            style: AppTextStyles.mainStyle(
                textHeader: (Get.locale?.languageCode == 'en')
                    ? AppTextHeaders.h6Bold
                    : AppTextHeaders.h5Bold),
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month,
            color: AppColors.mainTextColor,
            size: 18,
          ),
          CustomText(
            "Lecture\nTable".tr,
            style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5Bold),
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_outlined,
            color: AppColors.mainTextColor,
          ),
          CustomText(
            "Home".tr,
            style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h5Bold),
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, color: AppColors.mainTextColor),
          CustomText(
            "Assignments".tr,
            style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h6Bold),
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline_sharp, color: AppColors.mainTextColor),
          CustomText(
            "Profile".tr,
            style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h7Bold),
          )
        ],
      ),
    ];
    return Obx(
      () => (!controller.loading.value)
          ? Scaffold(
              body: Stack(
                children: [
                  screens[controller.selectedIndex.value],
                  if(!controller.isConnect.value)...[
                    Container(
                      height: 35,
                      width: double.maxFinite,
                      color: Colors.grey,
                      padding: const EdgeInsets.only(top: 8),
                      child: CustomText("Offline Mode",style: AppTextStyles.mainStyle(),),
                    )
                  ],
                ],
              ),
              floatingActionButton: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    color: AppColors.inverseIconColor,
                    borderRadius: BorderRadius.circular(35)),
                child: iconFAB[controller.selectedIndex.value],
              ),
              backgroundColor: AppColors.tabBackColor,
              floatingActionButtonLocation: controller.currentPos,
              bottomNavigationBar: BottomAppBar(
                surfaceTintColor: AppColors.backColor,
                color: AppColors.backColor,
                shadowColor: Colors.black,
                elevation: 32,
                height: height * 0.096,
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.004, horizontal: width * 0.01),
                notchMargin: 8,
                shape: const CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.changeTabIndex(0);
                      },
                      padding: const EdgeInsets.all(8),
                      icon: Column(
                        children: [
                          Icon(Icons.notifications_none,
                              color: (controller.selectedIndex.value == 0)
                                  ? Colors.transparent
                                  : null),
                          CustomText("Notification".tr,
                              style: AppTextStyles.customColorStyle(
                                  textHeader: AppTextHeaders.h5Bold,
                                  color: (controller.selectedIndex.value == 0)
                                      ? Colors.transparent
                                      : AppColors.secTextColor)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.changeTabIndex(1);
                      },
                      padding: (Get.locale?.languageCode == 'ar' &&
                              controller.selectedIndex.value == 0)
                          ? const EdgeInsets.only(top: 8, right: 32)
                          : const EdgeInsets.all(8),
                      icon: Column(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: (controller.selectedIndex.value == 1)
                                ? Colors.transparent
                                : null,
                          ),
                          CustomText("Lecture\nTable".tr,
                              style: AppTextStyles.customColorStyle(
                                  textHeader: AppTextHeaders.h5Bold,
                                  color: (controller.selectedIndex.value == 1)
                                      ? Colors.transparent
                                      : AppColors.secTextColor))
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.changeTabIndex(2);
                      },
                      padding: const EdgeInsets.all(8),
                      icon: Column(
                        children: [
                          Icon(
                            Icons.home_outlined,
                            color: (controller.selectedIndex.value == 2)
                                ? Colors.transparent
                                : null,
                          ),
                          CustomText("Home".tr,
                              style: AppTextStyles.customColorStyle(
                                  textHeader: AppTextHeaders.h5Bold,
                                  color: (controller.selectedIndex.value == 2)
                                      ? Colors.transparent
                                      : AppColors.secTextColor))
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.changeTabIndex(3);
                      },
                      padding: (Get.locale?.languageCode == 'en' &&
                              controller.selectedIndex.value == 4)
                          ? const EdgeInsets.only(top: 8, right: 32)
                          : const EdgeInsets.all(8),
                      icon: Column(
                        children: [
                          Icon(Icons.assignment_outlined,
                              color: (controller.selectedIndex.value == 3)
                                  ? Colors.transparent
                                  : null),
                          CustomText("Assignments".tr,
                              style: AppTextStyles.customColorStyle(
                                  textHeader: AppTextHeaders.h5Bold,
                                  color: (controller.selectedIndex.value == 3)
                                      ? Colors.transparent
                                      : AppColors.secTextColor))
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.changeTabIndex(4);
                      },
                      padding: const EdgeInsets.all(8),
                      icon: Column(
                        children: [
                          Icon(Icons.person_outline_sharp,
                              color: (controller.selectedIndex.value == 4)
                                  ? Colors.transparent
                                  : null),
                          CustomText(
                            "Profile".tr,
                            style: AppTextStyles.customColorStyle(
                                textHeader: AppTextHeaders.h5Bold,
                                color: (controller.selectedIndex.value == 4)
                                    ? Colors.transparent
                                    : AppColors.secTextColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  List screens = [
    PhoneNotificationView(),
    PhoneLectureTableTabView(),
    PhoneMainTab(),
    PhoneAssignmentsTabView(),
    PhoneProfileView(),
  ];
}

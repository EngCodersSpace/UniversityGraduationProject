// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/main_controller.dart';
import 'package:ibb_university_students_services/app/views/profile_tab_view/phones_profile_view.dart';
import 'package:ibb_university_students_services/app/views/table_tab_view/phones_table_tab_view.dart';

import '../../components/custom_text.dart';
import '../../globals.dart';
import '../home_tab_view/phones_home_tab.dart';

class PhoneMainView extends GetView<MainController> {
  PhoneMainView({
    super.key,
  });

  double height = Get.height;
  double width = Get.width;
  late FloatingActionButtonLocation floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    List iconFAB = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, color: AppColors.mainTextColor),
          SecText("Notification".tr,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              textColor: AppColors.mainTextColor)
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month,
            color: AppColors.mainTextColor,
          ),
          SecText(
            "Table".tr,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            textColor: AppColors.mainTextColor,
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
          SecText("Home".tr,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              textColor: AppColors.mainTextColor)
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.repartition, color: AppColors.mainTextColor),
          SecText("Reports".tr,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              textColor: AppColors.mainTextColor)
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline_sharp, color: AppColors.mainTextColor),
          SecText(
            "Profile".tr,
            fontSize: (Get.locale?.languageCode=='en')?10:8,
            fontWeight: FontWeight.bold,
            textColor: AppColors.mainTextColor,
          )
        ],
      ),
    ];
    return Obx(
      () => Scaffold(
        body: screens[controller.selectedIndex.value],
        floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.inverseIconColor,
            shape: const CircleBorder(),
            onPressed: () {},
            child: iconFAB[controller.selectedIndex.value],
        ),
        backgroundColor: AppColors.tabBackColor,
        floatingActionButtonLocation: controller.currentPos,
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: AppColors.backColor,
          color: AppColors.backColor,
          shadowColor: Colors.black,
          elevation: 32,
          height:(Get.locale?.languageCode == 'en')?height * 0.08:height * 0.09,
          padding: EdgeInsets.symmetric(
              vertical: height * 0.007, horizontal: width * 0.03),
          notchMargin: 8,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  controller.changeTabIndex(0);
                },
                icon: Column(
                  children: [
                    Icon(Icons.notifications_none,
                        color: (controller.selectedIndex.value == 0)
                            ? Colors.transparent
                            : null),
                    SecText("Notification".tr,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        textColor: (controller.selectedIndex.value == 0)
                            ? Colors.transparent
                            : null)
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.changeTabIndex(1);
                },
                icon: Column(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: (controller.selectedIndex.value == 1)
                          ? Colors.transparent
                          : null,
                    ),
                    SecText(
                      "Table".tr,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      textColor: (controller.selectedIndex.value == 1)
                          ? Colors.transparent
                          : null,
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.changeTabIndex(2);
                },
                icon: Column(
                  children: [
                    Icon(
                      Icons.home_outlined,
                      color: (controller.selectedIndex.value == 2)
                          ? Colors.transparent
                          : null,
                    ),
                    SecText("Home".tr,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        textColor: (controller.selectedIndex.value == 2)
                            ? Colors.transparent
                            : null)
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.changeTabIndex(3);
                },
                icon: Column(
                  children: [
                    Icon(Icons.repartition,
                        color: (controller.selectedIndex.value == 3)
                            ? Colors.transparent
                            : null),
                    SecText("Reports".tr,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        textColor: (controller.selectedIndex.value == 3)
                            ? Colors.transparent
                            : null)
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.changeTabIndex(4);
                },
                icon: Column(
                  children: [
                    Icon(Icons.person_outline_sharp,
                        color: (controller.selectedIndex.value == 4)
                            ? Colors.transparent
                            : null),
                    SecText(
                      "Profile".tr,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      textColor: (controller.selectedIndex.value == 4)
                          ? Colors.transparent
                          : null,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List screens = [
    Center(
      child: MainText(
        "MainPage 1",
        textColor: Colors.black,
      ),
    ),
    const PhoneTableTabView(),
    PhoneMainTab(),
    Center(
      child: MainText(
        "MainPage 3",
        textColor: Colors.black,
      ),
    ),
    PhoneProfileView(),
  ];
}

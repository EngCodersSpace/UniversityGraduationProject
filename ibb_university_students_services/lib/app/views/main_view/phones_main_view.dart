// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/main_controller.dart';

import '../../components/custom_text.dart';
import '../../globals.dart';
import '../home_tab_view/mobile_home_tab.dart';

class PhoneMainView extends GetView<MainController> {
  PhoneMainView({
    super.key,
  });

  double height = Get.height;
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: screens[controller.selectedIndex.value],
        floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.inverseIconColor,
            shape: const CircleBorder(),
            onPressed: () => controller.changeTabIndex(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_outlined,
                  color: AppColors.mainIconColor,
                  size: height * 0.03,
                ),
                SecText(
                  "Home",
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.mainTextColor,
                )
              ],
            )),
        backgroundColor: AppColors.tabBackColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: AppColors.backColor,
          color: AppColors.backColor,
          shadowColor: Colors.black,
          elevation: 32,
          height: height * 0.08,
          padding: EdgeInsets.symmetric(
              vertical: height * 0.007, horizontal: width * 0.03),
          notchMargin: 8,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => controller.changeTabIndex(1),
                icon: Column(
                  children: [
                    const Icon(Icons.notifications_none),
                    SecText(
                      "Notification",
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      textColor: (controller.selectedIndex.value == 1)
                          ? AppColors.inverseIconColor
                          : Color(int.parse("BF000000", radix: 16)),
                    )
                  ],
                ),
                color: (controller.selectedIndex.value == 1)
                    ? AppColors.inverseIconColor
                    : Color(int.parse("BF000000", radix: 16)),
              ),
              IconButton(
                onPressed: () => controller.changeTabIndex(2),
                icon: Column(
                  children: [
                    const Icon(Icons.calendar_month),
                    SecText(
                      "Table",
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      textColor: (controller.selectedIndex.value == 2)
                          ? AppColors.inverseIconColor
                          : Color(int.parse("BF000000", radix: 16)),
                    )
                  ],
                ),
                color: (controller.selectedIndex.value == 2)
                    ? AppColors.inverseIconColor
                    : Color(int.parse("BF000000", radix: 16)),
              ),
              const SizedBox(),
              IconButton(
                onPressed: () => controller.changeTabIndex(3),
                icon: Column(
                  children: [
                    const Icon(Icons.repartition),
                    SecText(
                      "Reports",
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      textColor: (controller.selectedIndex.value == 3)
                          ? AppColors.inverseIconColor
                          : Color(int.parse("BF000000", radix: 16)),
                    )
                  ],
                ),
                color: (controller.selectedIndex.value == 3)
                    ? AppColors.inverseIconColor
                    : Color(int.parse("BF000000", radix: 16)),
              ),
              IconButton(
                onPressed: () => controller.changeTabIndex(4),
                icon: Column(
                  children: [
                    const Icon(Icons.person_outline_sharp),
                    SecText(
                      "Profile",
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      textColor: (controller.selectedIndex.value == 4)
                          ? AppColors.inverseIconColor
                          : Color(int.parse("BF000000", radix: 16)),
                    )
                  ],
                ),
                color: (controller.selectedIndex.value == 4)
                    ? AppColors.inverseIconColor
                    : Color(int.parse("BF000000", radix: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List screens = [
    MobileMainTab(),
    Center(
      child: MainText(
        "MainPage 1",
        textColor: Colors.black,
      ),
    ),
    Center(
      child: MainText(
        "MainPage 2",
        textColor: Colors.black,
      ),
    ),
    Center(
      child: MainText(
        "MainPage 3",
        textColor: Colors.black,
      ),
    ),
    Center(
      child: MainText(
        "MainPage 4",
        textColor: Colors.black,
      ),
    ),
    //Center(child: MainText("MainPage 5",textColor: Colors.black,),),
  ];
}

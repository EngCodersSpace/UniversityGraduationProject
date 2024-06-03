// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/main_controller.dart';
import '../../components/custom_text.dart';
import '../../globals.dart';

class PhoneMainView extends GetView<MainController> {

  PhoneMainView({
    super.key,
    required this.height,
    required this.width,
  });
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    controller.setHeightWidth(height, width);
    return Obx(
      () => Scaffold(
        body: controller.screens?[controller.selectedIndex.value],
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.inverseIconColor,
          shape: const CircleBorder(),
          onPressed: () => controller.changeTabIndex(0),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center ,
            children: [
              Icon(
                Icons.home_outlined,
                color: AppColors.mainIconColor,
                size: 30,
              ),
              SecText(
                "Home",
                fontSize: 10,
                fontWeight: FontWeight.bold,
                textColor:AppColors.mainTextColor,
              )

            ],
          )
        ),
        backgroundColor: AppColors.tabBackColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: AppColors.backColor,
          color: AppColors.backColor,
          shadowColor: Colors.black,
          elevation: 32,
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
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
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/main_controller.dart';

import '../../components/custom_text.dart';
import '../../globals.dart';

class PhoneMainView extends StatelessWidget {
  PhoneMainView({
    super.key,
    this.height,
    this.width,
  });

  double? height;
  double? width;
  double? fontScale;

  MainController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.setHeightWidth(height!, width!);
    return Obx(
      () => Scaffold(
        body: controller.screens?[controller.selectedIndex.value],
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.iconColor,
          shape: const CircleBorder(),
          onPressed: () => controller.changeTabIndex(0),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center ,
            children: [
              Icon(
                Icons.home,
                color: AppColors.inverseIconColor,
                size: 30,
              ),
              SecText(
                "Home",
                fontSize: 10,
                fontWeight: FontWeight.bold,
                textColor:AppColors.inverseIconColor,
              )

            ],
          )
        ),
        backgroundColor: AppColors.tabBackColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: AppColors.backColor,
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          elevation: 0,
          notchMargin: 8,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => controller.changeTabIndex(1),
                icon: Column(
                  children: [
                    const Icon(Icons.notifications),
                    SecText(
                      "Notification",
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      textColor: (controller.selectedIndex.value == 1)
                          ? AppColors.iconColor
                          : Color(int.parse("BF000000", radix: 16)),
                    )
                  ],
                ),
                color: (controller.selectedIndex.value == 1)
                    ? AppColors.iconColor
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
                          ? AppColors.iconColor
                          : Color(int.parse("BF000000", radix: 16)),
                    )
                  ],
                ),
                color: (controller.selectedIndex.value == 2)
                    ? AppColors.iconColor
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
                          ? AppColors.iconColor
                          : Color(int.parse("BF000000", radix: 16)),
                    )
                  ],
                ),
                color: (controller.selectedIndex.value == 3)
                    ? AppColors.iconColor
                    : Color(int.parse("BF000000", radix: 16)),
              ),
              IconButton(
                onPressed: () => controller.changeTabIndex(4),
                icon: Column(
                  children: [
                    const Icon(Icons.person),
                    SecText(
                      "Profile",
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      textColor: (controller.selectedIndex.value == 4)
                          ? AppColors.iconColor
                          : Color(int.parse("BF000000", radix: 16)),
                    )
                  ],
                ),
                color: (controller.selectedIndex.value == 4)
                    ? AppColors.iconColor
                    : Color(int.parse("BF000000", radix: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

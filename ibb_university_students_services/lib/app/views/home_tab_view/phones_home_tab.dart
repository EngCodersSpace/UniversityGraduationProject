// ignore_for_file: must_be_immutable
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/components/news_card.dart';
import 'package:ibb_university_students_services/app/components/services_card.dart';

import '../../controllers/tabs_controller/home_tab_controller.dart';
import '../../globals.dart';

class PhoneMainTab extends GetView<HomeTabController> {
  PhoneMainTab({
    super.key,
  });

  double height = Get.height * (1 - 0.16);
  double width = Get.width;
  late double cardSize = (width-width*0.35) * 1 / 4;

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
          minimum: EdgeInsets.only(
            top: height * 0.055,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: width * 0.1,
                                  backgroundColor: AppColors.inverseIconColor,
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      (controller.user.profileImage) != null
                                          ? AppColors.tabBackColor
                                          : Colors.blue,
                                  maxRadius: width * 0.1 - 2,
                                  backgroundImage: (controller
                                              .user.profileImage?.value) !=
                                          null
                                      ? AssetImage(
                                          controller.user.profileImage!.value)
                                      : null,
                                  child: (controller.user.profileImage) != null
                                      ? null
                                      : MainText(
                                          controller.user.name?.value[0] ??
                                              "".toUpperCase()),
                                )
                              ],
                            ),
                            SizedBox(width: width * 0.05),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MainText(
                                  controller.user.name?.value ?? "",
                                  textColor: AppColors.inverseIconColor,
                                ),
                                SecText(
                                  "ID : ${controller.user.id}",
                                  textColor: AppColors.inverseSecTextColor,
                                )
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications),
                          color: AppColors.inverseIconColor,
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.018,
                    ),
                    SizedBox(
                      height: height * 0.14,
                      child: Card(
                        elevation: 16,
                        surfaceTintColor: AppColors.mainCardColor,
                        color: AppColors.mainCardColor,
                        child: Row(
                          children: [
                            SizedBox(
                              width: (width - 2) * 0.05,
                            ),
                            SizedBox(
                              width: (width - 2) * 0.3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SecText("Department".tr,
                                      textColor: AppColors.inverseSecTextColor),
                                  Row(
                                    children: [
                                      Icon(Icons.groups_sharp,
                                          color: AppColors.secTextColor),
                                      SizedBox(
                                        width: width * 0.025,
                                      ),
                                      Flexible(
                                        child: MainText(
                                            controller.user.department?.value ??
                                                "Unknown".tr,
                                            textColor: AppColors.secTextColor,
                                            fontSize: 14 * Get.textScaleFactor,
                                            height: 0),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: height * 0.06,
                              width: 1,
                              color: AppColors.inverseSecTextColor,
                            ),
                            SizedBox(
                              width: (width - 2) * 0.04,
                            ),
                            SizedBox(
                              width: (width - 2) * 0.25,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SecText("Level".tr,
                                      textColor: AppColors.inverseSecTextColor),
                                  Row(
                                    children: [
                                      Icon(Icons.school,
                                          color: AppColors.secTextColor),
                                      SizedBox(
                                        width: width * 0.025,
                                      ),
                                      MainText(
                                          controller.user.level?.value ??
                                              "Unknown".tr,
                                          textColor: AppColors.secTextColor),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: height * 0.06,
                              width: 1,
                              color: AppColors.inverseSecTextColor,
                            ),
                            SizedBox(
                              width: (width - 2) * 0.03,
                            ),
                            SizedBox(
                              width: (width - 2) * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SecText("Level".tr,
                                      textColor: AppColors.inverseSecTextColor),
                                  Row(
                                    children: [
                                      Icon(Icons.school,
                                          color: AppColors.secTextColor),
                                      SizedBox(
                                        width: width * 0.025,
                                      ),
                                      MainText(
                                          controller.user.level?.value ??
                                              "Unknown".tr,
                                          textColor: AppColors.secTextColor),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    SecText(
                      "News".tr,
                      textColor: AppColors.inverseSecTextColor,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
              NotificationListener<UserScrollNotification>(
                onNotification: controller.scrollEvent,
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  dragStartBehavior: DragStartBehavior.down,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.05,
                      ),
                      NewsCard(height: height * 0.25, width: width * 0.8),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      NewsCard(height: height * 0.25, width: width * 0.8),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      NewsCard(height: height * 0.25, width: width * 0.8),
                      SizedBox(
                        width: width * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                child: TabPageSelector(
                  controller: controller.tabController,
                  color: AppColors.tabBackColor,
                  selectedColor: AppColors.inverseIconColor,
                  indicatorSize: 10,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SecText(
                      "Services".tr,
                      textColor: AppColors.inverseSecTextColor,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            ServicesCard(
                              onTap: () {},
                              size: cardSize,
                              color: Colors.transparent,
                              image: const AssetImage(
                                  "assets/images/book.png"),
                            ),
                            SecText(
                              "Library",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ServicesCard(
                              onTap: () {},
                              color: Colors.transparent,
                              size: cardSize,
                              image: const AssetImage(
                                  "assets/images/calendar.png"),
                            ),
                            SecText(
                              "Lecture",
                              fontWeight: FontWeight.bold,
                            ),
                            SecText(
                              "Schedule",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ServicesCard(
                              onTap: () {
                              },
                              size: cardSize,
                              color: Colors.transparent,
                              image: const AssetImage(
                                  "assets/images/payment.png"),
                            ),
                            SecText(
                              "Payments",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ServicesCard(
                              onTap: () {},
                              size: cardSize,
                              color: Colors.transparent,
                              image: const AssetImage(
                                  "assets/images/book.png"),
                            ),
                            SecText(
                              "Library",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            ServicesCard(
                              onTap: () {},
                              size: cardSize,
                              color: Colors.transparent,
                              image: const AssetImage(
                                  "assets/images/a-.png"),
                            ),
                            SecText(
                              "Student",
                              fontWeight: FontWeight.bold,
                            ),
                            SecText(
                              "Degrees",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ServicesCard(
                              onTap: () {},
                              size: cardSize,
                              color: Colors.transparent,
                              image: const AssetImage(
                                  "assets/images/result.png"),
                            ),
                            SecText(
                              "Student",
                              fontWeight: FontWeight.bold,
                            ),
                            SecText(
                              "Degrees",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ServicesCard(
                              onTap: () {},
                              color: Colors.transparent,
                              size: cardSize,
                              image: const AssetImage(
                                  "assets/images/exam_11776326.png"),
                            ),
                            SecText(
                              "Exam",
                              fontWeight: FontWeight.bold,
                            ),
                            SecText(
                              "Schedule",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ServicesCard(
                              onTap: () {},
                              size: cardSize,
                              color: Colors.transparent,
                              image: const AssetImage(
                                  "assets/images/book.png"),
                            ),
                            SecText(
                              "Library",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
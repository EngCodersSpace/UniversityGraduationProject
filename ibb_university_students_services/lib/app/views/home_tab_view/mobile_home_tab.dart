// ignore_for_file: must_be_immutable


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/components/news_card.dart';
import 'package:ibb_university_students_services/app/components/services_card.dart';
import '../../controllers/tabs_controller/home_tab_controller.dart';
import '../../globals.dart';

class MobileMainTab extends GetView<MainTabController> {
  MobileMainTab({
    super.key,
  });

  double height = Get.height * (1 - 0.12);
  double width = Get.width;
  late double cardSize = height * 0.4 * 1 / 2;

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
          minimum: EdgeInsets.only(
            top: height * 0.07,
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
                      height: height * 0.015,
                    ),
                    SizedBox(
                      height: height * 0.12,
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
                                  SecText("Partition",
                                      textColor: AppColors.inverseSecTextColor),
                                  Row(
                                    children: [
                                      Icon(Icons.contact_mail_sharp,
                                          color: AppColors.inverseIconColor),
                                      SizedBox(
                                        width: width * 0.025,
                                      ),
                                      Flexible(
                                        child: MainText(
                                            controller.user.part?.value ??
                                                "Unknown",
                                            textColor:
                                                AppColors.inverseIconColor,
                                            fontSize: 14,
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
                              color: AppColors.inverseIconColor,
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
                                  SecText("Level",
                                      textColor: AppColors.inverseSecTextColor),
                                  Row(
                                    children: [
                                      Icon(Icons.school,
                                          color: AppColors.inverseIconColor),
                                      SizedBox(
                                        width: width * 0.025,
                                      ),
                                      MainText(
                                          controller.user.level?.value ??
                                              "Unknown",
                                          textColor:
                                              AppColors.inverseIconColor),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: height * 0.06,
                              width: 1,
                              color: AppColors.inverseIconColor,
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
                                  SecText("Level",
                                      textColor: AppColors.inverseSecTextColor),
                                  Row(
                                    children: [
                                      Icon(Icons.school,
                                          color: AppColors.inverseIconColor),
                                      SizedBox(
                                        width: width * 0.025,
                                      ),
                                      MainText(
                                          controller.user.level?.value ??
                                              "Unknown",
                                          textColor:
                                              AppColors.inverseIconColor),
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
                      "News",
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
                    NewsCard(height: height * 0.16, width: width * 0.8),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    NewsCard(height: height * 0.16, width: width * 0.8),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    NewsCard(height: height * 0.16, width: width * 0.8),
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
                      "Services",
                      textColor: AppColors.inverseSecTextColor,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ServicesCard(
                          onTap: (){
                          },
                          size: cardSize,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sell_rounded,
                                  color: AppColors.mainIconColor),
                              SecText(
                                "Service",
                                textColor: AppColors.mainTextColor,
                              )
                            ],
                          ),
                        ),
                        ServicesCard(
                          onTap: (){
                          },
                          size: cardSize,
                          color: AppColors.mainCardColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.ac_unit,
                                  color: AppColors.inverseIconColor),
                              SecText(
                                "Service",
                                textColor: AppColors.inverseIconColor,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ServicesCard(
                          onTap: (){

                          },
                          size: cardSize,
                          color: AppColors.mainCardColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.access_alarms,
                                  color: AppColors.inverseIconColor),
                              SecText(
                                "Service",
                                textColor: AppColors.inverseIconColor,
                              )
                            ],
                          ),
                        ),
                        ServicesCard(
                          onTap: (){},
                          size: cardSize,
                          color: AppColors.mainCardColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_chart,
                                  color: AppColors.inverseIconColor),
                              SecText(
                                "Service",
                                textColor: AppColors.inverseIconColor,
                              )
                            ],
                          ),
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

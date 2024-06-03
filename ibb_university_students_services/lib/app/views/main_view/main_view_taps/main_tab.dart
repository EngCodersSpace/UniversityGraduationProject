// ignore_for_file: must_be_immutable


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/components/services_card.dart';
import 'package:ibb_university_students_services/app/controllers/main_controller.dart';
import '../../../controllers/tabs_controller/main_tab_controller.dart';
import '../../../globals.dart';

class MainTab extends GetView<MainTabController> {
  MainTab({
    super.key,
  });

  late MainController parentController = Get.find<MainController>();

  double height = 1;
  double width = 10;
  late double cardSize;

  @override
  Widget build(BuildContext context) {


    height = parentController.height ?? 1;
    width = parentController.width ?? 10;
    cardSize = width*0.3;


    return SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Obx(
          () => Column(
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
                            radius: 41.5,
                            backgroundColor: AppColors.inverseIconColor,
                          ),
                          CircleAvatar(
                            backgroundColor:
                                (controller.user.profileImage) != null
                                    ? AppColors.tabBackColor
                                    : Colors.blue,
                            maxRadius: 40,
                            backgroundImage:
                                (controller.user.profileImage?.value) != null
                                    ? AssetImage(
                                        controller.user.profileImage!.value)
                                    : null,
                            child: (controller.user.profileImage) != null
                                ? null
                                : MainText(controller.user.name?.value[0] ??
                                    "".toUpperCase()),
                          )
                        ],
                      ),
                      const SizedBox(width: 20),
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: height * 0.12,
                child: Card(
                  elevation: 5,
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
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: MainText(
                                      controller.user.part?.value ?? "Unknown",
                                      textColor: AppColors.inverseIconColor,
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
                                Icon(Icons.school, color: AppColors.inverseIconColor),
                                const SizedBox(
                                  width: 10,
                                ),
                                MainText(
                                    controller.user.level?.value ?? "Unknown",
                                    textColor: AppColors.inverseIconColor),
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
                                Icon(Icons.school, color: AppColors.inverseIconColor),
                                const SizedBox(
                                  width: 10,
                                ),
                                MainText(
                                    controller.user.level?.value ?? "Unknown",
                                    textColor: AppColors.inverseIconColor),
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
                height: height*0.05,
              ),
              SecText(
                "Services",
                textColor: AppColors.inverseSecTextColor,
              ),
               SizedBox(
                height: height*0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ServicesCard(
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
                    color: AppColors.mainCardColor,
                    size: cardSize,
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
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ServicesCard(
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
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ServicesCard(
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
        ));
  }
}

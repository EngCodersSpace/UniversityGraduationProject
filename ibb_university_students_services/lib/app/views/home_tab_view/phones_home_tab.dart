// ignore_for_file: must_be_immutable
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/components/news_card.dart';
import 'package:ibb_university_students_services/app/components/services_card.dart';
import 'package:ibb_university_students_services/app/models/doctor_model.dart';
import 'package:ibb_university_students_services/app/models/student_model.dart';

import '../../controllers/tabs_controller/home_tab_controller.dart';
import '../../globals.dart';

class PhoneMainTab extends GetView<HomeTabController> {
  PhoneMainTab({
    super.key,
  });

  double height = Get.height * (1 - 0.16);
  double width = Get.width;
  late double cardSize = (width - width * 0.35) * 1 / 4;

  @override
  Widget build(BuildContext context) {
    controller.startTimer();
    return Obx(() => (controller.initState.value)
        ? SafeArea(
            minimum: EdgeInsets.only(
              top: height * 0.055,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.02,
                      right: width * 0.02,
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
                                      backgroundColor:
                                          AppColors.inverseIconColor,
                                    ),
                                    CircleAvatar(
                                      backgroundColor:
                                          (controller.user?.profileImage) != ""
                                              ? AppColors.tabBackColor
                                              : AppColors.inverseMainTextColor,
                                      maxRadius: width * 0.1 - 2,
                                      backgroundImage: (controller
                                                  .user?.profileImage?.value) !=
                                              ""
                                          ? AssetImage(controller
                                                  .user?.profileImage?.value ??
                                              "")
                                          : null,
                                      child: (controller
                                                  .user?.profileImage?.value) !=
                                              ""
                                          ? null
                                          : MainText(
                                              controller.user?.name?.value[0] ??
                                                  "".toUpperCase()),
                                    )
                                  ],
                                ),
                                SizedBox(width: width * 0.05),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MainText(
                                      controller.user?.name ?? "",
                                      textColor: AppColors.inverseIconColor,
                                    ),
                                    SecText(
                                      "ID : ${controller.user?.id}",
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
                          child: (controller.user is Student)
                              ? Card(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SecText("Department".tr,
                                                textColor: AppColors
                                                    .inverseSecTextColor),
                                            Row(
                                              children: [
                                                Icon(Icons.groups_sharp,
                                                    color:
                                                        AppColors.secTextColor),
                                                SizedBox(
                                                  width: width * 0.025,
                                                ),
                                                // Flexible(
                                                //   child: MainText(
                                                //       (controller.user
                                                //                   as Student)
                                                //               .department??
                                                //           "Unknown".tr,
                                                //       textColor: AppColors
                                                //           .secTextColor,
                                                //       fontSize: 14 *
                                                //           Get.textScaleFactor,
                                                //       height: 0),
                                                // )
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SecText("Level".tr,
                                                textColor: AppColors
                                                    .inverseSecTextColor),
                                            Row(
                                              children: [
                                                Icon(Icons.school,
                                                    color:
                                                        AppColors.secTextColor),
                                                SizedBox(
                                                  width: width * 0.025,
                                                ),
                                                MainText(
                                                    (controller.user as Student)
                                                            .level
                                                            ?.name ??
                                                        "Unknown".tr,
                                                    textColor:
                                                        AppColors.secTextColor),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SecText("Level".tr,
                                                textColor: AppColors
                                                    .inverseSecTextColor),
                                            Row(
                                              children: [
                                                Icon(Icons.school,
                                                    color:
                                                        AppColors.secTextColor),
                                                SizedBox(
                                                  width: width * 0.025,
                                                ),
                                                MainText(
                                                    (controller.user as Student)
                                                            .level
                                                            ?.name ??
                                                        "Unknown".tr,
                                                    textColor:
                                                        AppColors.secTextColor),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Card(
                                  elevation: 16,
                                  surfaceTintColor: AppColors.mainCardColor,
                                  color: AppColors.mainCardColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: (width - 2) * 0.03,
                                      ),
                                      SizedBox(
                                        width: (width - 2) * 0.25,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SecText("Department".tr,
                                                textColor: AppColors
                                                    .inverseSecTextColor),
                                            Row(
                                              children: [
                                                Icon(Icons.groups_sharp,
                                                    color:
                                                        AppColors.secTextColor),
                                                SizedBox(
                                                  width: width * 0.025,
                                                ),
                                                Flexible(
                                                  child: MainText(
                                                      (controller.user
                                                                  as Doctor)
                                                              .section
                                                              ?.name ??
                                                          "Unknown".tr,
                                                      textColor: AppColors
                                                          .secTextColor,
                                                      fontSize: 14 *
                                                          Get.textScaleFactor,
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
                                        width: (width - 2) * 0.03,
                                      ),
                                      SizedBox(
                                        width: (width - 2) * 0.3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SecText("Academic Degree".tr,
                                                textColor: AppColors
                                                    .inverseSecTextColor),
                                            Row(
                                              children: [
                                                Icon(Icons.card_membership,
                                                    color:
                                                        AppColors.secTextColor),
                                                SizedBox(
                                                  width: width * 0.025,
                                                ),
                                                MainText(
                                                    (controller.user as Doctor)
                                                            .academicDegree ??
                                                        "Unknown".tr,
                                                    textColor:
                                                        AppColors.secTextColor,
                                                    fontSize: 14 *
                                                        Get.textScaleFactor,
                                                    height: 0),
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
                                        width: (width - 2) * 0.3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SecText(
                                              "Academic Position".tr,
                                              textColor:
                                                  AppColors.inverseSecTextColor,
                                              fontSize:
                                                  14 * Get.textScaleFactor,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.manage_accounts,
                                                    color:
                                                        AppColors.secTextColor),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                MainText(
                                                    (controller.user as Doctor)
                                                            .administrativePosition ??
                                                        "Unknown".tr,
                                                    textColor:
                                                        AppColors.secTextColor,
                                                    fontSize: 14 *
                                                        Get.textScaleFactor,
                                                    height: 0),
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
                  SingleChildScrollView(
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
                                  onTap: controller.libraryRoute,
                                  size: cardSize,
                                  color: Colors.transparent,
                                  image: const AssetImage(
                                      "assets/images/services_cards/book_6874557.png"),
                                ),
                                SecText(
                                  "Library".tr,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ServicesCard(
                                  onTap: controller.lectureScheduleRoute,
                                  color: Colors.transparent,
                                  size: cardSize,
                                  image: const AssetImage(
                                      "assets/images/services_cards/calendar.png"),
                                ),
                                if (Get.locale?.languageCode == "ar") ...[
                                  SecText(
                                    "${"Schedule".tr}\n${"Lectures".tr}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ] else ...[
                                  SecText(
                                    "${"Lectures".tr}\n${"Schedule".tr}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ]
                              ],
                            ),
                            Column(
                              children: [
                                ServicesCard(
                                  onTap: () {},
                                  size: cardSize,
                                  color: Colors.transparent,
                                  image: const AssetImage(
                                      "assets/images/services_cards/payment.png"),
                                ),
                                SecText(
                                  "Payments".tr,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ServicesCard(
                                  onTap: controller.academicCardRoute,
                                  size: cardSize,
                                  color: Colors.transparent,
                                  image: const AssetImage(
                                      "assets/images/services_cards/credit-card.png"),
                                ),
                                if (Get.locale?.languageCode == "ar") ...[
                                  SecText(
                                    "${"Card".tr}\n${"Academic".tr}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ] else ...[
                                  SecText(
                                    "${"Academic".tr}\n${"Card".tr}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ]
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
                                      "assets/images/services_cards/a-.png"),
                                ),
                                if (Get.locale?.languageCode == "ar") ...[
                                  SecText(
                                    "${"Student".tr}\n${"Degrees".tr}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ] else ...[
                                  SecText(
                                    "${"Degrees".tr}\n${"Student".tr}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ]
                              ],
                            ),
                            Column(
                              children: [
                                ServicesCard(
                                  onTap: () {},
                                  size: cardSize,
                                  color: Colors.transparent,
                                  image: const AssetImage(
                                      "assets/images/services_cards/result.png"),
                                ),
                                if (Get.locale?.languageCode == "ar") ...[
                                  SecText(
                                    "${"Student".tr}\n${"Degrees".tr}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ] else ...[
                                  SecText(
                                    "${"Degrees".tr}\n${"Student".tr}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ]
                              ],
                            ),
                            Column(
                              children: [
                                ServicesCard(
                                  onTap: () {},
                                  color: Colors.transparent,
                                  size: cardSize,
                                  image: const AssetImage(
                                      "assets/images/services_cards/exam_11776326.png"),
                                ),
                                if (Get.locale?.languageCode == "ar") ...[
                                  SecText(
                                    "${"Schedule".tr}\n${"Exam".tr}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ] else ...[
                                  SecText(
                                    "${"Exam".tr}\n${"Schedule".tr}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ]
                              ],
                            ),
                            Column(
                              children: [
                                ServicesCard(
                                  onTap: () {},
                                  size: cardSize,
                                  color: Colors.transparent,
                                  image: const AssetImage(
                                      "assets/images/services_cards/bookshelf_4797659.png"),
                                ),
                                SecText(
                                  "Library".tr,
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
            ))
        : const Center(
            child: CircularProgressIndicator(),
          ));
  }
}

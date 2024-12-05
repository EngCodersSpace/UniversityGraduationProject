// ignore_for_file: must_be_immutable
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/views/home_tab_view/home_tab_components/news_card.dart';
import 'package:ibb_university_students_services/app/views/home_tab_view/home_tab_components/services_card.dart';
import 'package:ibb_university_students_services/app/models/student_model.dart';
import '../../controllers/tabs_controller/home_tab_controller.dart';
import '../../globals.dart';
import 'home_tab_components/doctor_info_card.dart';
import 'home_tab_components/student_info_card.dart';

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
                                      backgroundImage: ((controller
                                                      .user?.profileImage !=
                                                  null) &&
                                              (controller.user?.profileImage !=
                                                  ""))
                                          ? AssetImage(
                                              controller.user?.profileImage ??
                                                  "")
                                          : null,
                                      child: ((controller.user?.profileImage !=
                                                  null) &&
                                              (controller.user?.profileImage !=
                                                  ""))
                                          ? null
                                          : MainText(
                                              controller.user?.name?[0] ??
                                                  "".toUpperCase(),
                                              fontSize: 50,
                                              textColor: AppColors.secTextColor,
                                            ),
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
                              ? const StudentInfoCard()
                              : const DoctorInfoCard(),
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
                  NotificationListener(
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
                                  onTap: controller.examTableRoute,
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

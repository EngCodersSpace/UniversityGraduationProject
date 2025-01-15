// ignore_for_file: must_be_immutable
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/views/home_tab_view/home_tab_components/news_card.dart';
import 'package:ibb_university_students_services/app/views/home_tab_view/home_tab_components/services_card.dart';
import 'package:ibb_university_students_services/app/models/student_model/student.dart';
import '../../components/custom_text_v2.dart';
import '../../controllers/tabs_controller/home_tab_controller.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';
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
                      left: width * 0.01,
                      right: width * 0.01,
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
                                          : CustomText(
                                              controller.user?.name?[0] ??
                                                  "".toUpperCase(),
                                          style: AppTextStyles.secStyle(
                                              textHeader: TextHeaders(fontSize: 50, fontWeight: FontWeight.bold),height: 0)
                                            ),
                                    )
                                  ],
                                ),
                                SizedBox(width: width * 0.05),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      controller.user?.name ?? "",
                                        style: AppTextStyles.secStyle(
                                            textHeader: AppTextHeaders.h1Bold,height: 0)
                                    ),
                                    CustomText(
                                      "ID : ${controller.user?.id}",
                                        style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
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
                        Padding(
                          padding:  EdgeInsets.symmetric(
                            horizontal: Get.width*0.02
                          ),
                          child: CustomText(
                            "News".tr,
                              style: AppTextStyles.highlightStyle(textHeader: AppTextHeaders.h2Bold)
                          ),
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
                        CustomText(
                          "Services".tr,
                            style: AppTextStyles.highlightStyle(textHeader: AppTextHeaders.h2Bold)
                        ),
                        SizedBox(
                          height: height * 0.01,
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
                                CustomText(
                                  "Library".tr,
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
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
                                  CustomText(
                                    "${"Schedule".tr}\n${"Lectures".tr}",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
                                  ),
                                ] else ...[
                                  CustomText(
                                    "${"Lectures".tr}\n${"Schedule".tr}",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
                                  ),
                                ]
                              ],
                            ),
                            Column(
                              children: [
                                ServicesCard(
                                  onTap: controller.paymentsRoute,
                                  size: cardSize,
                                  color: Colors.transparent,
                                  image: const AssetImage(
                                      "assets/images/services_cards/payment.png"),
                                ),
                                CustomText(
                                  "Payments".tr,
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
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
                                  CustomText(
                                    "${"Card".tr}\n${"Academic".tr}",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
                                  ),
                                ] else ...[
                                  CustomText(
                                    "${"Academic".tr}\n${"Card".tr}",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
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
                                  onTap: controller.studentResultRoute,
                                  size: cardSize,
                                  color: Colors.transparent,
                                  image: const AssetImage(
                                      "assets/images/services_cards/a-.png"),
                                ),
                                if (Get.locale?.languageCode == "ar") ...[
                                  CustomText(
                                      "${"Degrees".tr}\n${"Student".tr}",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
                                  ),

                                ] else ...[
                                  CustomText(
                                      "${"Student".tr}\n${"Degrees".tr}",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
                                  ),
                                ]
                              ],
                            ),
                            Column(
                              children: [
                                ServicesCard(
                                  onTap: controller.studentResultRoute,
                                  size: cardSize,
                                  color: Colors.transparent,
                                  image: const AssetImage(
                                      "assets/images/services_cards/result.png"),
                                ),
                                if (Get.locale?.languageCode == "ar") ...[
                                  CustomText(
                                      "${"Degrees".tr}\n${"Student".tr}",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
                                  ),

                                ] else ...[
                                  CustomText(
                                      "${"Student".tr}\n${"Degrees".tr}",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
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
                                  CustomText(
                                    "${"Schedule".tr}\n${"Exam".tr}",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
                                  ),
                                ] else ...[
                                  CustomText(
                                    "${"Exam".tr}\n${"Schedule".tr}",
                                      style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
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
                                CustomText(
                                  "Library".tr,
                                    style: AppTextStyles.secStyle(textHeader: AppTextHeaders.h3Bold)
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

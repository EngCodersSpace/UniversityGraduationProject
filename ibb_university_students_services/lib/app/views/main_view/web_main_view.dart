// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/home_tab_view/web_home_tab.dart';
import 'package:ibb_university_students_services/app/views/lecture_table_tab_view/web_lecture_table_tab_view.dart';
import 'package:ibb_university_students_services/app/views/notification_tab_view/web_notification_view.dart';
import 'package:ibb_university_students_services/app/views/profile_tab_view/web_profile_view.dart';
import '../../components/custom_text_v2.dart';
import '../../controllers/main_controller.dart';
import '../../styles/text_styles.dart';
import '../acadime_card/academic_card_web_view.dart';
import '../exam_table_view/exam_table_web_view.dart';
import '../library_view/library_web_view.dart';
import '../student_results_view/student_results_web_view.dart';

class WebMainView extends GetView<MainController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Container(
            color: AppColors.backColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  color: AppColors.inverseCardColor,
                  width: Get.width * 0.2,
                  height: Get.height,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                    radius: Get.width * 0.03,
                                    backgroundColor: AppColors.mainCardColor),
                                CircleAvatar(
                                  backgroundColor:
                                      (controller.user?.profileImage) != null
                                          ? AppColors.inverseCardColor
                                          : AppColors.inverseMainTextColor,
                                  maxRadius: Get.width * 0.03 - 2,
                                  backgroundImage: (controller
                                              .user?.profileImage) !=
                                          null
                                      ? AssetImage(
                                          controller.user?.profileImage ?? "")
                                      : null,
                                  child: (controller.user?.profileImage) != null
                                      ? null
                                      : CustomText(
                                          controller.user?.name?[0] ??
                                              "".toUpperCase(),
                                    style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Bold,),
                                        ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: Get.width * 0.002,
                            ),
                            Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        controller.user?.name ?? " "
                              ,style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h6Bold,),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        "${controller.user?.id ?? " "}"
                                  ,style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h6Bold,),
                                      ),
                                    ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Divider(
                        thickness: 0.4,
                        color: AppColors.tabBackColor,
                        // indent: 10,
                        endIndent: 15,
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Obx(() => Column(
                            children: [
                              InkWell(
                                onTap: () => controller.changeTabIndex(5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                          24), // Top-left corner rounded
                                      bottomLeft: Radius.circular(
                                          24), // Bottom-left corner rounded
                                    ),
                                    color: (controller.selectedIndex.value == 5)
                                        ? AppColors.tabBackColor
                                        : AppColors.inverseCardColor,
                                  ),
                                  padding: const EdgeInsets.only(left: 25),
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.library_books_outlined,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    5)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.005,
                                      ),
                                      CustomText(
                                        "Library".tr,
                                        style: AppTextStyles.customColorStyle(color: (controller.selectedIndex.value ==
                                            5)
                                            ? AppColors.secTextColor
                                            : AppColors.mainTextColor, textHeader: AppTextHeaders.h6Bold,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.changeTabIndex(4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                          24), // Top-left corner rounded
                                      bottomLeft: Radius.circular(
                                          24), // Bottom-left corner rounded
                                    ),
                                    color: (controller.selectedIndex.value == 4)
                                        ? AppColors.tabBackColor
                                        : AppColors.inverseCardColor,
                                  ),
                                  padding: const EdgeInsets.only(left: 25),
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_outline_sharp,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    4)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SizedBox(width: Get.width * 0.005),
                                      CustomText(
                                        "Profile".tr,
                                        style: AppTextStyles.customColorStyle(color: (controller.selectedIndex.value ==
                                            5)
                                            ? AppColors.secTextColor
                                            : AppColors.mainTextColor, textHeader: AppTextHeaders.h6Bold,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.changeTabIndex(2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                          24), // Top-left corner rounded
                                      bottomLeft: Radius.circular(
                                          24), // Bottom-left corner rounded
                                    ),
                                    color: (controller.selectedIndex.value == 2)
                                        ? AppColors.tabBackColor
                                        : AppColors.inverseCardColor,
                                  ),
                                  padding: const EdgeInsets.only(left: 25),
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.home_outlined,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    2)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.005,
                                      ),
                                      CustomText(
                                        "Home".tr,
                                        style: AppTextStyles.customColorStyle(color: (controller.selectedIndex.value ==
                                            5)
                                            ? AppColors.secTextColor
                                            : AppColors.mainTextColor, textHeader: AppTextHeaders.h6Bold,),)
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.changeTabIndex(0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                          24), // Top-left corner rounded
                                      bottomLeft: Radius.circular(
                                          24), // Bottom-left corner rounded
                                    ),
                                    color: (controller.selectedIndex.value == 0)
                                        ? AppColors.tabBackColor
                                        : AppColors.inverseCardColor,
                                  ),
                                  padding: const EdgeInsets.only(left: 25),
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.notifications_outlined,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    0)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.005,
                                      ),
                                      CustomText(
                                        "Notification".tr,
                                        style: AppTextStyles.customColorStyle(color: (controller.selectedIndex.value ==
                                            5)
                                            ? AppColors.secTextColor
                                            : AppColors.mainTextColor, textHeader: AppTextHeaders.h6Bold,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.changeTabIndex(1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                          24), // Top-left corner rounded
                                      bottomLeft: Radius.circular(
                                          24), // Bottom-left corner rounded
                                    ),
                                    color: (controller.selectedIndex.value == 1)
                                        ? AppColors.tabBackColor
                                        : AppColors.inverseCardColor,
                                  ),
                                  padding: const EdgeInsets.only(left: 25),
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    1)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.005,
                                      ),
                                      CustomText(
                                        "Lecture Table".tr,
                                        style: AppTextStyles.customColorStyle(color: (controller.selectedIndex.value ==
                                            5)
                                            ? AppColors.secTextColor
                                            : AppColors.mainTextColor, textHeader: AppTextHeaders.h6Bold,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.changeTabIndex(3),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                          24), // Top-left corner rounded
                                      bottomLeft: Radius.circular(
                                          24), // Bottom-left corner rounded
                                    ),
                                    color: (controller.selectedIndex.value == 3)
                                        ? AppColors.tabBackColor
                                        : AppColors.inverseCardColor,
                                  ),
                                  padding: const EdgeInsets.only(left: 25),
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.repartition,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    3)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.005,
                                      ),
                                      CustomText(
                                        "Reports".tr,
                                        style: AppTextStyles.customColorStyle(color: (controller.selectedIndex.value ==
                                            5)
                                            ? AppColors.secTextColor
                                            : AppColors.mainTextColor, textHeader: AppTextHeaders.h6Bold,),)
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.changeTabIndex(6),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                          24), // Top-left corner rounded
                                      bottomLeft: Radius.circular(
                                          24), // Bottom-left corner rounded
                                    ),
                                    color: (controller.selectedIndex.value == 6)
                                        ? AppColors.tabBackColor
                                        : AppColors.inverseCardColor,
                                  ),
                                  padding: const EdgeInsets.only(left: 25),
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.assignment_outlined,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    6)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.005,
                                      ),
                                      CustomText(
                                        "Exam Table".tr,
                                        style: AppTextStyles.customColorStyle(color: (controller.selectedIndex.value ==
                                            5)
                                            ? AppColors.secTextColor
                                            : AppColors.mainTextColor, textHeader: AppTextHeaders.h6Bold,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.changeTabIndex(7),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                          24), // Top-left corner rounded
                                      bottomLeft: Radius.circular(
                                          24), // Bottom-left corner rounded
                                    ),
                                    color: (controller.selectedIndex.value == 7)
                                        ? AppColors.tabBackColor
                                        : AppColors.inverseCardColor,
                                  ),
                                  padding: const EdgeInsets.only(left: 25),
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.bar_chart_sharp,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    7)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.005,
                                      ),
                                      CustomText(
                                        "Results".tr,
                                        style: AppTextStyles.customColorStyle(color: (controller.selectedIndex.value ==
                                            5)
                                            ? AppColors.secTextColor
                                            : AppColors.mainTextColor, textHeader: AppTextHeaders.h6Bold,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.putControllers(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                          24), // Top-left corner rounded
                                      bottomLeft: Radius.circular(
                                          24), // Bottom-left corner rounded
                                    ),
                                    color: (controller.selectedIndex.value == 8)
                                        ? AppColors.tabBackColor
                                        : AppColors.inverseCardColor,
                                  ),
                                  padding: const EdgeInsets.only(left: 25),
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.credit_card_sharp,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    8)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.005,
                                      ),
                                      CustomText(
                                        "Acadimic Card".tr,
                                        style: AppTextStyles.customColorStyle(color: (controller.selectedIndex.value ==
                                            5)
                                            ? AppColors.secTextColor
                                            : AppColors.mainTextColor, textHeader: AppTextHeaders.h6Bold,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.mainTextColor,
                  width: Get.width * 0.8,
                  height: Get.height,
                  child: screens[controller.selectedIndex.value],
                ),
              ],
            ),
          ),
        ));
  }

  List screens = [
    const WebNotificationView(),
    WebLectureTableTabView(),
    WebHomeTab(),
    Center(
      child: CustomText(
        "Main page 3",
        style: AppTextStyles.mainStyle(textHeader: AppTextHeaders.h3Bold,),
      ),
    ),
    const WebProfileView(),
    const LibraryWebView(),
    ExamTableWebView(),
    const StudentResultsWebView(),
    const AcademicCardWebView(),
  ];

  WebMainView({super.key});
}

// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/home_tab_view/web_home_tab.dart';
import 'package:ibb_university_students_services/app/views/notification_tab_view/web_notification_view.dart';
import 'package:ibb_university_students_services/app/views/profile_tab_view/web_profile_view.dart';
import 'package:ibb_university_students_services/app/views/table_tab_view/web_table_tab_view.dart';
import '../../components/custom_text.dart';
import '../../controllers/main_controller.dart';
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
                  padding: const EdgeInsets.only(top: 8),
                  color: AppColors.inverseCardColor,
                  width: Get.width * 0.2,
                  height: Get.height,
                  child: Column(
                    children: [
                      Image.asset("assets/images/ibb_university_logo.png"),
                      SizedBox(
                        height: Get.height * 0.005,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainText(
                            "IBB",
                            textColor: AppColors.mainTextColor,
                          ),
                          MainText(
                            "UNIVERCITY",
                            textColor: AppColors.mainTextColor,
                          ),
                          Divider(
                            thickness: 0.2,
                            color: AppColors.tabBackColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      Obx(() => Column(
                            children: [
                              InkWell(
                                onTap: () => controller.selectedIndex.value = 0,
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
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_outline_sharp,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    0)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Library".tr,
                                        fontSize:
                                            (Get.locale?.languageCode == "en")
                                                ? 10
                                                : 8,
                                        fontWeight: FontWeight.bold,
                                        textColor:
                                            (controller.selectedIndex.value ==
                                                    0)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.selectedIndex.value = 1,
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
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_outline_sharp,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    1)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Profile".tr,
                                        fontSize:
                                            (Get.locale?.languageCode == "en")
                                                ? 10
                                                : 8,
                                        fontWeight: FontWeight.bold,
                                        textColor:
                                            (controller.selectedIndex.value ==
                                                    1)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.selectedIndex.value = 2,
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
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.notifications_none,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    2)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Home".tr,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        textColor:
                                            (controller.selectedIndex.value ==
                                                    2)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.selectedIndex.value = 3,
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
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.home_outlined,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    3)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Notification".tr,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        textColor:
                                            (controller.selectedIndex.value ==
                                                    3)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.selectedIndex.value = 4,
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
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    4)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Table".tr,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        textColor:
                                            (controller.selectedIndex.value ==
                                                    4)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.selectedIndex.value = 5,
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
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.repartition,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    5)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Reports".tr,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        textColor:
                                            (controller.selectedIndex.value ==
                                                    5)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.selectedIndex.value = 6,
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
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.repartition,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    6)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Exam Table".tr,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        textColor:
                                            (controller.selectedIndex.value ==
                                                    6)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.selectedIndex.value = 7,
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
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.repartition,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    7)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Results".tr,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        textColor:
                                            (controller.selectedIndex.value ==
                                                    7)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.selectedIndex.value = 8,
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
                                  margin: const EdgeInsets.only(left: 16),
                                  height: Get.height * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.repartition,
                                        color:
                                            (controller.selectedIndex.value ==
                                                    8)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Acadimic Card".tr,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        textColor:
                                            (controller.selectedIndex.value ==
                                                    8)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
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
    const LibraryWebView(),
    const WebProfileView(),
    WebHomeTab(),
    const WebNotificationView(),
    WebTableTabView(),
    Center(
      child: MainText(
        "Main page 3",
        textColor: Colors.black,
      ),
    ),
    ExamTableWebView(),
    const StudentResultsWebView(),
    const AcademicCardWebView(),
  ];

  WebMainView({super.key});
}

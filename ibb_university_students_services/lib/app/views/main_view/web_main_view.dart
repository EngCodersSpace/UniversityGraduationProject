// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/styles/app_colors.dart';
import 'package:ibb_university_students_services/app/views/home_tab_view/web_home_tab.dart';
import 'package:ibb_university_students_services/app/views/lecture_table_tab_view/web_lecture_table_tab_view.dart';
import 'package:ibb_university_students_services/app/views/main_view/web_tabs_component.dart';
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
                  color: AppColors.inverseTabBackColor,
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
                                          style: AppTextStyles.mainStyle(
                                            textHeader: AppTextHeaders.h3Bold,
                                          ),
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
                                        controller.user?.name ?? " ",
                                        style: AppTextStyles.mainStyle(
                                          textHeader: AppTextHeaders.h6Bold,
                                        ),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        "${controller.user?.id ?? " "}",
                                        style: AppTextStyles.mainStyle(
                                          textHeader: AppTextHeaders.h6Bold,
                                        ),
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
                              WebTabsComponent(tabname: "Library", index: 5),
                              WebTabsComponent(tabname: "Profile", index: 4),
                              WebTabsComponent(tabname: "Home", index: 2),
                              WebTabsComponent(
                                  tabname: "Notification", index: 0),
                              WebTabsComponent(
                                  tabname: "Lecture Table", index: 1),
                              WebTabsComponent(tabname: "Reports", index: 3),
                              WebTabsComponent(tabname: "Exam Table", index: 6),
                              WebTabsComponent(tabname: "Results", index: 7),
                              WebTabsComponent(
                                  tabname: "Acadimic Card", index: 8),
                            ],
                          )),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.backColor,
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
        style: AppTextStyles.mainStyle(
          textHeader: AppTextHeaders.h3Bold,
        ),
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

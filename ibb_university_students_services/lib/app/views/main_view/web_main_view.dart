// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/globals.dart';
import 'package:ibb_university_students_services/app/views/home_tab_view/web_home_tab.dart';
import 'package:ibb_university_students_services/app/views/notification_tab_view/web_notification_view.dart';
import 'package:ibb_university_students_services/app/views/profile_tab_view/web_profile_view.dart';
import 'package:ibb_university_students_services/app/views/table_tab_view/web_table_tab_view.dart';
import '../../components/custom_text.dart';
import '../../controllers/main_controller.dart';

class WebMainView extends GetView<MainController> {
  WebMainView({
    super.key,
  });

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
                                        "Profile".tr,
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
                                                    1)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Notification".tr,
                                        fontSize: 10,
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
                                                    3)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Table".tr,
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
                                                    4)
                                                ? AppColors.secTextColor
                                                : AppColors.mainTextColor,
                                      ),
                                      SecText(
                                        "Reports".tr,
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
    const WebProfileView(),
    const WebNotificationView(),
    WebHomeTab(),
    const WebTableTabView(),
    Center(
      child: MainText(
        "Main page 3",
        textColor: Colors.black,
      ),
    ),
  ];
}







 // backgroundColor: AppColors.tabBackColor,
        // drawer: Drawer(
        //   surfaceTintColor: AppColors.backColor,
        //   backgroundColor: AppColors.backColor,
        //   elevation: 32,
        //   width:
        //       (Get.locale?.languageCode == "en") ? Get.height * 0.09 : Get.height * 0.09,
        //   shape: const CircleBorder(),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         width: 200,
        //         color: Colors.blue[900],
        //         child: ListView(
        //           children: [
        //             ListTile(
        //               leading: Tooltip(
        //                 message: 'notification',
        //                 child: Icon(
        //                   Icons.notifications_none,
        //                   color: (controller.selectedIndex.value == 0)
        //                       ? Colors.transparent
        //                       : null,
        //                 ),
        //               ),
        //               onTap: () {
        //                 controller.changeTabIndex(0);
        //               },
        //             ),
        //             ListTile(
        //               leading: Tooltip(
        //                 message: 'calender',
        //                 child: Icon(
        //                   Icons.calendar_month,
        //                   color: (controller.selectedIndex.value == 1)
        //                       ? Colors.transparent
        //                       : null,
        //                 ),
        //               ),
        //               onTap: () {
        //                 controller.changeTabIndex(1);
        //               },
        //             ),
        //             ListTile(
        //               leading: Tooltip(
        //                 message: 'home',
        //                 child: Icon(
        //                   Icons.home,
        //                   color: (controller.selectedIndex.value == 2)
        //                       ? Colors.transparent
        //                       : null,
        //                 ),
        //               ),
        //               onTap: () {
        //                 controller.changeTabIndex(2);
        //               },
        //             ),
        //             ListTile(
        //               leading: Tooltip(
        //                 message: 'reports',
        //                 child: Icon(
        //                   Icons.repartition,
        //                   color: (controller.selectedIndex.value == 3)
        //                       ? Colors.transparent
        //                       : null,
        //                 ),
        //               ),
        //               onTap: () {
        //                 controller.changeTabIndex(3);
        //               },
        //             ),
        //             ListTile(
        //               leading: Tooltip(
        //                 message: 'profile',
        //                 child: Icon(
        //                   Icons.person_outline_sharp,
        //                   color: (controller.selectedIndex.value == 4)
        //                       ? Colors.transparent
        //                       : null,
        //                 ),
        //               ),
        //               onTap: () {
        //                 controller.changeTabIndex(4);
        //               },
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // )


        
// return Obx(

// () => Scaffold(
// body: Row(
//   children: [
//     Container(
//       width: 200,
//       child: ListView(
//         children: [
//           DrawerHeader(
//               decoration: BoxDecoration(
//                 color: AppColors.backColor,
//               ),
//               child: Row(
//                 children: [
//                   MainText(
//                     controller.user?.name?.value ?? "",
//                     textColor: const Color.fromARGB(255, 0, 2, 5),
//                   ),
//                   SecText(
//                     "ID : ${controller.user?.id}",
//                     textColor: const Color.fromARGB(255, 0, 2, 5),
//                   ),
//                 ],
//               )),
//           const SizedBox(
//             height: 20,
//           ),
//           ListTile(
//             onTap: () {},
//             leading: Icon(
//               Icons.person_outline_sharp,
//               color: AppColors.mainIconColor,
//             ),
//             title: Text(
//               "Profile",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.mainTextColor,
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ListTile(
//             onTap: () {},
//             leading: Icon(
//               Icons.home,
//               color: AppColors.mainIconColor,
//             ),
//             title: Text(
//               "Home",
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.mainTextColor),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ListTile(
//             onTap: () {},
//             leading: Icon(
//               Icons.notifications_none,
//               color: AppColors.mainIconColor,
//             ),
//             title: Text(
//               "Notification",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.mainTextColor,
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ListTile(
//             onTap: () {},
//             leading: Icon(
//               Icons.calendar_month,
//               color: AppColors.mainIconColor,
//             ),
//             title: Text(
//               "Table",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.mainIconColor,
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ListTile(
//             onTap: () {},
//             leading: Icon(
//               Icons.repartition,
//               color: AppColors.mainIconColor,
//             ),
//             title: Text(
//               "Report",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.mainTextColor,
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ListTile(
//             onTap: () {},
//             leading: const Icon(Icons.lightbulb_outline),
//             title: Text("Suggestion",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.mainTextColor,
//                 )),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ListTile(
//             onTap: () {},
//             leading: Icon(
//               Icons.help_outline_sharp,
//               color: AppColors.mainIconColor,
//             ),
//             title: Text("Help",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.mainTextColor,
//                 )),
//           ),
//         ],
//       ),
//     )
//   ],
// ),

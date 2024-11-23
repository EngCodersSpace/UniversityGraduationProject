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

  double hight = Get.height;
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    List icons = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            color: AppColors.mainIconColor,
          ),
          SecText(
            "Notification".tr,
            fontSize: 8,
            fontWeight: FontWeight.bold,
            textColor: AppColors.mainTextColor,
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month,
            color: AppColors.mainIconColor,
          ),
          SecText(
            "Table".tr,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            textColor: AppColors.mainTextColor,
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.home_outlined,
            color: AppColors.mainIconColor,
          ),
          SecText(
            "Home".tr,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            textColor: AppColors.mainTextColor,
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.repartition,
            color: AppColors.mainIconColor,
          ),
          SecText(
            "Reports".tr,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            textColor: AppColors.mainTextColor,
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline_sharp,
            color: AppColors.mainIconColor,
          ),
          SecText(
            "Profile".tr,
            fontSize: (Get.locale?.languageCode == "en") ? 10 : 8,
            fontWeight: FontWeight.bold,
            textColor: AppColors.mainTextColor,
          ),
        ],
      ),
    ];

    return Obx(() => Scaffold(
          body: Container(
            color: AppColors.backColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 8),
                  color: AppColors.inverseCardColor,
                  width: Get.width * 0.15,
                  height: Get.height,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: width * 0.05,
                            backgroundColor: AppColors.inverseIconColor,
                          ),
                          CircleAvatar(
                            backgroundColor:
                                (controller.user?.profileImage?.value) != ""
                                    ? AppColors.tabBackColor
                                    : AppColors.inverseMainTextColor,
                            maxRadius: width * 0.056 - 2,
                            backgroundImage: (controller
                                        .user?.profileImage?.value) !=
                                    ""
                                ? AssetImage(
                                    controller.user?.profileImage?.value ?? "")
                                : null,
                            child: (controller.user?.profileImage?.value) != ""
                                ? null
                                : MainText(controller.user?.name?.value[0] ??
                                    "".toUpperCase()),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: hight * 0.03,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainText(
                            "NAME : ${controller.user?.name?.value ?? ""}",
                            fontSize: 24,
                            textColor: AppColors.backColor,
                          ),
                          SecText(
                            "ID : ${controller.user?.id}",
                            textColor: AppColors.backColor,
                          ),
                        ],
                      ),
                      Container(
                        color: AppColors.backColor,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: ()=>controller.changeTabIndex(0),
                              child: Container(
                                color: (controller.selectedIndex.value == 0)?AppColors.tabBackColor:AppColors.inverseCardColor,
                                child: icons[controller.selectedIndex.value],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.backColor,
                  width: Get.width * 0.7,
                  height: Get.height,
                  child: screens[controller.iconindex.value],
                ),
              ],
            ),
          ),
        ));
  }

  List screens = [
    WebProfileView(),
    WebNotificationView(),
    WebHomeTab(),
    WebTableTabView(),
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
        //       (Get.locale?.languageCode == "en") ? hight * 0.09 : hight * 0.09,
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

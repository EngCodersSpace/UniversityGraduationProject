import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/home_tab_controller.dart';
import 'package:ibb_university_students_services/app/globals.dart';

// ignore: must_be_immutable
class WebHomeTab extends GetView<HomeTabController> {
  WebHomeTab({
    super.key,
  });
  double hight = Get.height;
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: AppColors.tabBackColor,
      height: hight,
      width: width * 0.8,
      child: SafeArea(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Container(
              height: hight,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                            radius: Get.width * 0.05,
                            backgroundColor: AppColors.mainCardColor),
                        CircleAvatar(
                          backgroundColor:
                              (controller.user?.profileImage?.value) != null
                                  ? AppColors.inverseCardColor
                                  : AppColors.inverseMainTextColor,
                          maxRadius: Get.width * 0.05 - 2,
                          backgroundImage: (controller
                                      .user?.profileImage?.value) !=
                                  null
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
                      width: Get.height * 0.03,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SecText(
                          "NAME :${controller.user?.name?.value ?? " "}",
                          textColor: AppColors.inverseCardColor,
                          fontWeight: FontWeight.bold,
                        ),
                        SecText(
                          "ID : ${controller.user?.id}",
                          textColor: AppColors.inverseCardColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: (width - 450) * 0.8,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications),
                      color: AppColors.inverseIconColor,
                      alignment: Alignment.topCenter,
                    ),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(
                        () => (controller.initState.value)
                            ? InkWell(
                                onTap: () {},
                                child: Container(
                                  height: width * 0.1,
                                  width: width * 0.22,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.inverseCardColor,
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.6),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                        ],
                                        begin: Alignment.center,
                                        end: Alignment.centerLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        "assets/images/bookshelf_4797659.png",
                                        width: width * 1 / 8,
                                        height: hight * 1 / 8,
                                        alignment: Alignment(-0.55, 0.0),
                                      ),
                                      MainText(
                                        "Library",
                                        textColor: AppColors.tabBackColor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const Placeholder(),
                      ),
                      Obx(
                        () => (controller.initState.value)
                            ? InkWell(
                                onTap: () {},
                                child: Container(
                                  height: width * 0.1,
                                  width: width * 0.22,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.inverseCardColor,
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.6),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                        ],
                                        begin: Alignment.center,
                                        end: Alignment.centerLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        "assets/images/calendar.png",
                                        width: width * 1 / 8,
                                        height: hight * 1 / 8,
                                        alignment: Alignment(-0.3, 0.0),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MainText(
                                            "lecture",
                                            textColor: AppColors.tabBackColor,
                                          ),
                                          MainText(
                                            "schedual",
                                            textColor: AppColors.tabBackColor,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const Placeholder(),
                      ),
                      Obx(
                        () => (controller.initState.value)
                            ? InkWell(
                                onTap: () {},
                                child: Container(
                                  height: width * 0.1,
                                  width: width * 0.22,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.inverseCardColor,
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.6),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                        ],
                                        begin: Alignment.center,
                                        end: Alignment.centerLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        "assets/images/payment.png",
                                        width: width * 1 / 8,
                                        height: hight * 1 / 8,
                                        alignment: Alignment(-0.55, 0.0),
                                      ),
                                      MainText(
                                        "Payment",
                                        textColor: AppColors.tabBackColor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const Placeholder(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(
                        () => (controller.initState.value)
                            ? InkWell(
                                onTap: () {},
                                child: Container(
                                  height: width * 0.1,
                                  width: width * 0.22,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.inverseCardColor,
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.6),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                        ],
                                        begin: Alignment.center,
                                        end: Alignment.centerLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        "assets/images/bookshelf_4797659.png",
                                        width: width * 1 / 8,
                                        height: hight * 1 / 8,
                                        alignment: Alignment(-0.55, 0.0),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MainText(
                                            "Academic",
                                            textColor: AppColors.tabBackColor,
                                          ),
                                          MainText(
                                            "Card",
                                            textColor: AppColors.tabBackColor,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const Placeholder(),
                      ),
                      Obx(
                        () => (controller.initState.value)
                            ? InkWell(
                                onTap: () {},
                                child: Container(
                                  height: width * 0.1,
                                  width: width * 0.22,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.inverseCardColor,
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.6),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                        ],
                                        begin: Alignment.center,
                                        end: Alignment.centerLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        "assets/images/a-.png",
                                        width: width * 1 / 7,
                                        height: hight * 1 / 7,
                                        alignment: Alignment(-0.6, 0.0),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MainText(
                                            "Student",
                                            textColor: AppColors.tabBackColor,
                                          ),
                                          MainText(
                                            "Degrees",
                                            textColor: AppColors.tabBackColor,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const Placeholder(),
                      ),
                      Obx(
                        () => (controller.initState.value)
                            ? InkWell(
                                onTap: () {},
                                child: Container(
                                  height: width * 0.1,
                                  width: width * 0.22,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.inverseCardColor,
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.6),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.7),
                                          AppColors.inverseCardColor
                                              .withOpacity(0.8),
                                          AppColors.inverseCardColor
                                        ],
                                        begin: Alignment.center,
                                        end: Alignment.centerLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        "assets/images/exam_11776326.png",
                                        width: width * 1 / 8,
                                        height: hight * 1 / 8,
                                        alignment: Alignment(-0.35, 0.0),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MainText(
                                            "Exam",
                                            textColor: AppColors.tabBackColor,
                                          ),
                                          MainText(
                                            "Schedule",
                                            textColor: AppColors.tabBackColor,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const Placeholder(),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Obx(
                  //       () => (controller.initState.value)
                  //           ? InkWell(
                  //               onTap: () {},
                  //               child: Container(
                  //                 height: width * 0.1,
                  //                 width: width * 0.22,
                  //                 decoration: BoxDecoration(
                  //                     gradient: LinearGradient(
                  //                       colors: [
                  //                         AppColors.inverseCardColor,
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.8),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.7),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.6),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.7),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.8),
                  //                         AppColors.inverseCardColor
                  //                       ],
                  //                       begin: Alignment.center,
                  //                       end: Alignment.centerLeft,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(24)),
                  //                 child: Row(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceAround,
                  //                   children: [
                  //                     Image.asset(
                  //                       "assets/images/bookshelf_4797659.png",
                  //                       width: width * 1 / 8,
                  //                       height: hight * 1 / 8,
                  //                       alignment: Alignment(-0.55, 0.0),
                  //                     ),
                  //                     MainText(
                  //                       "Library",
                  //                       textColor: AppColors.tabBackColor,
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             )
                  //           : const Placeholder(),
                  //     ),
                  //     Obx(
                  //       () => (controller.initState.value)
                  //           ? InkWell(
                  //               onTap: () {},
                  //               child: Container(
                  //                 height: width * 0.1,
                  //                 width: width * 0.22,
                  //                 decoration: BoxDecoration(
                  //                     gradient: LinearGradient(
                  //                       colors: [
                  //                         AppColors.inverseCardColor,
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.8),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.7),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.6),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.7),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.8),
                  //                         AppColors.inverseCardColor
                  //                       ],
                  //                       begin: Alignment.center,
                  //                       end: Alignment.centerLeft,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(24)),
                  //                 child: Row(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceAround,
                  //                   children: [
                  //                     Image.asset(
                  //                       "assets/images/bookshelf_4797659.png",
                  //                       width: width * 1 / 8,
                  //                       height: hight * 1 / 8,
                  //                       alignment: Alignment(-0.55, 0.0),
                  //                     ),
                  //                     MainText(
                  //                       "Library",
                  //                       textColor: AppColors.tabBackColor,
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             )
                  //           : const Placeholder(),
                  //     ),
                  //     Obx(
                  //       () => (controller.initState.value)
                  //           ? InkWell(
                  //               onTap: () {},
                  //               child: Container(
                  //                 height: width * 0.1,
                  //                 width: width * 0.22,
                  //                 decoration: BoxDecoration(
                  //                     gradient: LinearGradient(
                  //                       colors: [
                  //                         AppColors.inverseCardColor,
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.8),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.7),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.6),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.7),
                  //                         AppColors.inverseCardColor
                  //                             .withOpacity(0.8),
                  //                         AppColors.inverseCardColor
                  //                       ],
                  //                       begin: Alignment.center,
                  //                       end: Alignment.centerLeft,
                  //                     ),
                  //                     borderRadius: BorderRadius.circular(24)),
                  //                 child: Row(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceAround,
                  //                   children: [
                  //                     Image.asset(
                  //                       "assets/images/bookshelf_4797659.png",
                  //                       width: width * 1 / 8,
                  //                       height: hight * 1 / 8,
                  //                       alignment: Alignment(-0.55, 0.0),
                  //                     ),
                  //                     MainText(
                  //                       "Library",
                  //                       textColor: AppColors.tabBackColor,
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             )
                  //           : const Placeholder(),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            )),
      ),
    ));
  }
}
// Column(
//                     children: [
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           CircleAvatar(
//                             radius: Get.width * 0.05,
//                             backgroundColor: AppColors.mainCardColor,
//                           ),
//                           CircleAvatar(
//                             backgroundColor:
//                                 (controller.user?.profileImage?.value) != null
//                                     ? AppColors.tabBackColor
//                                     : AppColors.inverseMainTextColor,
//                             maxRadius: Get.width * 0.05 - 2,
//                             backgroundImage: (controller
//                                         .user?.profileImage?.value) !=
//                                     null
//                                 ? AssetImage(
//                                     controller.user?.profileImage?.value ?? "")
//                                 : null,
//                             child: (controller.user?.profileImage?.value) != ""
//                                 ? null
//                                 : MainText(controller.user?.name?.value[0] ??
//                                     "".toUpperCase()),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: Get.height * 0.03,
//                       ),
//                       Divider(
//                         thickness: 0.1,
//                         color: AppColors.coverColor,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SecText(
//                             "NAME :${controller.user?.name?.value ?? " "}",
//                             textColor: AppColors.mainTextColor,
//                           ),
//                           SecText(
//                             "ID : ${controller.user?.id}",
//                             textColor: AppColors.mainTextColor,
//                           ),
//                         ],
//                       ),
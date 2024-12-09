import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/custom_text.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/home_tab_controller.dart';
import 'package:ibb_university_students_services/app/globals.dart';
import 'package:ibb_university_students_services/app/models/student_model.dart';

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
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: SizedBox(
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
                              (controller.user?.profileImage) != null
                                  ? AppColors.inverseCardColor
                                  : AppColors.inverseMainTextColor,
                          maxRadius: Get.width * 0.05 - 2,
                          backgroundImage: (controller.user?.profileImage) !=
                                  null
                              ? AssetImage(controller.user?.profileImage ?? "")
                              : null,
                          child: (controller.user?.profileImage) != ""
                              ? null
                              : MainText(controller.user?.name?[0] ??
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SecText(
                              "NAME :${controller.user?.name ?? " "}",
                              textColor: AppColors.inverseCardColor,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: width * 0.1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SecText(
                                  "Department",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                SecText((controller.user! as Student)
                                        .section
                                        ?.name
                                        ?.tr ??
                                    "Unknown".tr),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SecText(
                              "ID : ${controller.user?.id}",
                              textColor: AppColors.inverseCardColor,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: width * 0.15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SecText(
                                  "Level",
                                  textColor: AppColors.inverseCardColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                SecText((controller.user as Student)
                                        .level
                                        ?.name
                                        ?.tr ??
                                    "Unknown".tr)
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      width: width * 0.13,
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
                                        "assets/images/services_cards/bookshelf_4797659.png",
                                        width: width * 1 / 10,
                                        height: hight * 1 / 10,
                                        alignment: const Alignment(-0.4, 0.0),
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
                                        "assets/images/services_cards/calendar.png",
                                        width: width * 1 / 10,
                                        height: hight * 1 / 10,
                                        alignment: const Alignment(-0.15, 0.0),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MainText(
                                            "lecture",
                                            textColor: AppColors.tabBackColor,
                                            fontSize: 22,
                                          ),
                                          MainText(
                                            "schedual",
                                            textColor: AppColors.tabBackColor,
                                            fontSize: 22,
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
                                        "assets/images/services_cards/payment.png",
                                        width: width * 1 / 10,
                                        height: hight * 1 / 10,
                                        alignment: const Alignment(-0.4, 0.0),
                                      ),
                                      MainText(
                                        "Payment",
                                        textColor: AppColors.tabBackColor,
                                        fontSize: 22,
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
                                        "assets/images/services_cards/credit-card.png",
                                        width: width * 1 / 10,
                                        height: hight * 1 / 10,
                                        alignment: const Alignment(-0.1, 0.0),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MainText(
                                            "Academic",
                                            textColor: AppColors.tabBackColor,
                                            fontSize: 22,
                                          ),
                                          MainText(
                                            "Card",
                                            textColor: AppColors.tabBackColor,
                                            fontSize: 22,
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
                                        "assets/images/services_cards/a-.png",
                                        width: width * 1 / 8,
                                        height: hight * 1 / 8,
                                        alignment: const Alignment(-0.5, 0.0),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MainText(
                                            "Student",
                                            textColor: AppColors.tabBackColor,
                                            fontSize: 22,
                                          ),
                                          MainText(
                                            "Degrees",
                                            textColor: AppColors.tabBackColor,
                                            fontSize: 22,
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
                                        "assets/images/services_cards/exam_11776326.png",
                                        width: width * 1 / 10,
                                        height: hight * 1 / 10,
                                        alignment: const Alignment(-0.1, 0.0),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MainText(
                                            "Exam",
                                            textColor: AppColors.tabBackColor,
                                            fontSize: 22,
                                          ),
                                          MainText(
                                            "Schedule",
                                            textColor: AppColors.tabBackColor,
                                            fontSize: 22,
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
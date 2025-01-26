import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/home_tab_controller.dart';
import '../../components/custom_text_v2.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

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
        // ignore: sized_box_for_whitespace
        body: Container(
      color: AppColors.tabBackColor,
      width: width,
      height: hight,
      child: Column(
        children: [
          Container(
            width: width,
            height: hight * 0.25,
            decoration: BoxDecoration(
              color: AppColors.inverseMainTextColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 5),
                )
              ],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      child: Row(
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
                                backgroundImage:
                                    (controller.user?.profileImage) != null
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
                            width: width * 0.002,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomText(
                                  "Hi! ${controller.user?.name ?? " "}",
                                  style: AppTextStyles.mainStyle(
                                    textHeader: AppTextHeaders.h6Bold,
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.3,
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.1,
                            decoration: BoxDecoration(
                              color: AppColors.backColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Upload",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.inverseMainTextColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: width * 0.003,
                                  ),
                                  const Icon(Icons.file_upload_outlined),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Container(
                            width: width * 0.1,
                            decoration: BoxDecoration(
                              color: AppColors.backColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Download",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.inverseMainTextColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: width * 0.003,
                                  ),
                                  const Icon(
                                    Icons.file_download_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: hight * 0.05,
                ),
                Container(
                  // width: width*0.3,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Search",
                        fillColor: AppColors.backColor,
                        filled: true,
                        suffixIcon: const Icon(
                          Icons.search_outlined,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        )),
                  ),
                ),
              ],
            ),

            // child: SafeArea(
            //   child: SingleChildScrollView(
            //       scrollDirection: Axis.vertical,
            //       padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            //       child: SizedBox(
            //         height: hight,
            //         width: width,
            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Row(children: [
            //       Stack(
            //         alignment: Alignment.center,
            //         children: [
            //           CircleAvatar(
            //               radius: Get.width * 0.05,
            //               backgroundColor: AppColors.mainCardColor),
            //           CircleAvatar(
            //             backgroundColor:
            //                 (controller.user?.profileImage) != null
            //                     ? AppColors.inverseCardColor
            //                     : AppColors.inverseMainTextColor,
            //             maxRadius: Get.width * 0.05 - 2,
            //             backgroundImage: (controller.user?.profileImage) !=
            //                     null
            //                 ? AssetImage(controller.user?.profileImage ?? "")
            //                 : null,
            //             child: (controller.user?.profileImage) != ""
            //                 ? null
            //                 : CustomText(controller.user?.name?[0] ??
            //                     "".toUpperCase()),
            //           ),
            //         ],
            //       ),
            //       SizedBox(
            //         width: Get.height * 0.03,
            //       ),
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               SecText(
            //                 "NAME :${controller.user?.name ?? " "}",
            //                 textColor: AppColors.inverseCardColor,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //               SizedBox(
            //                 width: width * 0.1,
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: [
            //                   SecText(
            //                     "Department",
            //                     textColor: AppColors.inverseCardColor,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                   SizedBox(
            //                     width: width * 0.03,
            //                   ),
            //                   SecText((controller.user! as Student)
            //                           .section
            //                           ?.name
            //                           ?.tr ??
            //                       "Unknown".tr),
            //                 ],
            //               ),
            //             ],
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               SecText(
            //                 "ID : ${controller.user?.id}",
            //                 textColor: AppColors.inverseCardColor,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //               SizedBox(
            //                 width: width * 0.15,
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: [
            //                   SecText(
            //                     "Level",
            //                     textColor: AppColors.inverseCardColor,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                   SizedBox(
            //                     width: width * 0.03,
            //                   ),
            //                   SecText((controller.user as Student)
            //                           .level
            //                           ?.name
            //                           ?.tr ??
            //                       "Unknown".tr)
            //                 ],
            //               ),
            //             ],
            //           )
            //         ],
            //       ),
            //               SizedBox(
            //                 width: width * 0.13,
            //               ),
            //               IconButton(
            //                 onPressed: () {},
            //                 icon: const Icon(Icons.notifications),
            //                 color: AppColors.inverseIconColor,
            //                 alignment: Alignment.topCenter,
            //               ),
            //             ]),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceAround,
            //               children: [
            //                 Obx(
            //                   () => (controller.initState.value)
            //                       ? InkWell(
            //                           onTap: () {},
            //                           child: Container(
            //                             height: width * 0.1,
            //                             width: width * 0.22,
            //                             decoration: BoxDecoration(
            //                                 gradient: LinearGradient(
            //                                   colors: [
            //                                     AppColors.inverseCardColor,
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.6),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                   ],
            //                                   begin: Alignment.center,
            //                                   end: Alignment.centerLeft,
            //                                 ),
            //                                 borderRadius: BorderRadius.circular(24)),
            //                             child: Row(
            //                               mainAxisSize: MainAxisSize.min,
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.spaceAround,
            //                               children: [
            //                                 Image.asset(
            //                                   "assets/images/services_cards/bookshelf_4797659.png",
            //                                   width: width * 1 / 10,
            //                                   height: hight * 1 / 10,
            //                                   alignment: const Alignment(-0.4, 0.0),
            //                                 ),
            //                                 CustomText(
            //                                   "Library",
            //                                   textColor: AppColors.tabBackColor,
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         )
            //                       : const Placeholder(),
            //                 ),
            //                 Obx(
            //                   () => (controller.initState.value)
            //                       ? InkWell(
            //                           onTap: () {},
            //                           child: Container(
            //                             height: width * 0.1,
            //                             width: width * 0.22,
            //                             decoration: BoxDecoration(
            //                                 gradient: LinearGradient(
            //                                   colors: [
            //                                     AppColors.inverseCardColor,
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.6),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                   ],
            //                                   begin: Alignment.center,
            //                                   end: Alignment.centerLeft,
            //                                 ),
            //                                 borderRadius: BorderRadius.circular(24)),
            //                             child: Row(
            //                               mainAxisSize: MainAxisSize.min,
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.spaceAround,
            //                               children: [
            //                                 Image.asset(
            //                                   "assets/images/services_cards/calendar.png",
            //                                   width: width * 1 / 10,
            //                                   height: hight * 1 / 10,
            //                                   alignment: const Alignment(-0.15, 0.0),
            //                                 ),
            //                                 Column(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.center,
            //                                   children: [
            //                                     CustomText(
            //                                       "lecture",
            //                                       textColor: AppColors.tabBackColor,
            //                                       fontSize: 22,
            //                                     ),
            //                                     CustomText(
            //                                       "schedual",
            //                                       textColor: AppColors.tabBackColor,
            //                                       fontSize: 22,
            //                                     ),
            //                                   ],
            //                                 )
            //                               ],
            //                             ),
            //                           ),
            //                         )
            //                       : const Placeholder(),
            //                 ),
            //                 Obx(
            //                   () => (controller.initState.value)
            //                       ? InkWell(
            //                           onTap: () {},
            //                           child: Container(
            //                             height: width * 0.1,
            //                             width: width * 0.22,
            //                             decoration: BoxDecoration(
            //                                 gradient: LinearGradient(
            //                                   colors: [
            //                                     AppColors.inverseCardColor,
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.6),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                   ],
            //                                   begin: Alignment.center,
            //                                   end: Alignment.centerLeft,
            //                                 ),
            //                                 borderRadius: BorderRadius.circular(24)),
            //                             child: Row(
            //                               mainAxisSize: MainAxisSize.min,
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.spaceAround,
            //                               children: [
            //                                 Image.asset(
            //                                   "assets/images/services_cards/payment.png",
            //                                   width: width * 1 / 10,
            //                                   height: hight * 1 / 10,
            //                                   alignment: const Alignment(-0.4, 0.0),
            //                                 ),
            //                                 CustomText(
            //                                   "Payment",
            //                                   textColor: AppColors.tabBackColor,
            //                                   fontSize: 22,
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         )
            //                       : const Placeholder(),
            //                 ),
            //               ],
            //             ),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceAround,
            //               children: [
            //                 Obx(
            //                   () => (controller.initState.value)
            //                       ? InkWell(
            //                           onTap: () {},
            //                           child: Container(
            //                             height: width * 0.1,
            //                             width: width * 0.22,
            //                             decoration: BoxDecoration(
            //                                 gradient: LinearGradient(
            //                                   colors: [
            //                                     AppColors.inverseCardColor,
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.6),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                   ],
            //                                   begin: Alignment.center,
            //                                   end: Alignment.centerLeft,
            //                                 ),
            //                                 borderRadius: BorderRadius.circular(24)),
            //                             child: Row(
            //                               mainAxisSize: MainAxisSize.min,
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.spaceAround,
            //                               children: [
            //                                 Image.asset(
            //                                   "assets/images/services_cards/credit-card.png",
            //                                   width: width * 1 / 10,
            //                                   height: hight * 1 / 10,
            //                                   alignment: const Alignment(-0.1, 0.0),
            //                                 ),
            //                                 Column(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.center,
            //                                   children: [
            //                                     CustomText(
            //                                       "Academic",
            //                                       textColor: AppColors.tabBackColor,
            //                                       fontSize: 22,
            //                                     ),
            //                                     CustomText(
            //                                       "Card",
            //                                       textColor: AppColors.tabBackColor,
            //                                       fontSize: 22,
            //                                     ),
            //                                   ],
            //                                 )
            //                               ],
            //                             ),
            //                           ),
            //                         )
            //                       : const Placeholder(),
            //                 ),
            //                 Obx(
            //                   () => (controller.initState.value)
            //                       ? InkWell(
            //                           onTap: () {},
            //                           child: Container(
            //                             height: width * 0.1,
            //                             width: width * 0.22,
            //                             decoration: BoxDecoration(
            //                                 gradient: LinearGradient(
            //                                   colors: [
            //                                     AppColors.inverseCardColor,
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.6),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                   ],
            //                                   begin: Alignment.center,
            //                                   end: Alignment.centerLeft,
            //                                 ),
            //                                 borderRadius: BorderRadius.circular(24)),
            //                             child: Row(
            //                               mainAxisSize: MainAxisSize.min,
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.spaceAround,
            //                               children: [
            //                                 Image.asset(
            //                                   "assets/images/services_cards/a-.png",
            //                                   width: width * 1 / 8,
            //                                   height: hight * 1 / 8,
            //                                   alignment: const Alignment(-0.5, 0.0),
            //                                 ),
            //                                 Column(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.center,
            //                                   children: [
            //                                     CustomText(
            //                                       "Student",
            //                                       textColor: AppColors.tabBackColor,
            //                                       fontSize: 22,
            //                                     ),
            //                                     CustomText(
            //                                       "Degrees",
            //                                       textColor: AppColors.tabBackColor,
            //                                       fontSize: 22,
            //                                     ),
            //                                   ],
            //                                 )
            //                               ],
            //                             ),
            //                           ),
            //                         )
            //                       : const Placeholder(),
            //                 ),
            //                 Obx(
            //                   () => (controller.initState.value)
            //                       ? InkWell(
            //                           onTap: () {},
            //                           child: Container(
            //                             height: width * 0.1,
            //                             width: width * 0.22,
            //                             decoration: BoxDecoration(
            //                                 gradient: LinearGradient(
            //                                   colors: [
            //                                     AppColors.inverseCardColor,
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.6),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.7),
            //                                     AppColors.inverseCardColor
            //                                         .withOpacity(0.8),
            //                                     AppColors.inverseCardColor
            //                                   ],
            //                                   begin: Alignment.center,
            //                                   end: Alignment.centerLeft,
            //                                 ),
            //                                 borderRadius: BorderRadius.circular(24)),
            //                             child: Row(
            //                               mainAxisSize: MainAxisSize.min,
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.spaceAround,
            //                               children: [
            //                                 Image.asset(
            //                                   "assets/images/services_cards/exam_11776326.png",
            //                                   width: width * 1 / 10,
            //                                   height: hight * 1 / 10,
            //                                   alignment: const Alignment(-0.1, 0.0),
            //                                 ),
            //                                 Column(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.center,
            //                                   children: [
            //                                     CustomText(
            //                                       "Exam",
            //                                       textColor: AppColors.tabBackColor,
            //                                       fontSize: 22,
            //                                     ),
            //                                     CustomText(
            //                                       "Schedule",
            //                                       textColor: AppColors.tabBackColor,
            //                                       fontSize: 22,
            //                                     ),
            //                                   ],
            //                                 )
            //                               ],
            //                             ),
            //                           ),
            //                         )
            //                       : const Placeholder(),
            //                 ),
            //               ],
            //             ),

            //           ],
            //         ),
            //       )),
            // ),
          ),
        ],
      ),
    ));
  }
}

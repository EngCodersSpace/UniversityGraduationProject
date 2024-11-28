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
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Container(
              height: hight - 600,
              width: width - 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => (controller.initState.value)
                        ? InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.inverseCardColor,
                                      AppColors.inverseCardColor
                                          .withOpacity(0.8),
                                      AppColors.inverseCardColor
                                          .withOpacity(0.6),
                                      AppColors.inverseCardColor
                                          .withOpacity(0.8),
                                      AppColors.inverseCardColor
                                    ],
                                    begin: Alignment.center,
                                    end: Alignment.centerLeft,
                                  ),
                                  borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/bookshelf_4797659.png",
                                    width: width * 1 / 12,
                                    height: hight * 1 / 12,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      MainText(
                                        "Library",
                                        textColor: AppColors.tabBackColor,
                                      ),
                                      // SecText(
                                      //   "this library gives you what you need during your educational career",
                                      //   fontSize: 12,
                                      //   textColor: AppColors.tabBackColor,
                                      // ),
                                    ],
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
                            child: Card(
                              color: Color.fromARGB(211, 105, 187, 243),
                              //surfaceTintColor: Color.fromARGB(214, 9, 98, 157),
                              elevation: 10.0,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/book.png",
                                    width: width * 1 / 7,
                                    height: hight * 1 / 7,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      MainText(
                                        "Library",
                                        textColor: AppColors.tabBackColor,
                                      ),
                                      // SecText(
                                      //   "this library gives you what you need during your educational career",
                                      //   fontSize: 12,
                                      //   textColor: AppColors.tabBackColor,
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const Placeholder(),
                  ),
                ],
              ),
            )),
      ),
    ));
  }
}

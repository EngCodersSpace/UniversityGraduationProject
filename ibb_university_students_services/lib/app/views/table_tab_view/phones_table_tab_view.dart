// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/components/buttons.dart';
import 'package:ibb_university_students_services/app/components/day_cards.dart';

import '../../controllers/tabs_controller/table_tab_view_controller.dart';
import '../../globals.dart';

class PhoneTableTabView extends GetView<TableTabController> {
  PhoneTableTabView({super.key});

  double height = Get.height;
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            Container(
                height: height * 0.3,
                width: width,
                decoration: BoxDecoration(
                  color: AppColors.mainCardColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 5),
                    )
                  ],
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      onPress: () {},
                      text: "Show All",
                      size: Size(width * 0.4, 60),
                    ),
                    SizedBox(
                      width: width*0.96,
                      height: height * 0.12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                (controller.selected.value > 0)
                                    ? controller.selected.value--
                                    : null;
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.inverseIconColor,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DayCard(
                                height: height * 0.09,
                                text: "sun",
                                selected: (controller.selected.value == 0),
                                onPress: () {
                                  controller.selected.value = 0;
                                },
                              ),
                              DayCard(
                                  height: height * 0.09,
                                  text: "mon",
                                  selected: (controller.selected.value == 1),
                                  onPress: () {
                                    controller.selected.value = 1;
                                  }),
                              DayCard(
                                  height: height * 0.09,
                                  text: "tue",
                                  selected: (controller.selected.value == 2),
                                  onPress: () {
                                    controller.selected.value = 2;
                                  }),
                              DayCard(
                                  height: height * 0.09,
                                  text: "wed",
                                  selected: (controller.selected.value == 3),
                                  onPress: () {
                                    controller.selected.value = 3;
                                  }),
                              DayCard(
                                  height: height * 0.09,
                                  text: "the",
                                  selected: (controller.selected.value == 4),
                                  onPress: () {
                                    controller.selected.value = 4;
                                  }),
                              DayCard(
                                  height: height * 0.09,
                                  text: "sat",
                                  selected: (controller.selected.value == 5),
                                  onPress: () {
                                    controller.selected.value = 5;
                                  }),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                (controller.selected.value < 5)
                                    ? controller.selected.value++
                                    : null;
                              },
                              icon: Icon(Icons.arrow_forward_ios,
                                  color: AppColors.inverseIconColor))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    )
                  ],
                )),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(controller.tableTime?.sun?.first.startTime.value ?? ""),
              ),
            ),
          ],
        ));
  }
}

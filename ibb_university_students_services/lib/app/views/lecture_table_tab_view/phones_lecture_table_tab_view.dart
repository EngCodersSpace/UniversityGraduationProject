// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/tabs_controller/table_tab_view_controller.dart';

class PhoneLectureTableTabView extends GetView<TableTabController> {
  PhoneLectureTableTabView({super.key});

  double height = Get.height * (1 - 0.09);
  double width = Get.width;

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.loadState.value)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: [


              Container(
                height: height,
                width: 40,
                color: Colors.red,
              ),
            ],
          ));
  }
}

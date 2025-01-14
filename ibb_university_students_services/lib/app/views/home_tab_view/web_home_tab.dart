import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/tabs_controller/home_tab_controller.dart';

// ignore: must_be_immutable
class WebHomeTab extends GetView<HomeTabController> {
  WebHomeTab({
    super.key,
  });
  double hight = Get.height;
  double width = Get.width;
  late double cardsize = (width - width * 0.35);

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.initState.value)
        ? SafeArea(
            minimum: EdgeInsets.only(
              top: hight * 0.3,
            ),
            child: SingleChildScrollView(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.04, right: width * 0.04),
                  child: Container(
                    width: 80,
                    color: Colors.blue[900],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.all(5),
                    ),
                  ),
                )
              ],
            )),
          )
        : const Center(
            child: const CircularProgressIndicator(),
          ));
  }
}

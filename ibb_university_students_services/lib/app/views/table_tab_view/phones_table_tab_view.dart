import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/tabs_controller/table_tab_view_controller.dart';

class PhoneTableTabView extends GetView<TableTabController> {
  const PhoneTableTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        Text(controller.name.value),
        Container(
          color: Colors.black,
        )
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/tabs_controller/table_tab_view_controller.dart';

class PhoneTableTabView extends GetView<TableTabController> {
  const PhoneTableTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        Center(child: TextButton(onPressed: (){

        }, child: Text(controller.tableTime?.sun?.first.time.value??""),),),
      ],
    ));
  }
}

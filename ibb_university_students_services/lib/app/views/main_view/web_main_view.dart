// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/custom_text.dart';
import '../../controllers/main_controller.dart';

class WebMainView extends StatelessWidget {
   WebMainView({
    super.key,
    this.height,
    this.width,
   });

  double? height;
  double? width;
  double? fontScale;

  MainController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: MainText("MainPage"),
    );
  }
}

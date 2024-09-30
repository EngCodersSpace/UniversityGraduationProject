// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/custom_text.dart';
import '../../controllers/main_controller.dart';

class WebMainView extends GetView<MainController> {
   const WebMainView({
    super.key,
   });

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: MainText("MainPage"),
    );
  }
}

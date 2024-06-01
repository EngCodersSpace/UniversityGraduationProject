import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/custom_text.dart';
import '../views/main_view/main_view_taps/main_tab.dart';

class MainController extends GetxController {

  RxInt selectedIndex = 0.obs;
  double? height;
  double? width;
  List? screens;

  // Define a list of screens
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    screens = [
      MainTab(),
      Center(
        child: MainText(
          "MainPage 1",
          textColor: Colors.black,
        ),
      ),
      Center(
        child: MainText(
          "MainPage 2",
          textColor: Colors.black,
        ),
      ),
      Center(
        child: MainText(
          "MainPage 3",
          textColor: Colors.black,
        ),
      ),
      Center(
        child: MainText(
          "MainPage 4",
          textColor: Colors.black,
        ),
      ),
      //Center(child: MainText("MainPage 5",textColor: Colors.black,),),
    ];
  }


  // Method to change the selected index
  void changeTabIndex(int index) {
    selectedIndex.value = index;

  }

  void setHeightWidth(double height,double width){
    this.height = height;
    this.width = width;
  }

  @override
  void onClose() {}
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/custom_text.dart';

class MainController extends GetxController {
  RxInt selectedIndex = 0.obs;

  // Define a list of screens
  final List<Widget> screens = [
    Center(child: MainText("MainPage 1",textColor: Colors.black,),),
    Center(child: MainText("MainPage 2",textColor: Colors.black,),),
    Center(child: MainText("MainPage 3",textColor: Colors.black,),),
  ];

  // Method to change the selected index
  void changeTabIndex(int index) {
  selectedIndex.value = index;
  }

  @override
  void onClose() {
  }

}


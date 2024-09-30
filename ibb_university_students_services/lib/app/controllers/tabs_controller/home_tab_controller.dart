import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/result.dart';
import 'package:ibb_university_students_services/app/services/user_services.dart';

import '../../models/user_model.dart';

class HomeTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  User? user;
  RxBool initState = false.obs;
  late TabController tabController;

  ScrollController scrollController = ScrollController();
  late Timer _timer;
  int _newsCurrentPos = 0;

  @override
  void onClose() {
    tabController.dispose();
  }


  bool scrollEvent(UserScrollNotification s) {
    try{

      Duration d = const Duration(seconds: 0, milliseconds: 500);
      _timer.cancel();
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _newsCurrentPos++;
        _newsCurrentPos == 3 ? _newsCurrentPos = 2 : null;
        newsAnimate(Get.width * 0.8, _newsCurrentPos, d);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _newsCurrentPos--;
        _newsCurrentPos == -1 ? _newsCurrentPos = 0 : null;
        newsAnimate(Get.width * 0.8, _newsCurrentPos, d);
      }
      _startTimer();
    }catch(e){
      print("e");
    }
    return false;
  }

  void _startTimer() {
    try{
      const duration = Duration(seconds: 5);
      _timer = Timer.periodic(duration, (timer) {
        _newsCurrentPos++;
        if (_newsCurrentPos > 2) {
          _newsCurrentPos = 0;
          scrollController.jumpTo(0);
        }
        newsAnimate(Get.width * 0.8, _newsCurrentPos,
            const Duration(seconds: 2, milliseconds: 500));
      });
    }catch(e){}
  }

  void newsAnimate(double width, int i, Duration duration) {
    try{
      scrollController.animateTo(width * i,
          duration: duration, curve: Curves.easeInOutQuart);
      tabController.animateTo(i, duration: duration);
    }catch(e){}
  }


  @override
  void onReady() async {

    Result res = await UserServices.fetchUser();
    if (res.statusCode == 200) {
      user = res.data;
    }
    tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    _startTimer();
    initState.value = true;
    super.onReady();
  }
}

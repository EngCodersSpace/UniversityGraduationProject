import 'dart:async';

import 'package:flutter/foundation.dart';
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
  void onInit() async {
    Result res = await UserServices.fetchUser();
    if (res.statusCode == 200) {
      user = res.data;
    }
    tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    _setUpTimer();
    initState.value = true;
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
  }

  void _setUpTimer() {
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print("${e.toString()}\n_____________________________________________");
      }
    }
  }

  void startTimer() {
    try {
      _timer.cancel();
      _newsCurrentPos = 0;
      tabController.animateTo(0);
      _setUpTimer();
    } catch (e) {
      if (kDebugMode) {
        print("${e.toString()}\n_____________________________________________");
      }
    }
  }

  void newsAnimate(double width, int i, Duration duration) {
    try {
      scrollController.animateTo(width * i,
          duration: duration, curve: Curves.easeInOutQuart);
      tabController.animateTo(i, duration: duration);
    } catch (e) {
      if (kDebugMode) {
        print("${e.toString()}\n_____________________________________________");
      }
    }
  }
}

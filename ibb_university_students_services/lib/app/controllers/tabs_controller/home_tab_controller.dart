import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../models/result.dart';
import '../../services/user_services.dart';
import '../../models/user_model/user.dart';
import '../main_controller.dart';

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

  bool scrollEvent(UserScrollNotification s) {
    try {
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
      _setUpTimer();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  void _setUpTimer() {
    try {
      const duration = Duration(seconds: 5);
      _timer = Timer.periodic(duration, (timer) {
        _newsCurrentPos++;
        if (_newsCurrentPos > 2) {
          _newsCurrentPos = 0;
          if (scrollController.hasClients) {
            scrollController.jumpTo(0);
          }
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
      tabController.index = (0);
      _setUpTimer();
    } catch (e) {
      if (kDebugMode) {
        print("${e.toString()}\n_____________________________________________");
      }
    }
  }

  void newsAnimate(double width, int i, Duration duration) {
    try {
      if (scrollController.hasClients) {
        scrollController.animateTo(width * i,
            duration: duration, curve: Curves.easeInOutQuart);
        tabController.animateTo(i, duration: duration);
      }
    } catch (e) {
      if (kDebugMode) {
        print("${e.toString()}\n_____________________________________________");
      }
    }
  }

  void libraryRoute() {
    Get.toNamed("/library");
  }

  void lectureScheduleRoute() {
    Get.find<MainController>().changeTabIndex(1);
  }

  void academicCardRoute() {
    Get.toNamed("/academic_card");
  }
  void paymentsRoute() {
    Get.toNamed("/student_payments");
  }

  void examTableRoute() {
    Get.toNamed("/exam_table");
  }

  void studentResultRoute() {
    Get.toNamed("/student_result");
  }

}

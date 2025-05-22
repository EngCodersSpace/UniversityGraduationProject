import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/setting_controller.dart';
import 'package:ibb_university_students_services/app/views/home_tab_view/home_tab_components/settings_card.dart';
import '../../models/helper_models/result.dart';
import '../../repositories/user_repository.dart';
import '../../models/user_model/user.dart';
import '../main_controller.dart';
import '../news_controller.dart';

class HomeTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  User? user;
  RxBool initState = false.obs;
  TabController? tabController;
  ScrollController scrollController = ScrollController();
  Timer? _timer;
  int _newsCurrentPos = 0;
  NewsController? newsController = Get.find<NewsController>();

  @override
  void onInit() async {
    Result res = await UserRepository.fetchUser();
    print(res.statusCode);
    print(res.data);
    if (res.statusCode == 200) {
      user = res.data;
    }
    await setUpNewsCards();
    initState.value = true;
    super.onInit();
  }

  @override
  void refresh() async {
    Result res = await UserRepository.fetchUser();
    if (res.statusCode == 200) {
      user = res.data;
      initState.refresh();
    }
    await setUpNewsCards();
    super.refresh();
  }

  Future<void> setUpNewsCards() async {
    await newsController?.fetchNews(limit: 5);
    // tabController?.dispose();
    tabController = TabController(
        length: newsController?.news.length ?? 0, initialIndex: 0, vsync: this);
    if((tabController?.length??1)>1){
      startTimer();
    }
    update(["tadsIndicator", "newsCards"]);
  }

  @override
  void onClose() {
    tabController?.dispose();
  }

  bool scrollEvent(UserScrollNotification s) {
    try {
      Duration d = const Duration(seconds: 0, milliseconds: 500);
      _timer?.cancel();
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

  showSettings() {
    Get.put(SettingController());
    Get.dialog(PopUpSettingsCard())
        .then((_) => Get.delete<SettingController>());
  }

  void _setUpTimer() {
    try {
      const duration = Duration(seconds: 6);
      _timer = Timer.periodic(duration, (timer) {
        _newsCurrentPos++;
        if (_newsCurrentPos > (tabController?.length ?? 0)) {
          _newsCurrentPos = 0;
          if (scrollController.hasClients) {
            scrollController.jumpTo(0);
          }
        }
        newsAnimate(Get.width * 0.8, _newsCurrentPos,
            const Duration(seconds: 3, milliseconds: 500));
      });
    } catch (e) {
      if (kDebugMode) {
        print("${e.toString()}\n_____________________________________________");
      }
    }
  }

  void startTimer() {
    try {
      _timer?.cancel();
      _newsCurrentPos = 0;
      tabController?.index = (0);
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
        tabController?.animateTo(i, duration: duration);
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

  void assignmentsScheduleRoute() {
    Get.find<MainController>().changeTabIndex(3);
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

  void pepperTransactionsRoute() {
    Get.toNamed("/pepper_transactions");
  }

  void openNewsList() {
    Get.toNamed("news_list");
  }

  void openNews(int i) {
    Get.toNamed("news");
  }
}

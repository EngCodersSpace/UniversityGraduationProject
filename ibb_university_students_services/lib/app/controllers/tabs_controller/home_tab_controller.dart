import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/user_model.dart';

import '../../models/structuers/user_structure.dart';

class HomeTabController extends GetxController with GetSingleTickerProviderStateMixin{
  User user = UserModel.fetchUser();

  late TabController tabController ;
  ScrollController scrollController = ScrollController();
  late Timer _timer;
  int _newsCurrentPos = 0;


  @override
  void onClose() {
    tabController.dispose();
  }
  @override
  void onInit() {
    tabController = TabController(length: 3,initialIndex: 0, vsync:this);
    _startTimer();

    super.onInit();
  }

  bool scrollEvent(UserScrollNotification s){
    Duration d = const Duration(seconds: 0,milliseconds: 500);
    _timer.cancel();
    if(scrollController.position.userScrollDirection == ScrollDirection.reverse){
      _newsCurrentPos++;
      _newsCurrentPos==3?_newsCurrentPos=2:null;
      newsAnimate(Get.width*0.8, _newsCurrentPos,d);
    }else if(scrollController.position.userScrollDirection == ScrollDirection.forward){
      _newsCurrentPos--;
      _newsCurrentPos==-1?_newsCurrentPos=0:null;
      newsAnimate(Get.width*0.8, _newsCurrentPos,d);
    }
    _startTimer();
    return false;
  }

  void _startTimer(){
    const duration = Duration(seconds: 5);
    _timer = Timer.periodic(duration, (timer) {
      _newsCurrentPos++;
      if(_newsCurrentPos>2 ){
        _newsCurrentPos=0;
        scrollController.jumpTo(0);
      }
      newsAnimate(Get.width*0.8, _newsCurrentPos,const Duration(seconds: 2,milliseconds: 500));
    });
  }
  void newsAnimate(double width,int i,Duration duration){

    scrollController.animateTo(width*i, duration: duration , curve:Curves.easeInOutQuart);
    tabController.animateTo(i,duration:duration );
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}

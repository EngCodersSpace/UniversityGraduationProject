import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/helper_models/result.dart';
import '../../models/lecture_model/lecture_model.dart';
import '../../repositories/lecture_repository.dart';
import '../../utils/snake_bar.dart';

class DashbordLectureTableController extends GetxController {
  Lecture? lecture;
  RxString fieldMessage = "".obs;

  @override
  void onInit() async {
    await fetchDashboardData();
    super.onInit();
  }

  void refesh() async {
    await fetchDashboardData();
  }

  Future fetchDashboardData() async {
    Result res =
        await LectureRepository.fetchDashboardLecture(hardFetch: false);
    if (res.statusCode == 200) {
      lecture = res.data;
    } else if (res.statusCode == 404) {
      lecture = null;
      fieldMessage.value = "this section and level not has Lectures";
      showSnakeBar(
          title: "Not Found Lectures",
          message: "this section and level doesn't has Lectures ");
    } else {
      lecture = null;
      fieldMessage.value = "fetching lectures failed please check connection";
      showSnakeBar(
          title: "Fetch Lectures Failed",
          message: "fetching lectures failed please check connection ");
    }
  }

  @override
  void onClose() {}
}

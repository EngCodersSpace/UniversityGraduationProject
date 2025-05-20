import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/controllers/news_controller.dart';

class NewsViewBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(()=>NewsController());
  }


}
import 'package:get/get.dart';

import '../utils/local_lisenter.dart';
import 'main_controller.dart';


class SettingController extends GetxController {

  get language => LocaleListener.currentLocal.value?.languageCode??"en";

  void changeLang(String lang) {
    LocaleListener.updateLocale(lang);
  }
}

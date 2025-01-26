import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/utils/local_lisenter.dart';
import 'package:ibb_university_students_services/app/models/user_model/user.dart';
import 'package:ibb_university_students_services/app/repositories/user_repository.dart';
import '../../models/helper_models/result.dart';
import '../main_controller.dart';

class ProfileController extends GetxController {
  late User user;
  RxString language = (Get.locale?.languageCode ?? "en").obs;
  RxBool initState = false.obs;

  @override
  void onInit() async {
    Result res = await UserRepository.fetchUser();
    if (res.statusCode == 200) {
      user = res.data;
    }
    initState.value = true;
    super.onInit();
  }

  void changeLang(String lang) {
    LocaleListener.updateLocale(lang);
    language.value = lang;
    Get.find<MainController>().changeTabIndex(4);
  }

  void logout() async {
    await UserRepository.userLogout();
  }

  @override
  void onClose() {}
}

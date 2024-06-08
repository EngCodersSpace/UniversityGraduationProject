import 'package:get/get.dart';

import '../../globals.dart';
import '../../models/user_model.dart';

class ProfileController extends GetxController {

  User user = User();
  @override
  void onInit() {
    // TODO: implement onInit
    user = AppData.user;
    super.onInit();
  }


  @override
  void onClose() {}
}

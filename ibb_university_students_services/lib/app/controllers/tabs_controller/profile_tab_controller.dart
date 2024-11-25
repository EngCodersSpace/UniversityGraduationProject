import 'package:get/get.dart';
import '../../models/structuers/user_structure.dart';
import '../../models/user_model.dart';

class ProfileController extends GetxController {

  User user = UserModel.fetchUser();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  @override
  void onClose() {}
}

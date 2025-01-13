import 'package:get/get.dart';
import '../models/result.dart';
import '../models/user_model/user.dart';
import '../services/user_services.dart';

class AcademicCardController extends GetxController {
  RxBool loadingState = true.obs;
  Rx<User>? user;
  @override
  void onInit() async {
    // TODO: implement onInit
    Result res = await UserServices.fetchUser();
    if (res.statusCode == 200) {
      user = Rx(res.data);
    }
    loadingState.value = false;
    super.onInit();
  }

  @override
  void refresh() {
    super.refresh();
  }

  @override
  void onClose() {}
}

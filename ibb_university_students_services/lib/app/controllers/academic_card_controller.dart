import 'package:get/get.dart';
import '../models/helper_models/result.dart';
import '../models/user_model/user.dart';
import '../repositories/user_repository.dart';

class AcademicCardController extends GetxController {
  RxBool loadingState = true.obs;
  Rx<User>? user;
  @override
  void onInit() async {
    Result res = await UserRepository.fetchUser();
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

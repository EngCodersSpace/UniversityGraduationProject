import 'package:get/get.dart';
import '../models/result.dart';
import '../models/user_model.dart';
import '../services/user_services.dart';

class PaymentsController extends GetxController {
  RxBool loadingState = true.obs;
  Rx<User>? user;

  @override
  void onInit() async {
    super.onInit();
    Result res = await UserServices.fetchUser();
    if (res.statusCode == 200) {
      user = Rx(res.data);
    }
    loadingState.value = false;
  }

  @override
  void refresh() {
    super.refresh();
  }

  @override
  void onClose() {}
}

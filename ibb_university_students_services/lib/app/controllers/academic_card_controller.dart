import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:ibb_university_students_services/app/repositories/student_fee_repository.dart';
import '../models/helper_models/result.dart';
import '../models/user_model/user.dart';
import '../repositories/user_repository.dart';

class AcademicCardController extends GetxController {
  RxBool loadingState = true.obs;
  Rx<User>? user;
  Rx<StudentFee>? lastFee;
  @override
  void onInit() async {
    Result res = await UserRepository.fetchUser();
    if (res.statusCode == 200) {
      user = Rx(res.data);
      if (user?.value.id == null) return;
      Result res2 = await StudentFeeRepository.fetchLastStudentFee(
          studentId: user!.value.id);
      if (res2.statusCode == 200) {
        lastFee = Rx(res2.data);
      }
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

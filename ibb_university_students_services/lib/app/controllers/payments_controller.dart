import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../services/user_services.dart';
import '../views/exam_table_view/exam_table_view_components/add_and_update_exam_card.dart';

class PaymentsController extends GetxController {
  RxBool loadingState = true.obs;
  TextEditingController id = TextEditingController();
  String mode = "add";

  @override
  void onInit() async {
    super.onInit();
    // TODO: implement onInit
    if(UserServices.userRule == "student"){

      // Result res = await UserServices.fetchUser();
      // if (res.statusCode == 200) {
      //   user = Rx(res.data);
      // }
    }
    loadingState.value = false;
  }

  @override
  void refresh() {
    super.refresh();
  }

  void findButtonClick(){

  }

  void more(String val, {Map<String, dynamic>? data}) async {
    if (val == "Edit") {
      mode = "Edit";
      if (data != null) {
        // selectedExam = data["exam_id"];
        // subjects = {};
        // subjects =
        // await SubjectServices.fetchSubjects().then((e) => e.data ?? {});
        // subject = RxString(data["subject"]["subject_id"]);
        // dateController.text = data["exam_date"].toString();
        // timeController.text =
        //     DateTimeUtils.formatStringTime(time: data["exam_time"]);
        // day.value = data["exam_day"].toString();
        // hallController.text = data["exam_room"].toString();
      }
      Get.dialog(const PopUpIAddAndUpdateExamCard());
    } else if (val == "Delete") {
    }
  }

  void addButtonClick() async {
    mode = "Add";
  }

  @override
  void onClose() {}
}

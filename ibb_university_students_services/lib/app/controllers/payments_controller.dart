import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/services/level_services.dart';
import 'package:ibb_university_students_services/app/views/payments_view/payments_view_components/add_and_update_payment_card.dart';
import '../services/user_services.dart';
import '../utils/date_time_utils.dart';
import '../views/exam_table_view/exam_table_view_components/add_and_update_exam_card.dart';

class PaymentsController extends GetxController {
  RxBool loadingState = true.obs;

  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController payedAmountController = TextEditingController();
  TextEditingController receiptNumberController = TextEditingController();
  RxString day = "Saturday".obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode receiptNumberFocus = FocusNode();
  FocusNode totalAmountFocus = FocusNode();
  FocusNode payedAmountFocus = FocusNode();

  RxString selectedTerm = "Term 1".obs;
  List<Level>? levels;
  late RxInt level;
  String mode = "Add";
  int? selectedExam;

  @override
  void onInit() async {
    if(UserServices.userRule == "student"){

      // Result res = await UserServices.fetchUser();
      // if (res.statusCode == 200) {
      //   user = Rx(res.data);
      // }
    }
    levels = [];
    levels = await LevelServices.fetchLevels().then((e) => e.data);
    if (levels?.first != null) {
      level = RxInt(levels!.first.id);
    }
    super.onInit();
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
      print(data);
      if (data != null) {
        // selectedExam = data["exam_id"];
        // level = RxInt(0);
        // dateController.text = data["exam_date"].toString();
      }
      Get.dialog(const PopUpIAddAndUpdatePaymentCard());
    } else if (val == "Delete") {
    }
  }

  Future<void> addButtonClick() async {
    // doctorId.value = 1000;
    mode = "Add";
    dateController.text = DateTime.now().toString().split(" ")[0];
    await Get.dialog(const PopUpIAddAndUpdatePaymentCard());
  }

  void submit() async {
    // Map<String, dynamic> jsData = {};
    // if (formKey.currentState!.validate()) {
    //   jsData["exam_section_id"] = selectedSection.value;
    //   jsData["exam_level_id"] = selectedLevel.value;
    //   (subject.value.isNotEmpty && subject.value != "Unknown".tr)
    //       ? jsData["subject_id"] = subject.value
    //       : null;
    //   (dateController.text.isNotEmpty && dateController.text != "Unknown".tr)
    //       ? jsData["exam_date"] = dateController.text
    //       : null;
    //   (timeController.text.isNotEmpty && timeController.text != "Unknown".tr)
    //       ? jsData["exam_time"] = DateFormat('HH:mm:ss')
    //       .format(DateFormat('hh:mm a').parse(timeController.text))
    //       : null;
    //   (day.value.isNotEmpty && day.value != "Unknown".tr)
    //       ? jsData["exam_day"] = day.value
    //       : null;
    //   (hallController.text.isNotEmpty && hallController.text != "Unknown".tr)
    //       ? jsData["exam_room"] = hallController.text
    //       : null;
    // }
    //
    // if (mode == "Add") {
    //   Result<Exam> res = await ExamServices.createExam(
    //       sectionId: selectedSection.value!,
    //       levelId: selectedLevel.value!,
    //       data: jsData);
    //   Navigator.of(Get.overlayContext!).pop();
    //   if (res.statusCode == 201 && res.data != null) {
    //     exams?.value[res.data!.id] = res.data!;
    //     exams?.refresh();
    //     showSnakeBar(message: "Add successfully");
    //   } else {
    //     showSnakeBar(message: "Add failed");
    //   }
    // } else if (mode == "Edit") {
    //   Result<Exam> res = await ExamServices.updateExam(
    //       sectionId: selectedSection.value!,
    //       levelId: selectedLevel.value!,
    //       data: jsData,
    //       id: selectedExam);
    //   Navigator.of(Get.overlayContext!).pop();
    //   if (res.statusCode == 200 && res.data != null) {
    //     exams?.value[res.data!.id] = res.data!;
    //     exams?.refresh();
    //     showSnakeBar(message: "Edit successfully");
    //   } else {
    //     showSnakeBar(message: "Edit failed");
    //   }
    // }
  }

  void popCardClear() {

  }

  @override
  void onClose() {
    dateController.dispose();
    receiptNumberController.dispose();
    totalAmountController.dispose();
    payedAmountController.dispose();
    receiptNumberFocus.dispose();
    totalAmountFocus.dispose();
    payedAmountFocus.dispose();
  }
}

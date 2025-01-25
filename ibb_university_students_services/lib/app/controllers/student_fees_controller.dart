import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/level_model/level.dart';
import 'package:ibb_university_students_services/app/models/student_fee/student_fee.dart';
import 'package:ibb_university_students_services/app/repositories/student_fee_repository.dart';
import 'package:ibb_university_students_services/app/utils/dobule_digits_parse.dart';
import '../models/helper_models/result.dart';
import '../repositories/level_repository.dart';
import '../repositories/user_repository.dart';
import '../utils/snake_bar.dart';
import '../views/student_fees_view/student_fees_view_components/add_and_update_student_fees_card.dart';

class StudentFeeController extends GetxController {
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
  RxString fieldMessage = "".obs;
  RxString selectedTerm = "Term 1".obs;
  List<Level>? levels;
  late RxInt level;
  String mode = "Add";
  int? selectedFee;
  RxMap<int, StudentFee> studentFees = RxMap({});
  int? studentId;

  @override
  void onInit() async {
    await StudentFeeRepository.openBox();
    if (UserRepository.userRule == "student") {
      studentId = await UserRepository.fetchUser().then((e) => e.data?.id);
      await fetchStudentFees();
    }
    await fetchLevels();
    super.onInit();
    loadingState.value = false;
  }

  @override
  void refresh() async {
    await fetchStudentFees();
    super.refresh();
  }

  Future<void> fetchLevels() async {
    levels = [];
    levels = await LevelRepository.fetchLevels().then((e) => e.data);
    if (levels?.first != null) {
      level = RxInt(levels!.first.id);
    }
  }

  Future<void> fetchStudentFees() async {
    if (studentId == null) {
      fieldMessage.value = "enter student id first ";
      showSnakeBar(
          title: "Not Found Fees", message: "this student not has fees");
      return;
    }
    Result res =
        await StudentFeeRepository.fetchStudentFees(studentId: studentId!);
    if (res.statusCode == 200) {
      studentFees.value = res.data;
    } else if (res.statusCode == 404) {
      studentFees.value = {};
      fieldMessage.value = "this student not has fees";
      showSnakeBar(
          title: "Not Found Fees", message: "this student not has fees");
    } else {
      studentFees.value = {};
      fieldMessage.value = "fetching fees failed please check connection";
      showSnakeBar(
          title: "Fetch Fees Failed",
          message: "fetching fees failed please check connection ");
    }
  }

  void findButtonClick() {
    studentId = int.tryParse(idController.text);
    fetchStudentFees();
  }

  void more(String val, {Map<String, dynamic>? data}) async {
    selectedFee = data?["id"];
    if (val == "Edit") {
      mode = "Edit";
      if (data != null) {
        selectedTerm.value = data["term"];
        receiptNumberController.text = data["receipt_number"];
        totalAmountController.text =
            DoubleDigitParse.twoDigit(data["total_amount"]) ?? "";
        payedAmountController.text =
            DoubleDigitParse.twoDigit(data["amount_paid"]) ?? "";
        level.value = data["level_fees_id"];
        dateController.text = data["payment_date"].toString();
      }
      Get.dialog(const PopUpIAddAndUpdateStudentFeeCard());
    } else if (val == "Delete") {
      if (studentId == null) return;
      Result<void> res = await StudentFeeRepository.deleteStudentFee(
          studentId: studentId!, id: selectedFee);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200) {
        studentFees.remove(selectedFee);
        showSnakeBar(message: "Delete successfully");
      } else {
        showSnakeBar(message: "Delete failed");
      }
    }
  }

  Future<void> addButtonClick() async {
    // doctorId.value = 1000;
    mode = "Add";
    dateController.text = DateTime.now().toString().split(" ")[0];
    await Get.dialog(const PopUpIAddAndUpdateStudentFeeCard());
  }

  void submit() async {
    Map<String, dynamic> jsData = {};
    if (studentId == null) return;
    print(selectedFee);
    jsData["id"] = selectedFee;
    jsData["student_id"] = studentId;
    jsData["term"] = selectedTerm.value;
    jsData["level_fees_id"] = level.value;
    jsData["remaining_amount"] = 0;
    if (formKey.currentState!.validate()) {
      (dateController.text.isNotEmpty && dateController.text != "Unknown".tr)
          ? jsData["payment_date"] = dateController.text
          : null;
      (receiptNumberController.text.isNotEmpty &&
              receiptNumberController.text != "Unknown".tr)
          ? jsData["receipt_number"] = receiptNumberController.text
          : null;
      (totalAmountController.text.isNotEmpty &&
              totalAmountController.text != "Unknown".tr)
          ? jsData["total_amount"] = totalAmountController.text
          : null;
      (payedAmountController.text.isNotEmpty &&
              payedAmountController.text != "Unknown".tr)
          ? jsData["amount_paid"] = payedAmountController.text
          : null;
    }

    if (mode == "Add") {
      Result<StudentFee> res = await StudentFeeRepository.createStudentFee(
          studentId: studentId!, data: jsData);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 201 && res.data != null) {
        studentFees[res.data!.id] = res.data!;
        studentFees.refresh();
        showSnakeBar(message: "Add successfully");
      } else {
        showSnakeBar(message: "Add failed");
      }
    } else if (mode == "Edit") {
      Result<StudentFee> res = await StudentFeeRepository.updateStudentFee(
          studentId: studentId!, data: jsData, id: selectedFee);
      print(res.statusCode);
      Navigator.of(Get.overlayContext!).pop();
      if (res.statusCode == 200 && res.data != null) {
        studentFees[res.data!.id] = res.data!;
        studentFees.refresh();
        showSnakeBar(message: "Edit successfully");
      } else {
        showSnakeBar(message: "Edit failed");
      }
    }
  }

  void popCardClear() {}

  @override
  void onClose() {
    StudentFeeRepository.closeBox();
    dateController.dispose();
    receiptNumberController.dispose();
    totalAmountController.dispose();
    payedAmountController.dispose();
    receiptNumberFocus.dispose();
    totalAmountFocus.dispose();
    payedAmountFocus.dispose();
  }
}

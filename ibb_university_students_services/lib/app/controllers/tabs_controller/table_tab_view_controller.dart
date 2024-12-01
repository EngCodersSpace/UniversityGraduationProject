import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/globals.dart';
import 'package:ibb_university_students_services/app/models/lecture_model.dart';
import 'package:ibb_university_students_services/app/services/table_time_services.dart';
import '../../components/custom_text.dart';
import '../../models/days_table.dart';
import '../../models/result.dart';


class TableTabController extends GetxController {
  late Rx<TableDays?> tableTime;
  List<Lecture>? selectedDay;
  RxInt selected = 0.obs;
  String selectedDayName = "Sunday".tr;
  RxString selectedTerm = "Term 1".obs;
  RxString selectedDepartment = "Computer".obs;
  RxString selectedLevel = "Level 5".obs;
  Map termsData = {};


  List<DropdownMenuItem<String>> departments = [
    DropdownMenuItem<String>(value: "Computer", child: SecText("Computer",textColor: AppColors.mainTextColor,)),
  ];
  List<DropdownMenuItem<String>> levels = [
    DropdownMenuItem<String>(value: "Level 5", child: SecText("Level 5",textColor: AppColors.mainTextColor,),),
  ];
  List<DropdownMenuItem<String>> terms = [
    DropdownMenuItem<String>(value: "Term 1", child: SecText("Term 1",textColor: AppColors.mainTextColor)),
    DropdownMenuItem<String>(value: "Term 2", child: SecText("Term 2",textColor: AppColors.mainTextColor)),
  ];
  @override
  void onInit() async{
    // TODO: implement onInit
    Result res = await TableTimeServices.fetchTableTime(sectionId: 5,levelId: 5,year: "2024",);
    if(res.statusCode == 200){
      print(res.data[selectedTerm.value]);
      termsData = res.data;
      tableTime = Rx(res.data[selectedTerm.value]);
    }
    selectedDayChange(0);
    print(tableTime?.value);
    super.onInit();
  }

  void changeDepartment(String? val) {
    if(val == null)return;
    selectedDepartment.value = val;
  }
  void changeLevel(String? val) {
    if(val == null)return;
    selectedLevel.value = val;
  }
  void changeTerm(String? val) {
    if(val == null)return;
    selectedTerm.value = val;
    tableTime.value = termsData[selectedTerm.value];
    selectedDayChange(selected.value);
    selected.refresh();
  }
  void selectedDayChange(int index){
    selected.value = index;
    switch(index){
      case 0:
        selectedDay = tableTime.value?.sat;
        selectedDayName = "Saturday".tr;
        break;
      case 1:
        selectedDayName = "Sunday".tr;
        selectedDay = tableTime.value?.sun;
        break;
      case 2:
        selectedDay = tableTime.value?.mon;
        selectedDayName = "Monday".tr;
        break;
      case 3:
        selectedDay = tableTime.value?.tue;
        selectedDayName = "Tuesday".tr;
        break;
      case 4:
        selectedDay = tableTime.value?.wed;
        selectedDayName = "Wednesday".tr;
        break;
      case 5:
        selectedDay = tableTime.value?.thu;
        selectedDayName = "Thursday".tr;
        break;

    }
  }
  @override
  void onClose() {}
}

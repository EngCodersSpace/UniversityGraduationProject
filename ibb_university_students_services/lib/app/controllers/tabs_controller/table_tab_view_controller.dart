import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/table_time_model.dart';
import 'package:ibb_university_students_services/app/services/table_time_services.dart';

import '../../models/result.dart';


class TableTabController extends GetxController {
  TableTime? tableTime;
  List<TableDayContent>? selectedDay;
  RxInt selected = 0.obs;
  String selectedDayName = "Sunday";

  @override
  void onInit() async{
    // TODO: implement onInit
    Result res = await TableTimeServices.fetchTableTime();
    if(res.statusCode == 200){
      tableTime = res.data;
    }
    selectedDay = tableTime?.sun;
    super.onInit();
  }
  void selectedDayChange(int index){
    selected.value = index;
    switch(index){
      case 0:
        selectedDay = tableTime?.sun;
        selectedDayName = "Sunday";
        break;
      case 1:
        selectedDay = tableTime?.mon;
        selectedDayName = "Monday";
        break;
      case 2:
        selectedDay = tableTime?.tue;
        selectedDayName = "Tuesday";
        break;
      case 3:
        selectedDay = tableTime?.wed;
        selectedDayName = "Wednesday";
        break;
      case 4:
        selectedDay = tableTime?.the;
        selectedDayName = "Thursday";
        break;
      case 5:
        selectedDay = tableTime?.sat;
        selectedDayName = "Saturday";
        break;
    }
  }
  @override
  void onClose() {}
}

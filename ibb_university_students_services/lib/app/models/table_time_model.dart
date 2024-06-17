import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/structuers/table_time_structure.dart';

class TableTimeModel {
  static TableTime? _tableTime;

  static TableTime? fetchTable() {
    if (_tableTime != null) {
      return _tableTime;
    }
    Map<String, dynamic> response = {
      'id': 2070093,
      'sun': [
        {
          "title": "AI",
          "time":
              "From ${DateTime(2023, 5, 5, 8)} to ${DateTime(2023, 5, 5, 10)}",
          "hall": "h1",
          "description": null
        },
        {
          "title": "Math",
          "time":
              "From ${DateTime(2023, 5, 5, 10)} to ${DateTime(2023, 5, 5, 12)}",
          "hall": "h1",
          "description": null
        }
      ],
      'mon': [
        {
          "title": "English",
          "time":
              "From ${DateTime(2023, 5, 5, 8, 30)} to ${DateTime(2023, 5, 5, 10, 30)}",
          "hall": "h1",
          "description": null
        }
      ],
      'tue': [],
      'wed': [],
      'the': [],
      'sat': [],
    };

    return null;
  }

  static TableTime? fillTableTime(Map<String, dynamic> response) {
    for(int i=1;i<7;i++){
      for(var item in response[i]){
       print(item);
      }
      List sun = [];
    }
    // TableTime tableTime = TableTime(
    //   id: response["id"],
    //   sun: TableDayContent(
    //       title: RxString(response["sun"]["title"]),
    //       time: RxString(response["sun"]["time"]),
    //       hall: RxString(response["sun"]["hall"]),
    //       description: RxString(response["sun"]["description"])),
    //   mon: TableDayContent(
    //       title: RxString(response["mon"]["title"]),
    //       time: RxString(response["mon"]["time"]),
    //       hall: RxString(response["mon"]["hall"]),
    //       description: RxString(response["mon"]["description"])),
    //   tue: TableDayContent(
    //       title: RxString(response["tue"]["title"]),
    //       time: RxString(response["tue"]["time"]),
    //       hall: RxString(response["tue"]["hall"]),
    //       description: RxString(response["tue"]["description"])),
    //   wed: TableDayContent(
    //       title: RxString(response["wed"]["title"]),
    //       time: RxString(response["wed"]["time"]),
    //       hall: RxString(response["wed"]["hall"]),
    //       description: RxString(response["wed"]["description"])),
    //   the: TableDayContent(
    //       title: RxString(response["the"]["title"]),
    //       time: RxString(response["the"]["time"]),
    //       hall: RxString(response["the"]["hall"]),
    //       description: RxString(response["the"]["description"])),
    //   sat: TableDayContent(
    //       title: RxString(response["sat"]["title"]),
    //       time: RxString(response["sat"]["time"]),
    //       hall: RxString(response["sat"]["hall"]),
    //       description: RxString(response["sat"]["description"])),
    // );
    return null;
  }
}

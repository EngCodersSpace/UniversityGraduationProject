import 'package:get/get.dart';
import 'package:ibb_university_students_services/app/models/structuers/table_time_structure.dart';

class TableTimeModel {
  static TableTime? _tableTime;

  static TableTime? fetchTable() {
    if (_tableTime != null) {
      return _tableTime;
    }
    Map<String, dynamic> response = {
      'sun': [
        {
          "title": "AI",
          "time":
              "From 8:00 to 10:00",
          "hall": "h1",
          "description": null
        },
        {
          "title": "Math",
          "time":
              "From 10:00 to 12:00",
          "hall": "h1",
          "description": null
        }
      ],
      'mon': [
        {
          "title": "English",
          "time":
          "From 8:30 to 10:30",
          "hall": "h1",
          "description": null
        }
      ],
      'tue': [],
      'wed': [],
      'the': [],
      'sat': [],
    };
    _tableTime = fillTableTime(response);
    return _tableTime;
  }

  static TableTime? fillTableTime(Map<String, dynamic> response) {
    Map<String, List<TableDayContent>?> days = {};
    for (String key in response.keys) {
      days.addAll({key: []});
      if (response[key] != null) {
        for (var item in response[key]) {
          days[key]?.add(TableDayContent(
              title: RxString(item["title"]),
              time: RxString(item["time"]),
              hall: RxString(item["hall"]),
              description: RxString(item["description"] ?? "")));
        }
      }
    }
    TableTime tableTime = TableTime(
      sun: days["sun"],
      mon: days["mon"],
      tue: days["tue"],
      wed: days["wed"],
      the: days["the"],
      sat: days["sat"],
    );

    return tableTime;
  }
}

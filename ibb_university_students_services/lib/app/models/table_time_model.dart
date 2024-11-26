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
          "startTime": "8:00",
          "endTime": "10:00",
          "doctor": "Farhan",
          "hall": "h1",
          "description": null
        },
        {
          "title": "Math",
          "startTime": "10:00",
          "endTime": "12:00",
          "doctor": "Hameed",
          "hall": "h1",
          "description": null,
          "canceled": true,
        }
      ],
      'mon': [
        {
          "title": "English",
          "startTime": "8:30",
          "endTime": "10:30",
          "doctor": "Ahmed",
          "hall": "h1",
          "description": null
        }
      ],
      'tue': [
        {
          "title": "AI",
          "startTime": "8:00",
          "endTime": "10:00",
          "doctor": "Farhan",
          "hall": "h1",
          "description": null
        },
        {
          "title": "Math",
          "startTime": "10:00",
          "endTime": "12:00",
          "doctor": "Hameed",
          "hall": "h1",
          "description": null,
          "canceled": true,
        },
        {
          "title": "Math",
          "startTime": "12:00",
          "endTime": "02:00",
          "doctor": "Hameed",
          "hall": "h1",
          "description": null,
          "canceled": true,
        }
      ],
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
              title: RxString(item["title"] ?? ""),
              startTime: RxString(item["startTime"] ?? ""),
              endTime: RxString(item["endTime"] ?? ""),
              doctor: RxString(item["doctor"]??""),
              hall: RxString(item["hall"] ?? ""),
              description: RxString(item["description"] ?? ""),
              canceled: RxBool(item["canceled"]??false)));
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

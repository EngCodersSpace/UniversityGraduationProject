import 'package:ibb_university_students_services/app/models/lecture_model.dart';

class TableDays {
  TableDays({
    this.sun,
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.sat,
  });

  Map<int,Lecture>? sun;
  Map<int,Lecture>? mon;
  Map<int,Lecture>? tue;
  Map<int,Lecture>? wed;
  Map<int,Lecture>? thu;
  Map<int,Lecture>? sat;

  factory TableDays.fromJson(Map<String, Map<int,Lecture>> json) {
    Map<String, Map<int,Lecture>> days = {};
    for (String day in json.keys) {
      days[day] = {};
      for (Lecture lecture in (json[day]?.values.toList()??[])) {
        days[day]?[lecture.id] = lecture;
      }
    }
    return TableDays(
      sun: days["Sunday"],
      mon: days["Monday"],
      tue: days["Tuesday"],
      wed: days["Wednesday"],
      thu: days["Thursday"],
      sat: days["Saturday"],
    );
  }

}

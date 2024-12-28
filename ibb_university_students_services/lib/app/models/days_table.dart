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

  List<Lecture>? sun;
  List<Lecture>? mon;
  List<Lecture>? tue;
  List<Lecture>? wed;
  List<Lecture>? thu;
  List<Lecture>? sat;

  factory TableDays.fromJson(Map<String, Map<int,Lecture>> json) {
    Map<String, List<Lecture>> days = {};
    for (String day in json.keys) {
      days[day] = [];
      for (Lecture lecture in (json[day]?.values.toList()??[])) {
        days[day]?.add(lecture);
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

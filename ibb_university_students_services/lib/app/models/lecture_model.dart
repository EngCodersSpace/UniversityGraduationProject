
class Lecture{
  Lecture({
    required this.id,
    this.title,
    this.startTime,
    this.duration,
    this.doctor,
    this.hall ,
    this.description,
    this.canceled ,
  });
  int id;
  String? title;
  String? startTime;
  String? duration;
  String? doctor;
  String? hall;
  String? description;
  bool? canceled = false;


  factory Lecture.fromJson(Map<String, dynamic> json) {
    // "id": 5,
    // "startTime": "12:40:00",
    // "duration": "1 hours",
    // "lecturer": "William Rowe",
    // "lecture_room": "99Ji2"
    return Lecture(
      id: json['id'],
      startTime: json['startTime'],
      duration: json['duration'],
      doctor: json['lecturer'],
      hall: json['lecture_room']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "startTime": startTime,
      "duration": duration,
      "lecturer": doctor,
      "lecture_room": hall,
    };
  }

}

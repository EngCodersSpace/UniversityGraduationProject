class Exam {
  Exam({
    required this.id,
    this.subjectName,
    this.date,
    this.day,
    this.examTime,
    this.hall,
  });


  int id;
  String? subjectName;
  String? date;
  String? day;
  String? examTime;
  String? hall;


  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
        id: json['id'],
        subjectName: json['subject_name'],
        date: json['exam_date'],
        day: json['exam_day'],
        examTime: json['exam_time'],
        hall: json['exam_room']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject_name":subjectName,
      "exam_date": date,
      "exam_day": day,
      "exam_time": examTime,
      "exam_room": hall,
    };
  }

}

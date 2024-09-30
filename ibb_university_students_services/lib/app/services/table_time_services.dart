import '../models/result.dart';
import '../models/student_model.dart';


class TableTimeServices {

  static Future<Result<Student>> fetchTableTime({bool hardFetch = false}) async {

    // virtual response for test
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
    return Result(hasError: true, message: "error");
  }

  static void write() {}
}

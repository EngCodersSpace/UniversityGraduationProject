import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/notification_model.dart';
import '../models/doctor_model.dart';
import '../models/result.dart';
import '../models/student_model.dart';
import '../models/user_model.dart';
import 'api/api_end_points.dart';
import 'api/http_provider.dart';

class NotificationServices {
  // static List<Notifications> _notifications;
  static List _notifications = [];



  static Future<Result> fetchNotifications({bool hardFetch = false}) async {
    if (_notifications.isNotEmpty && !hardFetch) {
      return Result(data: _notifications,statusCode: 200 ,hasError: false, message: "successful");
    }

    late Response response;
    try {
      response = await HttpProvider.post(EndPoints.getUserData);
      response.data = {
        "notifications": [
          {
            "id": 1,
            "date": "2024-10-02",
            "time": "09:00 AM",
            "message": "Reminder: Don't forget to submit your assignment for the Psychology 101 class by Friday!",
            "author": "Academic Affairs Office"
          },
          {
            "id": 2,
            "date": "2024-10-03",
            "time": "07:30 AM",
            "message": "Campus Alert: Due to inclement weather, all classes for tomorrow are canceled. Stay safe!",
            "author": "Campus Safety Office"
          },
          {
            "id": 3,
            "date": "2024-10-04",
            "time": "10:00 AM",
            "message": "Library Notice: The library will have extended hours this weekend for midterm exams. Check the schedule for details.",
            "author": "Library Services Department"
          },
          {
            "id": 4,
            "date": "2024-10-05",
            "time": "02:00 PM",
            "message": "Career Fair Update: Over 50 companies confirmed for the upcoming career fair. Prepare your resumes!",
            "author": "Career Services Center"
          },
          {
            "id": 5,
            "date": "2024-10-06",
            "time": "12:00 PM",
            "message": "Important Update: The deadline for course registration has been extended to next week. Don't miss out on your preferred courses!",
            "author": "Registrar's Office"
          },
          {
            "id": 6,
            "date": "2024-10-07",
            "time": "04:30 PM",
            "message": "Health and Wellness: Join us for a yoga session on the lawn this Friday at 5 PM. Take a break and de-stress!",
            "author": "Student Wellness Center"
          },
          {
            "id": 7,
            "date": "2024-10-08",
            "time": "11:30 AM",
            "message": "Research Opportunity: A faculty member is seeking research assistants for a groundbreaking project. Apply now!",
            "author": "Research Department"
          },
          {
            "id": 8,
            "date": "2024-10-09",
            "time": "08:45 AM",
            "message": "Student Council Elections: Nominate yourself or a peer for a position on the student council. Be a voice for change!",
            "author": "Student Government Association"
          },
          {
            "id": 9,
            "date": "2024-10-10",
            "time": "06:00 PM",
            "message": "Sports Event: Cheer on our university team at the upcoming basketball game this Saturday. Go Tigers!",
            "author": "Athletics Department"
          },
          {
            "id": 10,
            "date": "2024-10-11",
            "time": "03:15 PM",
            "message": "Scholarship Opportunity: Applications for the annual academic scholarships are now open. Don't miss the chance to apply for financial aid.",
            "author": "Financial Aid Office"
          }
        ]
      };
      List notifications = response.data["notifications"]; 
      for( int i=0; i<notifications.length;i++){
        _notifications.add(Notification.fromJson(notifications[i]));
      }
      return Result(data: _notifications,statusCode: 200);

    } on DioException catch (error) {
      if (error.response != null) {
        return Result(
            hasError: true,
            statusCode: error.response?.statusCode,
            data: error.response?.data);
      }
      return Result(hasError: true, message: error.message);
    }
  }

  static void write() {}
}

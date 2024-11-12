import 'package:dio/dio.dart';
import 'package:ibb_university_students_services/app/models/notification_model.dart';
import '../models/result.dart';
import 'http_provider/http_provider.dart';

class NotificationServices {
  // static List<Notifications> _notifications;
  static final List<Notification> _notifications = [];

  static _fakeFetch() {
    Map<String, dynamic> data = {
      "notifications": [
        {
          "id": 2,
          "date": "2024-10-03",
          "time": "07:30 AM",
          "message":
              "Campus Alert: Due to inclement weather, all classes for tomorrow are canceled. Stay safe!",
          "author": "Campus Safety Office"
        },
        {
          "id": 3,
          "date": "2024-10-03",
          "time": "10:00 AM",
          "message":
              "Important Announcement: The university will be hosting a guest speaker event on campus. Don't miss this opportunity!",
          "author": "Events Committee"
        },
        {
          "id": 1,
          "date": "2024-10-02",
          "time": "09:00 AM",
          "message":
              "Reminder: Don't forget to submit your assignment for the Psychology 101 class by Friday!",
          "author": "Academic Affairs Office"
        },
        {
          "id": 10,
          "date": "2024-10-01",
          "time": "12:00 PM",
          "message":
              "Club Fair: Explore various student clubs and organizations at the club fair in the quad tomorrow.",
          "author": "Student Involvement Office"
        },
        {
          "id": 18,
          "date": "2024-10-01",
          "time": "03:00 PM",
          "message":
              "Study Abroad Info Session: Learn about exciting study abroad opportunities at the info session in the student union.",
          "author": "International Programs Office"
        },
        {
          "id": 19,
          "date": "2024-10-01",
          "time": "06:30 PM",
          "message":
              "Dance Performance: Watch a captivating dance performance by the university dance troupe at the theater.",
          "author": "Dance Department"
        },
        {
          "id": 20,
          "date": "2024-10-01",
          "time": "09:00 PM",
          "message":
              "Comedy Night: Laugh out loud at the comedy night event hosted by the comedy club in the student center.",
          "author": "Comedy Club"
        },
        {
          "id": 11,
          "date": "2024-09-05",
          "time": "04:30 PM",
          "message":
              "Health and Fitness: Join the fitness club for a group workout session in the gym.",
          "author": "Fitness Club"
        },
        {
          "id": 21,
          "date": "2024-09-05",
          "time": "12:00 PM",
          "message":
              "Tech Talk: Attend a tech talk by industry experts at the engineering building.",
          "author": "Engineering Department"
        },
        {
          "id": 22,
          "date": "2024-09-05",
          "time": "02:30 PM",
          "message":
              "Environmental Awareness Workshop: Learn about sustainability practices at the workshop in the environmental science lab.",
          "author": "Environmental Studies Program"
        },
        {
          "id": 12,
          "date": "2024-09-06",
          "time": "11:30 AM",
          "message":
              "Career Development Workshop: Enhance your resume writing skills at the career center workshop.",
          "author": "Career Services Center"
        },
        {
          "id": 23,
          "date": "2024-09-06",
          "time": "03:00 PM",
          "message":
              "Panel Discussion: Join a panel discussion on current social issues at the student union.",
          "author": "Social Sciences Department"
        },
        {
          "id": 24,
          "date": "2024-09-06",
          "time": "06:45 PM",
          "message":
              "Cultural Festival: Experience cultural performances and cuisine at the annual cultural festival in the quad.",
          "author": "Cultural Affairs Office"
        },
        {
          "id": 25,
          "date": "2024-09-06",
          "time": "09:30 PM",
          "message":
              "Outdoor Adventure Club Meeting: Join the outdoor adventure club for a meeting to plan upcoming trips.",
          "author": "Outdoor Adventure Club"
        },
        {
          "id": 13,
          "date": "2024-09-07",
          "time": "08:45 AM",
          "message":
              "Student Council Meeting: Attend the student council meeting in the student union this Friday.",
          "author": "Student Government Association"
        },
        {
          "id": 26,
          "date": "2024-09-07",
          "time": "12:15 PM",
          "message":
              "Volunteer Fair: Explore volunteer opportunities at the fair in the community center.",
          "author": "Community Engagement Office"
        },
        {
          "id": 27,
          "date": "2024-09-07",
          "time": "03:45 PM",
          "message":
              "Film Screening: Watch an award-winning film at the screening hosted by the film studies department.",
          "author": "Film Studies Department"
        },
        {
          "id": 28,
          "date": "2024-09-07",
          "time": "07:00 PM",
          "message":
              "Poetry Night: Share your poetry or enjoy listening to others at the poetry night event in the library.",
          "author": "Library Services Department"
        },
        {
          "id": 14,
          "date": "2024-09-10",
          "time": "06:00 PM",
          "message":
              "Sports Event: Cheer on our university team at the upcoming basketball game this Saturday. Go Tigers!",
          "author": "Athletics Department"
        },
        {
          "id": 29,
          "date": "2024-09-10",
          "time": "12:30 PM",
          "message":
              "Community Service Day: Join fellow students in community service activities around the city.",
          "author": "Community Service Office"
        },
        {
          "id": 30,
          "date": "2024-09-10",
          "time": "04:45 PM",
          "message":
              "Science Fair: Explore innovative science projects at the annual science fair in the science building.",
          "author": "Science Department"
        },
        {
          "id": 31,
          "date": "2024-09-10",
          "time": "08:00 PM",
          "message":
              "Concert Night: Enjoy a live concert featuring local bands at the amphitheater.",
          "author": "Music Department"
        },
        {
          "id": 15,
          "date": "2024-09-11",
          "time": "03:15 PM",
          "message":
              "Scholarship Opportunity: Applications for the annual academic scholarships are now open. Don't miss the chance to apply for financial aid.",
          "author": "Financial Aid Office"
        },
        {
          "id": 4,
          "date": "2024-09-03",
          "time": "02:00 PM",
          "message":
              "Library Workshop: Learn effective research strategies at the library workshop happening this afternoon.",
          "author": "Library Services Department"
        },
        {
          "id": 5,
          "date": "2024-09-03",
          "time": "05:30 PM",
          "message":
              "Student Mixer: Join us for a fun evening of games and snacks at the student center.",
          "author": "Student Activities Board"
        },
        {
          "id": 6,
          "date": "2024-09-03",
          "time": "08:00 PM",
          "message":
              "Movie Night: Enjoy a movie screening under the stars at the university lawn tonight.",
          "author": "Film Club"
        },
        {
          "id": 7,
          "date": "2024-09-03",
          "time": "10:30 PM",
          "message":
              "Stargazing Event: Join the astronomy club for a stargazing session at the observatory.",
          "author": "Astronomy Club"
        },
        {
          "id": 8,
          "date": "2024-09-03",
          "time": "12:30 PM",
          "message":
              "Lunchtime Concert: Enjoy live music and performances at the amphitheater during your lunch break.",
          "author": "Music Department"
        },
        {
          "id": 9,
          "date": "2024-09-03",
          "time": "03:45 PM",
          "message":
              "Art Exhibition Opening: Visit the university art gallery for the opening reception of the latest exhibition.",
          "author": "Art Department"
        },
        {
          "id": 16,
          "date": "2024-09-03",
          "time": "09:00 AM",
          "message":
              "Career Fair: Explore job opportunities at the career fair in the student center.",
          "author": "Career Services Center"
        },
        {
          "id": 17,
          "date": "2024-09-03",
          "time": "01:30 PM",
          "message":
              "Guest Lecture: Attend a special lecture by a renowned guest speaker in the auditorium.",
          "author": "Guest Speaker Series"
        },
      ]
    };
    List<Map<String, dynamic>> notifications = data["notifications"];
    for (int i = 0; i < notifications.length; i++) {
      _notifications.add(Notification.fromJson(notifications[i]));
    }
  }

  static Future<Result<List<Notification>>> fetchNotifications(
      {bool hardFetch = false}) async {
    if (_notifications.isNotEmpty && !hardFetch) {
      return Result(
        data: _notifications,
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }

    late Response? response;
    try {
      // response = await HttpProvider.post("");
      // List notifications = response?.data["notifications"];
      // for (int i = 0; i < notifications.length; i++) {
      //   _notifications.add(Notification.fromJson(notifications[i]));
      // }
      _fakeFetch();

      return Result(
        data: _notifications,
        statusCode: 200,
      );
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: 611,
          message: error.toString(),
          data: null);
    }
  }
}

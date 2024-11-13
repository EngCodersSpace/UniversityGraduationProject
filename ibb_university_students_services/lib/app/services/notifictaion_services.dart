import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ibb_university_students_services/app/models/notification_model.dart';
import '../models/result.dart';

class NotificationServices {
  // static List<Notifications> _notifications;
  static final Map<String,List<Notification>> _notifications = {};

  static _fakeFetch() {
    Map<String, dynamic> data = {
      "notifications": {
        "2024-10-03": [
          {
            "id": 2,
            "time": "07:30 AM",
            "message": "Campus Alert: Due to inclement weather, all classes for tomorrow are canceled. Stay safe!",
            "author": "Campus Safety Office",
            "readState": false
          },
          {
            "id": 3,
            "time": "10:00 AM",
            "message": "Important Announcement: The university will be hosting a guest speaker event on campus. Don't miss this opportunity!",
            "author": "Events Committee",
            "readState": false
          }
        ],
        "2024-10-02": [
          {
            "id": 1,
            "time": "09:00 AM",
            "message": "Reminder: Don't forget to submit your assignment for the Psychology 101 class by Friday!",
            "author": "Academic Affairs Office",
            "readState": false
          }
        ],
        "2024-10-01": [
          {
            "id": 10,
            "time": "12:00 PM",
            "message": "Club Fair: Explore various student clubs and organizations at the club fair in the quad tomorrow.",
            "author": "Student Involvement Office",
            "readState": true
          },
          {
            "id": 18,
            "time": "03:00 PM",
            "message": "Study Abroad Info Session: Learn about exciting study abroad opportunities at the info session in the student union.",
            "author": "International Programs Office",
            "readState": true
          },
          {
            "id": 19,
            "time": "06:30 PM",
            "message": "Dance Performance: Watch a captivating dance performance by the university dance troupe at the theater.",
            "author": "Dance Department",
            "readState": true
          },
          {
            "id": 20,
            "time": "09:00 PM",
            "message": "Comedy Night: Laugh out loud at the comedy night event hosted by the comedy club in the student center.",
            "author": "Comedy Club",
            "readState": true
          }
        ],
        "2024-09-05": [
          {
            "id": 11,
            "time": "04:30 PM",
            "message": "Health and Fitness: Join the fitness club for a group workout session in the gym.",
            "author": "Fitness Club",
            "readState": true
          },
          {
            "id": 21,
            "time": "12:00 PM",
            "message": "Tech Talk: Attend a tech talk by industry experts at the engineering building.",
            "author": "Engineering Department",
            "readState": true
          },
          {
            "id": 22,
            "time": "02:30 PM",
            "message": "Environmental Awareness Workshop: Learn about sustainability practices at the workshop in the environmental science lab.",
            "author": "Environmental Studies Program",
            "readState": true
          }
        ],
        "2024-09-06": [
          {
            "id": 12,
            "time": "11:30 AM",
            "message": "Career Development Workshop: Enhance your resume writing skills at the career center workshop.",
            "author": "Career Services Center",
            "readState": true
          },
          {
            "id": 23,
            "time": "03:00 PM",
            "message": "Panel Discussion: Join a panel discussion on current social issues at the student union.",
            "author": "Social Sciences Department",
            "readState": true
          },
          {
            "id": 24,
            "time": "06:45 PM",
            "message": "Cultural Festival: Experience cultural performances and cuisine at the annual cultural festival in the quad.",
            "author": "Cultural Affairs Office",
            "readState": true
          },
          {
            "id": 25,
            "time": "09:30 PM",
            "message": "Outdoor Adventure Club Meeting: Join the outdoor adventure club for a meeting to plan upcoming trips.",
            "author": "Outdoor Adventure Club",
            "readState": true
          }
        ],
        "2024-09-07": [
          {
            "id": 13,
            "time": "08:45 AM",
            "message": "Student Council Meeting: Attend the student council meeting in the student union this Friday.",
            "author": "Student Government Association",
            "readState": true
          },
          {
            "id": 26,
            "time": "12:15 PM",
            "message": "Volunteer Fair: Explore volunteer opportunities at the fair in the community center.",
            "author": "Community Engagement Office",
            "readState": true
          },
          {
            "id": 27,
            "time": "03:45 PM",
            "message": "Film Screening: Watch an award-winning film at the screening hosted by the film studies department.",
            "author": "Film Studies Department",
            "readState": true
          },
          {
            "id": 28,
            "time": "07:00 PM",
            "message": "Poetry Night: Share your poetry or enjoy listening to others at the poetry night event in the library.",
            "author": "Library Services Department",
            "readState": true
          }
        ],
        "2024-09-10": [
          {
            "id": 14,
            "time": "06:00 PM",
            "message": "Sports Event: Cheer on our university team at the upcoming basketball game this Saturday. Go Tigers!",
            "author": "Athletics Department",
            "readState": true
          },
          {
            "id": 29,
            "time": "12:30 PM",
            "message": "Community Service Day: Join fellow students in community service activities around the city.",
            "author": "Community Service Office",
            "readState": true
          },
          {
            "id": 30,
            "time": "04:45 PM",
            "message": "Science Fair: Explore innovative science projects at the annual science fair in the science building.",
            "author": "Science Department",
            "readState": true
          },
          {
            "id": 31,
            "time": "08:00 PM",
            "message": "Concert Night: Enjoy a live concert featuring local bands at the amphitheater.",
            "author": "Music Department",
            "readState": true
          }
        ],
        "2024-09-11": [
          {
            "id": 15,
            "time": "03:15 PM",
            "message": "Scholarship Opportunity: Applications for the annual academic scholarships are now open. Don't miss the chance to apply for financial aid.",
            "author": "Financial Aid Office",
            "readState": true
          }
        ],
        "2024-09-03": [
          {
            "id": 4,
            "time": "02:00 PM",
            "message": "Library Workshop: Learn effective research strategies at the library workshop happening this afternoon.",
            "author": "Library Services Department",
            "readState": true
          },
          {
            "id": 5,
            "time": "05:30 PM",
            "message": "Student Mixer: Join us for a fun evening of games and snacks at the student center.",
            "author": "Student Activities Board",
            "readState": true
          },
          {
            "id": 6,
            "time": "08:00 PM",
            "message": "Movie Night: Enjoy a movie screening under the stars at the university lawn tonight.",
            "author": "Film Club",
            "readState": true
          },
          {
            "id": 7,
            "time": "10:30 PM",
            "message": "Stargazing Event: Join the astronomy club for a stargazing session at the observatory.",
            "author": "Astronomy Club",
            "readState": true
          },
          {
            "id": 8,
            "time": "12:30 PM",
            "message": "Lunchtime Concert: Enjoy live music and performances at the amphitheater during your lunch break.",
            "author": "Music Department",
            "readState": true
          },
          {
            "id": 9,
            "time": "03:45 PM",
            "message": "Art Exhibition Opening: Visit the university art gallery for the opening reception of the latest exhibition.",
            "author": "Art Department",
            "readState": true
          },
          {
            "id": 16,
            "time": "09:00 AM",
            "message": "Career Fair: Explore job opportunities at the career fair in the student center.",
            "author": "Career Services Center",
            "readState": true
          },
          {
            "id": 17,
            "time": "01:30 PM",
            "message": "Guest Lecture: Attend a special lecture by a renowned guest speaker in the auditorium.",
            "author": "Guest Speaker Series",
            "readState": true
          }
        ]
      }
    };


    Map<String,dynamic> notifications = data["notifications"];
    for (String key in notifications.keys) {
      List<Notification> notificationsList = [];
      for(Map<String,dynamic> item in notifications[key]){
        notificationsList.add(Notification.fromJson(item));
      }
      _notifications[key] = notificationsList;
    }
  }

  static Future<Result<Map<String,List<Notification>>>> fetchNotifications(
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
      // Map<String,dynamic> notifications = response?.data["notifications"];
      // for (String key in notifications.keys) {
      //   List<Notification> notificationsList = [];
      //   for(Map<String,dynamic> item in notifications[key]){
      //     notificationsList.add(Notification.fromJson(item));
      //   }
      //   _notifications[key] = notificationsList;
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




  static Future<void> setNotificationsReadState()async {
    for (String key in _notifications.keys) {
      for(int i=0;i< (_notifications[key]?.length??0);i++){
        if(_notifications[key]?[i].readState?.value == false){
        _notifications[key]?[i].readState = RxBool(true);
        }
      }
    }
  }
}

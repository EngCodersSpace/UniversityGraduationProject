import 'package:ibb_university_students_services/app/services/user_services.dart';

class PermissionUtils {
  static Map<String, Map<String, List<String>>> permissionsMap = {
    "controller": {
      "Lectures": ["add","edit" "delete", "view"],
      "Exams": ["add", "edit","delete", "view"],
      "Assignments": ["add", "edit","delete", "doctorView"],
    },
    "student": {
      "Lecturers": ["studentView"],
      "Exams": ["studentView"],
      "Assignments": ["studentView"],
    },
    "lecturer": {
      "Lectures": ["add","edit" "delete", "view"],
      "Exams": ["add", "edit","delete", "view"],
      "Assignments": ["add", "edit","delete", "view"],
    },
    "admin": {
      "Lecturers": ["add", "delete", "view"],
      "Exams": ["add", "delete", "view"],
      "Assignments": ["add", "edit","delete", "view"],
    }
  };

  static bool checkPermission({
    required String target,
    required String action,
  }) {
    return permissionsMap[UserServices.permission]?[target]?.contains(
        action)??false;
  }
}

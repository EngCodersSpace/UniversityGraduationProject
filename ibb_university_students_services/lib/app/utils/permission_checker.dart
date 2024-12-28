import 'package:ibb_university_students_services/app/services/user_services.dart';

class PermissionUtils {
  static Map<String, Map<String, List<String>>> permissionsMap = {
    "doctor": {
      "Lecturers": ["add", "delete", "view"],
      "Exams": ["add", "delete", "view"],
    },
    "lecturer": {
      "Lectures": ["add","edit" "delete", "view"],
      "Exams": ["add", "edit","delete", "view"],
    },
    "student": {
      "Lecturers": ["add", "delete", "view"],
      "Exams": ["add", "delete", "view"],
    },
    "admin": {
      "Lecturers": ["add", "delete", "view"],
      "Exams": ["add", "delete", "view"],
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

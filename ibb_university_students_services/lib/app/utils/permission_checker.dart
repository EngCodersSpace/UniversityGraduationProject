import 'package:ibb_university_students_services/app/repositories/user_repository.dart';

class PermissionUtils {
  static Map<String, Map<String, List<String>>> permissionsMap = {
    "controller": {
      "Lectures": ["add","edit" "delete", "view","accessOldTables"],
      "Exams": ["add", "edit","delete", "view","accessOldTables"],
      "Payments": ["add", "edit","delete", "studentSearch"],
      "Assignments": ["add", "edit","delete", "doctorView"],
    },
    "dean": {
      "Lectures": ["add","edit" "delete", "view","accessOldTables"],
      "Exams": ["add", "edit","delete", "view","accessOldTables"],
      "Payments": ["add", "edit","delete", "studentSearch"],
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
      "Assignments": ["add", "edit","delete", "doctorView"],
    },
    "admin": {
      "Lecturers": ["add", "delete", "view","accessOldTables"],
      "Exams": ["add", "delete", "view","accessOldTables"],
      "Assignments": ["add", "edit","delete", "doctorView"],
    }
  };

  static bool checkPermission({
    required String target,
    required String action,
  }) {
    print(UserRepository.userRule);
    return permissionsMap[UserRepository.userRule]?[target]?.contains(
        action)??false;
  }
}

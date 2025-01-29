import 'package:ibb_university_students_services/app/repositories/user_repository.dart';

class PermissionUtils {
  static Map<int, Map<String, List<String>>> permissionsMap = {
    1: {//dean
      "Lectures": ["add","edit" "delete", "view","accessOldTables"],
      "Exams": ["add", "edit","delete", "view","accessOldTables"],
      "Payments": ["add", "edit","delete", "studentSearch"],
      "Assignments": ["add", "edit","delete", "doctorView"],
    },
    2: {
      "Lectures": ["add","edit" "delete", "view","accessOldTables"],
      "Exams": ["add", "edit","delete", "view","accessOldTables"],
      "Payments": ["add", "edit","delete", "studentSearch"],
      "Assignments": ["add", "edit","delete", "doctorView"],
    },
    3: {
      "Lecturers": ["studentView"],
      "Exams": ["studentView"],
      "Assignments": ["studentView"],
    },
    4: {
      "Lectures": ["add","edit" "delete", "view"],
      "Exams": ["add", "edit","delete", "view"],
      "Assignments": ["add", "edit","delete", "doctorView"],
    },
    5: {
      "Lecturers": ["add", "delete", "view","accessOldTables"],
      "Exams": ["add", "delete", "view","accessOldTables"],
      "Assignments": ["add", "edit","delete", "doctorView"],
    }
  };

  static bool checkPermission({
    required String target,
    required String action,
  }) {
    return permissionsMap[UserRepository.userRule]?[target]?.contains(
        action)??false;
  }
}

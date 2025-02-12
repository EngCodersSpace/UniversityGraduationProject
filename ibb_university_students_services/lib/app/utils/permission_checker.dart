import 'package:ibb_university_students_services/app/repositories/user_repository.dart';

class PermissionUtils {

  static Map<int, Map<String, List<String>>> permissionsMap = {
    1: {//dean
      "Lectures": ["add","edit" "delete", "view","accessOldTables"],
      "Exams": ["add", "edit","delete", "view","accessOldTables"],
      "Payments": ["add", "edit","delete", "studentSearch"],
      "Assignments": ["add", "edit","delete", "doctorView","addAttachments","showStudentsFiles"],
    },
    2: {
      "Lectures": [],
      "Exams": [],
      "Payments": [],
      "Assignments": [],
    },

  };

  static bool checkPermission({
    required String target,
    required String action,
  }) {
    return permissionsMap[UserRepository.userRule]?[target]?.contains(
        action)??false;
  }
}

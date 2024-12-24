import 'package:ibb_university_students_services/app/services/user_services.dart';

class PermissionUtils{
  static Map<String, List<String>> permissionsMap = {
    "doctor": ["addLecture", "deleteLecture", "viewLecture"],
    "teacher": ["addLecture", "editLecture", "viewLecture"],
    "student": ["viewLecture",],
    "admin": ["addLecture", "deleteLecture", "editLecture", "viewLecture"],
  };

  static bool checkPermission(String action){
    if (permissionsMap.containsKey(UserServices.permission)) {
      return permissionsMap[UserServices.permission]!.contains(action);  // Check if the action exists in the role's permissions
    }
    return false;
  }
}
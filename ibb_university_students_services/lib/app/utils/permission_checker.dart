

class PermissionUtils {
  static Map<String, List<String>> permissionsMap = {
    "Lectures": ["write", "view", "accessOldTables"],
    "Exams": ["write" "view", "accessOldTables"],
    "Payments": ["view", "write", "studentSearch"],
    "Assignments": ["write", "setCompletion", "setStatus"],
  };

  static bool checkPermission({
    required String target,
    required String action,
  }) {
    return permissionsMap[target]?.contains(action) ??
        false;
  }
}

import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/assignment_model/assignment_model.dart';
part 'assignments_cache.g.dart';
@HiveType(typeId: 24)
class AssignmentsCache {

  @HiveField(0)
  String key ;
  @HiveField(1)
  Map<int, Assignment> data;


  AssignmentsCache({
    required this.key,
    required this.data,

  });
}

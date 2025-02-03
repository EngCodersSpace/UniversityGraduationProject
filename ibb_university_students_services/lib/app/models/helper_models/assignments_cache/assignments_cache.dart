import 'package:hive/hive.dart';
part 'assignments_cache.g.dart';
@HiveType(typeId: 24)
class AssignmentsCache {

  @HiveField(0)
  String key ;
  @HiveField(1)
  List<int> data;


  AssignmentsCache({
    required this.key,
    required this.data,

  });
}

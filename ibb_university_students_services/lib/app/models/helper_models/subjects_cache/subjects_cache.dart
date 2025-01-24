import 'package:hive/hive.dart';
import '../../subject_model/subject_model.dart';
part 'subjects_cache.g.dart';
@HiveType(typeId: 25)
class SubjectsCache {

  @HiveField(0)
  String key ;
  @HiveField(1)
  Map<String, Subject> data;

  SubjectsCache({
    required this.key,
    required this.data,

  });
}

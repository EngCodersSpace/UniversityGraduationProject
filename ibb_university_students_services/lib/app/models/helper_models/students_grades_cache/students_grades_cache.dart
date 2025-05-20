import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/grads_model/grads_model.dart';

part 'students_grades_cache.g.dart';
@HiveType(typeId: 45)
class StudentGradesCache {

  @HiveField(0)
  int key ;
  @HiveField(1)
  Map<int, Grad> data;


  StudentGradesCache({
    required this.key,
    required this.data,

  });
}

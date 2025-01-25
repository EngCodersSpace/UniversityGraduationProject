import 'package:hive/hive.dart';

import '../../exam_model/exam_model.dart';

part 'exams_cache.g.dart';
@HiveType(typeId: 22)
class ExamsCache {

  @HiveField(0)
  String key ;
  @HiveField(1)
  Map<int, Exam> data;


  ExamsCache({
    required this.key,
    required this.data,

  });
}

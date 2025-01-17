import 'package:hive/hive.dart';

import '../../lecture_model/lecture_model.dart';
part 'lectures_cache.g.dart';
@HiveType(typeId: 21)
class LecturesCache {

  @HiveField(0)
  String key ;
  @HiveField(1)
  Map<String, Map<int, Lecture>> data;


  LecturesCache({
    required this.key,
    required this.data,

  });
}

import 'package:hive/hive.dart';

part 'lectures_cache.g.dart';
@HiveType(typeId: 21)
class LecturesCache {

  @HiveField(0)
  String key ;
  @HiveField(1)
  Map<String, List<int>> data;


  LecturesCache({
    required this.key,
    required this.data,

  });
}

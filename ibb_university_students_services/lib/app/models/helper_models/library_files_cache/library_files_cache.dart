import 'package:hive/hive.dart';
part 'library_files_cache.g.dart';
@HiveType(typeId: 26)
class LibraryFilesCache {

  @HiveField(0)
  String key ;
  @HiveField(1)
  List<int> data;


  LibraryFilesCache({
    required this.key,
    required this.data,

  });
}

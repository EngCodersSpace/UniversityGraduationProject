import 'package:hive/hive.dart';
part 'refresh_state.g.dart';
@HiveType(typeId: 30)
class RefreshState {
  @HiveField(0)
  int id;
  @HiveField(1)
  Map<String,dynamic>? filters;
  @HiveField(2)
  String? target;
  @HiveField(3)
  String? createdAt;
  @HiveField(4)
  String? updatedAt;

  RefreshState({
    required this.id,
    this.target,
    this.filters,
    this.createdAt,
    this.updatedAt,
  });


}





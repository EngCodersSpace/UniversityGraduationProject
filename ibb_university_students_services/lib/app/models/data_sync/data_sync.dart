import 'package:hive/hive.dart';

import '../../utils/json_utils.dart';
part 'data_sync.g.dart';
@HiveType(typeId: 30)
class DataSync {
  @HiveField(0)
  String id;
  @HiveField(1)
  Map<String,dynamic>? filters;
  @HiveField(2)
  String? target;
  @HiveField(3)
  String? createdAt;
  @HiveField(4)
  String? updatedAt;

  DataSync({
    required this.id,
    this.target,
    this.filters,
    this.createdAt,
    this.updatedAt,
  });


  factory DataSync.fromJson(Map<String, dynamic> json) {
    return DataSync(
      id: json['id'],
      target: json['target'],
      filters: JsonUtils.tryJsonDecode(json['filter']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }


}





// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lectures_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LecturesCacheAdapter extends TypeAdapter<LecturesCache> {
  @override
  final int typeId = 21;

  @override
  LecturesCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LecturesCache(
      key: fields[0] as String,
      data: (fields[1] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as Map).cast<int, Lecture>())),
    );
  }

  @override
  void write(BinaryWriter writer, LecturesCache obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LecturesCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exams_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamsCacheAdapter extends TypeAdapter<ExamsCache> {
  @override
  final int typeId = 22;

  @override
  ExamsCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamsCache(
      key: fields[0] as String,
      data: (fields[1] as Map).cast<int, Exam>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExamsCache obj) {
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
      other is ExamsCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

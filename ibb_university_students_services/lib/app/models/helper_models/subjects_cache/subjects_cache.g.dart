// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subjects_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectsCacheAdapter extends TypeAdapter<SubjectsCache> {
  @override
  final int typeId = 25;

  @override
  SubjectsCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectsCache(
      key: fields[0] as String,
      data: (fields[1] as Map).cast<String, Subject>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubjectsCache obj) {
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
      other is SubjectsCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignments_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssignmentsCacheAdapter extends TypeAdapter<AssignmentsCache> {
  @override
  final int typeId = 24;

  @override
  AssignmentsCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssignmentsCache(
      key: fields[0] as String,
      data: (fields[1] as Map).cast<int, Assignment>(),
    );
  }

  @override
  void write(BinaryWriter writer, AssignmentsCache obj) {
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
      other is AssignmentsCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

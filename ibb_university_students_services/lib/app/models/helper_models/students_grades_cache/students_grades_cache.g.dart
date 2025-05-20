// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students_grades_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentGradesCacheAdapter extends TypeAdapter<StudentGradesCache> {
  @override
  final int typeId = 45;

  @override
  StudentGradesCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentGradesCache(
      key: fields[0] as int,
      data: (fields[1] as Map).cast<int, Grad>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudentGradesCache obj) {
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
      other is StudentGradesCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

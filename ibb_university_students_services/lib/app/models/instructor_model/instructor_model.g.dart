// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstructorAdapter extends TypeAdapter<Instructor> {
  @override
  final int typeId = 4;

  @override
  Instructor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Instructor(
      id: fields[0] as int,
      nameData: (fields[1] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Instructor obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstructorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

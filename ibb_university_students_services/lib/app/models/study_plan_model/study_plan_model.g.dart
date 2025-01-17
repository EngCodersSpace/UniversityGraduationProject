// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_plan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyPlaneAdapter extends TypeAdapter<StudyPlane> {
  @override
  final int typeId = 12;

  @override
  StudyPlane read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyPlane(
      id: fields[0] as int,
      name: fields[1] as String?,
      createdAt: fields[2] as String?,
      updatedAt: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudyPlane obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyPlaneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

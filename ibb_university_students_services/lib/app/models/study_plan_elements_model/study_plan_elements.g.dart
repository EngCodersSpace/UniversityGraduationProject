// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_plan_elements.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyPlanElementAdapter extends TypeAdapter<StudyPlanElement> {
  @override
  final int typeId = 10;

  @override
  StudyPlanElement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyPlanElement(
      id: fields[0] as int,
      studyPlanId: fields[1] as int?,
      sectionId: fields[3] as int?,
      levelId: fields[4] as int?,
      subject: fields[2] as Subject?,
      doctorId: fields[5] as int?,
      name: fields[6] as String?,
      createdAt: fields[7] as String?,
      updatedAt: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudyPlanElement obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studyPlanId)
      ..writeByte(2)
      ..write(obj.subject)
      ..writeByte(3)
      ..write(obj.sectionId)
      ..writeByte(4)
      ..write(obj.levelId)
      ..writeByte(5)
      ..write(obj.doctorId)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyPlanElementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

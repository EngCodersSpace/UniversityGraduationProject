// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LectureAdapter extends TypeAdapter<Lecture> {
  @override
  final int typeId = 8;

  @override
  Lecture read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lecture(
      id: fields[0] as int,
      sectionId: fields[1] as int?,
      day: fields[3] as String?,
      levelId: fields[2] as int?,
      subject: fields[4] as Subject?,
      startTime: fields[5] as String?,
      duration: fields[6] as int?,
      instructorId: fields[10] as int?,
      hall: fields[7] as String?,
      description: fields[8] as String?,
      lectureStatus: fields[9] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Lecture obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sectionId)
      ..writeByte(2)
      ..write(obj.levelId)
      ..writeByte(3)
      ..write(obj.day)
      ..writeByte(4)
      ..write(obj.subject)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.hall)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.lectureStatus)
      ..writeByte(10)
      ..write(obj.instructorId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LectureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

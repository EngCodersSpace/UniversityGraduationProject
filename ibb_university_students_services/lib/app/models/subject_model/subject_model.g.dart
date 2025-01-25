// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 5;

  @override
  Subject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subject(
      id: fields[0] as String,
      subjectNameData: (fields[1] as Map?)?.cast<String, dynamic>(),
      units: fields[2] as int?,
      descriptionData: (fields[3] as Map?)?.cast<String, dynamic>(),
      instructors: (fields[4] as Map?)?.cast<int, Instructor>(),
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subjectNameData)
      ..writeByte(2)
      ..write(obj.units)
      ..writeByte(3)
      ..write(obj.descriptionData)
      ..writeByte(4)
      ..write(obj.instructors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

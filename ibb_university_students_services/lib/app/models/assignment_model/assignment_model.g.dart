// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssignmentAdapter extends TypeAdapter<Assignment> {
  @override
  final int typeId = 15;

  @override
  Assignment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Assignment(
      id: fields[0] as int,
      levelId: fields[2] as int?,
      sectionId: fields[1] as int?,
      doctor: fields[3] as Instructor?,
      titleData: (fields[4] as Map?)?.cast<String, dynamic>(),
      assignmentDay: fields[5] as String?,
      assignmentDate: fields[6] as String?,
      dueDate: fields[7] as String?,
      attachments: (fields[8] as Map?)?.cast<int, AttachmentFile>(),
      studentsStatus: (fields[9] as Map?)?.cast<int, StudentAssignmentState>(),
    );
  }

  @override
  void write(BinaryWriter writer, Assignment obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sectionId)
      ..writeByte(2)
      ..write(obj.levelId)
      ..writeByte(3)
      ..write(obj.doctor)
      ..writeByte(4)
      ..write(obj.titleData)
      ..writeByte(5)
      ..write(obj.assignmentDay)
      ..writeByte(6)
      ..write(obj.assignmentDate)
      ..writeByte(7)
      ..write(obj.dueDate)
      ..writeByte(8)
      ..write(obj.attachments)
      ..writeByte(9)
      ..write(obj.studentsStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

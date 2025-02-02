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
      subject: fields[1] as Subject?,
      doctor: fields[2] as Instructor?,
      titleData: (fields[3] as Map?)?.cast<String, dynamic>(),
      assignmentDay: fields[4] as String?,
      assignmentDate: fields[5] as String?,
      dueDate: fields[6] as String?,
      attachments: (fields[7] as Map?)?.cast<int, AttachmentFile>(),
    )..studentsStatus =
        (fields[8] as Map?)?.cast<int, StudentAssignmentState>();
  }

  @override
  void write(BinaryWriter writer, Assignment obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subject)
      ..writeByte(2)
      ..write(obj.doctor)
      ..writeByte(3)
      ..write(obj.titleData)
      ..writeByte(4)
      ..write(obj.assignmentDay)
      ..writeByte(5)
      ..write(obj.assignmentDate)
      ..writeByte(6)
      ..write(obj.dueDate)
      ..writeByte(7)
      ..write(obj.attachments)
      ..writeByte(8)
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

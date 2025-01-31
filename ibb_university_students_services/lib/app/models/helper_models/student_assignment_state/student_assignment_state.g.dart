// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_assignment_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAssignmentStateAdapter
    extends TypeAdapter<StudentAssignmentState> {
  @override
  final int typeId = 17;

  @override
  StudentAssignmentState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentAssignmentState(
      studentId: fields[0] as int?,
      studentNameData: (fields[1] as Map?)?.cast<String, dynamic>(),
      state: fields[3] as String?,
      isCompleted: fields[4] as bool?,
      studentFiles: (fields[5] as List?)?.cast<AttachmentFile>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudentAssignmentState obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.studentId)
      ..writeByte(1)
      ..write(obj.studentNameData)
      ..writeByte(3)
      ..write(obj.state)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.studentFiles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAssignmentStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

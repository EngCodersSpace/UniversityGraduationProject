// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_assignments_file_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAssignmentsFileAdapter
    extends TypeAdapter<StudentAssignmentsFile> {
  @override
  final int typeId = 18;

  @override
  StudentAssignmentsFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentAssignmentsFile(
      id: fields[0] as int,
      studentAssignmentId: fields[1] as int?,
      title: fields[4] as String?,
      path: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentAssignmentsFile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentAssignmentId)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(4)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAssignmentsFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

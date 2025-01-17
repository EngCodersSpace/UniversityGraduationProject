// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 3;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      id: fields[0] as int,
      nameData: (fields[1] as Map?)?.cast<String, dynamic>(),
      dateOfBrith: fields[2] as String?,
      email: fields[3] as String?,
      phones: (fields[6] as List?)?.cast<String>(),
      profileImage: fields[5] as String?,
      permission: fields[4] as String?,
      studyPlaneId: fields[11] as int?,
      level: fields[12] as Level?,
      collegeNameData: (fields[7] as Map?)?.cast<String, dynamic>(),
      section: fields[8] as Section?,
      systemData: (fields[13] as Map?)?.cast<String, dynamic>(),
      enrollmentYear: fields[14] as String?,
      createdAt: fields[9] as String?,
      updatedAt: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(15)
      ..writeByte(11)
      ..write(obj.studyPlaneId)
      ..writeByte(12)
      ..write(obj.level)
      ..writeByte(13)
      ..write(obj.systemData)
      ..writeByte(14)
      ..write(obj.enrollmentYear)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameData)
      ..writeByte(2)
      ..write(obj.dateOfBrith)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.permission)
      ..writeByte(5)
      ..write(obj.profileImage)
      ..writeByte(6)
      ..write(obj.phones)
      ..writeByte(7)
      ..write(obj.collegeNameData)
      ..writeByte(8)
      ..write(obj.section)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

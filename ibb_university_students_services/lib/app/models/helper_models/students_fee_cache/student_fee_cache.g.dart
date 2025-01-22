// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_fee_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentFeeCacheAdapter extends TypeAdapter<StudentFeeCache> {
  @override
  final int typeId = 23;

  @override
  StudentFeeCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentFeeCache(
      key: fields[0] as int,
      data: (fields[1] as Map).cast<int, StudentFee>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudentFeeCache obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentFeeCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

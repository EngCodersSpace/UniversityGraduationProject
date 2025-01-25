// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_fee.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentFeeAdapter extends TypeAdapter<StudentFee> {
  @override
  final int typeId = 11;

  @override
  StudentFee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentFee(
      id: fields[0] as int,
      levelId: fields[2] as int?,
      term: fields[3] as String?,
      studentId: fields[1] as int?,
      totalAmount: fields[4] as double?,
      payedAmount: fields[5] as double?,
      paymentDate: fields[6] as String?,
      receiptNumber: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentFee obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.levelId)
      ..writeByte(3)
      ..write(obj.term)
      ..writeByte(4)
      ..write(obj.totalAmount)
      ..writeByte(5)
      ..write(obj.payedAmount)
      ..writeByte(6)
      ..write(obj.paymentDate)
      ..writeByte(7)
      ..write(obj.receiptNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentFeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

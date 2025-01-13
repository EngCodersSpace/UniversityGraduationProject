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
      levelId: fields[3] as int?,
      sectionId: fields[2] as int?,
      term: fields[4] as int?,
      studentId: fields[1] as int?,
      totalAmount: fields[5] as int?,
      payedAmount: fields[6] as int?,
      remainAmount: fields[7] as int?,
      paymentState: fields[8] as String?,
      paymentDate: fields[9] as String?,
      receiptNumber: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentFee obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.sectionId)
      ..writeByte(3)
      ..write(obj.levelId)
      ..writeByte(4)
      ..write(obj.term)
      ..writeByte(5)
      ..write(obj.totalAmount)
      ..writeByte(6)
      ..write(obj.payedAmount)
      ..writeByte(7)
      ..write(obj.remainAmount)
      ..writeByte(8)
      ..write(obj.paymentState)
      ..writeByte(9)
      ..write(obj.paymentDate)
      ..writeByte(10)
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

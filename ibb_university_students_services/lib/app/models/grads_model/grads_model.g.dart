// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grads_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradAdapter extends TypeAdapter<Grad> {
  @override
  final int typeId = 7;

  @override
  Grad read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Grad(
      id: fields[0] as int,
      levelId: fields[1] as int?,
      term: fields[2] as String?,
      yearOfIssue: fields[3] as String?,
      subject: fields[5] as Subject?,
      examGrad: fields[6] as int?,
      workGrad: fields[7] as int?,
      isAbsent: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Grad obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.levelId)
      ..writeByte(2)
      ..write(obj.term)
      ..writeByte(3)
      ..write(obj.yearOfIssue)
      ..writeByte(4)
      ..write(obj.isAbsent)
      ..writeByte(5)
      ..write(obj.subject)
      ..writeByte(6)
      ..write(obj.examGrad)
      ..writeByte(7)
      ..write(obj.workGrad);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

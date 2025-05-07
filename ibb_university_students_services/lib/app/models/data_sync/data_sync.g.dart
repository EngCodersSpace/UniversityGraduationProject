// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_sync.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataSyncAdapter extends TypeAdapter<DataSync> {
  @override
  final int typeId = 30;

  @override
  DataSync read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataSync(
      id: fields[0] as String,
      target: fields[2] as String?,
      filters: (fields[1] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[3] as String?,
      updatedAt: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataSync obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.filters)
      ..writeByte(2)
      ..write(obj.target)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataSyncAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

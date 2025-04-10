// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RefreshStateAdapter extends TypeAdapter<RefreshState> {
  @override
  final int typeId = 30;

  @override
  RefreshState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RefreshState(
      id: fields[0] as int,
      target: fields[2] as String?,
      filters: (fields[1] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[3] as String?,
      updatedAt: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RefreshState obj) {
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
      other is RefreshStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

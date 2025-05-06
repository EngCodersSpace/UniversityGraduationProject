// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PermissionAdapter extends TypeAdapter<Permission> {
  @override
  final int typeId = 34;

  @override
  Permission read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Permission(
      id: fields[0] as int,
      target: fields[1] as String?,
      action: fields[2] as String?,
      createdAt: fields[3] as String?,
      updatedAt: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Permission obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.target)
      ..writeByte(2)
      ..write(obj.action)
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
      other is PermissionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

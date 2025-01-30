// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_file_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttachmentFileAdapter extends TypeAdapter<AttachmentFile> {
  @override
  final int typeId = 16;

  @override
  AttachmentFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttachmentFile(
      id: fields[0] as int?,
      assignmentId: fields[1] as int?,
      path: fields[2] as String?,
    )..status = fields[3] as RxString;
  }

  @override
  void write(BinaryWriter writer, AttachmentFile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.assignmentId)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

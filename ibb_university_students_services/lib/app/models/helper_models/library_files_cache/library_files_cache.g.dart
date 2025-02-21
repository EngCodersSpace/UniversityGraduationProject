// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_files_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibraryFilesCacheAdapter extends TypeAdapter<LibraryFilesCache> {
  @override
  final int typeId = 25;

  @override
  LibraryFilesCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LibraryFilesCache(
      key: fields[0] as String,
      data: (fields[1] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, LibraryFilesCache obj) {
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
      other is LibraryFilesCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_files_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibraryFileAdapter extends TypeAdapter<LibraryFile> {
  @override
  final int typeId = 19;

  @override
  LibraryFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LibraryFile(
      id: fields[0] as int,
      sectionsAndLevels: (fields[1] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      category: fields[9] as String,
      subject: fields[3] as Subject?,
      addedBy: fields[4] as int?,
      title: fields[5] as String?,
      filePath: fields[11] as String?,
      fileSize: fields[10] as double?,
      author: fields[6] as String?,
      edition: fields[8] as String?,
      displayImage: fields[12] as String?,
      numberOfPages: fields[7] as int?,
      originalName: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LibraryFile obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sectionsAndLevels)
      ..writeByte(3)
      ..write(obj.subject)
      ..writeByte(4)
      ..write(obj.addedBy)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.author)
      ..writeByte(7)
      ..write(obj.numberOfPages)
      ..writeByte(8)
      ..write(obj.edition)
      ..writeByte(9)
      ..write(obj.category)
      ..writeByte(10)
      ..write(obj.fileSize)
      ..writeByte(11)
      ..write(obj.filePath)
      ..writeByte(12)
      ..write(obj.displayImage)
      ..writeByte(13)
      ..write(obj.originalName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

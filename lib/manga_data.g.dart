// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MangaDataAdapter extends TypeAdapter<MangaData> {
  @override
  final int typeId = 0;

  @override
  MangaData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MangaData(
      title: fields[0] as String,
      pagePaths: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MangaData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.pagePaths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MangaDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

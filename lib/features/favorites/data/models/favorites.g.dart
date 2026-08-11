// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritesAdapter extends TypeAdapter<Favorites> {
  @override
  final int typeId = 1;

  @override
  Favorites read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorites(
      id: fields[0] as String,
      title: fields[1] as String,
      subTitle: fields[2] as String,
      ingredients: fields[3] as String,
      timing: fields[4] as String,
      rating: fields[5] as double,
      image: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Favorites obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subTitle)
      ..writeByte(3)
      ..write(obj.ingredients)
      ..writeByte(4)
      ..write(obj.timing)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

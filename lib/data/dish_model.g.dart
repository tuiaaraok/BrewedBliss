// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DishModelAdapter extends TypeAdapter<DishModel> {
  @override
  final int typeId = 1;

  @override
  DishModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DishModel(
      dishName: fields[0] as String,
      price: fields[1] as String,
      category: fields[2] as String,
      image: fields[4] as Uint8List?,
      count: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DishModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dishName)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.count)
      ..writeByte(4)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_save_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DishSaveModelAdapter extends TypeAdapter<DishSaveModel> {
  @override
  final int typeId = 3;

  @override
  DishSaveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DishSaveModel(
      date: fields[2] as DateTime,
      isCash: fields[0] as bool,
      total: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DishSaveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isCash)
      ..writeByte(1)
      ..write(obj.total)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishSaveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

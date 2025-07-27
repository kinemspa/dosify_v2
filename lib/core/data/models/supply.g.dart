// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supply.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SupplyAdapter extends TypeAdapter<Supply> {
  @override
  final int typeId = 3;

  @override
  Supply read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Supply(
      id: fields[0] as int?,
      name: fields[1] as String,
      unit: fields[2] as String,
      stock: fields[3] as int,
      lowStockThreshold: fields[4] as int,
      linkedMedId: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Supply obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.stock)
      ..writeByte(4)
      ..write(obj.lowStockThreshold)
      ..writeByte(5)
      ..write(obj.linkedMedId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

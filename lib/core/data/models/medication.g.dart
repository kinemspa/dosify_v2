// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicationAdapter extends TypeAdapter<Medication> {
  @override
  final int typeId = 0;

  @override
  Medication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medication(
      id: fields[0] as int?,
      name: fields[1] as String,
      type: fields[2] as MedicationType,
      strength: fields[3] as double,
      unit: fields[4] as String,
      stock: fields[5] as int,
      lowStockThreshold: fields[6] as int,
      reconstitution: fields[7] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Medication obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.strength)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.stock)
      ..writeByte(6)
      ..write(obj.lowStockThreshold)
      ..writeByte(7)
      ..write(obj.reconstitution);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicationTypeAdapter extends TypeAdapter<MedicationType> {
  @override
  final int typeId = 6;

  @override
  MedicationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MedicationType.tablet;
      case 1:
        return MedicationType.injection;
      case 2:
        return MedicationType.drops;
      case 3:
        return MedicationType.other;
      default:
        return MedicationType.tablet;
    }
  }

  @override
  void write(BinaryWriter writer, MedicationType obj) {
    switch (obj) {
      case MedicationType.tablet:
        writer.writeByte(0);
        break;
      case MedicationType.injection:
        writer.writeByte(1);
        break;
      case MedicationType.drops:
        writer.writeByte(2);
        break;
      case MedicationType.other:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

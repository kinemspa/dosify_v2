// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconstitution.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReconstitutionAdapter extends TypeAdapter<Reconstitution> {
  @override
  final int typeId = 4;

  @override
  Reconstitution read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reconstitution(
      powderAmount: fields[0] as double,
      solventVolume: fields[1] as double,
      desiredConcentration: fields[2] as double?,
      calculatedVolumePerDose: fields[3] as double?,
      medId: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Reconstitution obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.powderAmount)
      ..writeByte(1)
      ..write(obj.solventVolume)
      ..writeByte(2)
      ..write(obj.desiredConcentration)
      ..writeByte(3)
      ..write(obj.calculatedVolumePerDose)
      ..writeByte(4)
      ..write(obj.medId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReconstitutionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

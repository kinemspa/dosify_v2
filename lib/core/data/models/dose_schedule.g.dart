// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoseScheduleAdapter extends TypeAdapter<DoseSchedule> {
  @override
  final int typeId = 1;

  @override
  DoseSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoseSchedule(
      id: fields[0] as int?,
      medId: fields[1] as int,
      doseAmount: fields[2] as double,
      unit: fields[3] as String,
      frequency: fields[4] as Frequency,
      times: (fields[5] as List).cast<TimeOfDay>(),
      startDate: fields[6] as DateTime,
      endDate: fields[7] as DateTime?,
      isActive: fields[8] as bool,
      cycleWeeks: fields[9] as int?,
      cycleOffWeeks: fields[10] as int?,
      isCycling: fields[11] as bool?,
      titrationSteps: (fields[12] as List?)?.cast<TitrationStep>(),
    );
  }

  @override
  void write(BinaryWriter writer, DoseSchedule obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medId)
      ..writeByte(2)
      ..write(obj.doseAmount)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.frequency)
      ..writeByte(5)
      ..write(obj.times)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.cycleWeeks)
      ..writeByte(10)
      ..write(obj.cycleOffWeeks)
      ..writeByte(11)
      ..write(obj.isCycling)
      ..writeByte(12)
      ..write(obj.titrationSteps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoseScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TitrationStepAdapter extends TypeAdapter<TitrationStep> {
  @override
  final int typeId = 5;

  @override
  TitrationStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TitrationStep(
      period: fields[0] as int,
      doseAmount: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TitrationStep obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.period)
      ..writeByte(1)
      ..write(obj.doseAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TitrationStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FrequencyAdapter extends TypeAdapter<Frequency> {
  @override
  final int typeId = 7;

  @override
  Frequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Frequency.daily;
      case 1:
        return Frequency.weekly;
      case 2:
        return Frequency.custom;
      default:
        return Frequency.daily;
    }
  }

  @override
  void write(BinaryWriter writer, Frequency obj) {
    switch (obj) {
      case Frequency.daily:
        writer.writeByte(0);
        break;
      case Frequency.weekly:
        writer.writeByte(1);
        break;
      case Frequency.custom:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'dose_schedule.g.dart'; // Generated

@HiveType(typeId: 1)
class DoseSchedule {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int medId;

  @HiveField(2)
  double doseAmount;

  @HiveField(3)
  String unit;

  @HiveField(4)
  Frequency frequency;

  @HiveField(5)
  List<TimeOfDay> times;

  @HiveField(6)
  DateTime startDate;

  @HiveField(7)
  DateTime? endDate;

  @HiveField(8)
  bool isActive;

  @HiveField(9)
  int? cycleWeeks;

  @HiveField(10)
  int? cycleOffWeeks;

  @HiveField(11)
  bool? isCycling;

  @HiveField(12)
  List<TitrationStep>? titrationSteps;

  DoseSchedule({
    this.id,
    required this.medId,
    required this.doseAmount,
    required this.unit,
    required this.frequency,
    required this.times,
    required this.startDate,
    this.endDate,
    required this.isActive,
    this.cycleWeeks,
    this.cycleOffWeeks,
    this.isCycling,
    this.titrationSteps,
  });
}

@HiveType(typeId: 5) // Separate typeId for TitrationStep
class TitrationStep {
  @HiveField(0)
  int period;

  @HiveField(1)
  double doseAmount;

  TitrationStep({
    required this.period,
    required this.doseAmount,
  });
}

@HiveType(typeId: 7)
enum Frequency {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  custom,
}
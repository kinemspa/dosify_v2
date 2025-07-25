import 'package:hive/hive.dart';

part 'dose_log.g.dart';

@HiveType(typeId: 2)
class DoseLog {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int scheduleId;

  @HiveField(2)
  DateTime takenTime;

  @HiveField(3)
  double amountTaken;

  @HiveField(4)
  String? notes;

  @HiveField(5)
  String? reaction;

  DoseLog({
    this.id,
    required this.scheduleId,
    required this.takenTime,
    required this.amountTaken,
    this.notes,
    this.reaction,
  });
}
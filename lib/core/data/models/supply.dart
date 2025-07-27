import 'package:hive/hive.dart';

part 'supply.g.dart';

@HiveType(typeId: 3)
class Supply extends HiveObject {  // Added extends HiveObject
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String unit;

  @HiveField(3)
  int stock;

  @HiveField(4)
  int lowStockThreshold;

  @HiveField(5)
  int? linkedMedId;

  Supply({
    this.id,
    required this.name,
    required this.unit,
    required this.stock,
    required this.lowStockThreshold,
    this.linkedMedId,
  });
}
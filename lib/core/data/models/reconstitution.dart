import 'package:hive/hive.dart';

part 'reconstitution.g.dart';

@HiveType(typeId: 4)
class Reconstitution {
  @HiveField(0)
  double powderAmount;

  @HiveField(1)
  double solventVolume;

  @HiveField(2)
  double? desiredConcentration;

  @HiveField(3)
  double? calculatedVolumePerDose;

  Reconstitution({
    required this.powderAmount,
    required this.solventVolume,
    this.desiredConcentration,
    this.calculatedVolumePerDose,
  });
}
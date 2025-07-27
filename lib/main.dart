import 'package:dosify_v2/features/auth/ui/auth_screen.dart';
import 'package:dosify_v2/features/home/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/data/models/dose_log.dart';
import 'core/data/models/dose_schedule.dart';
import 'core/data/models/medication.dart';
import 'core/data/models/reconstitution.dart';
import 'core/data/models/supply.dart';
import 'core/data/repositories/medication_repository.dart';
import 'core/data/models/time_of_day_adapter.dart';
import 'core/data/repositories/supply_repository.dart';
import 'core/data/repositories/reconstitution_repository.dart';
import 'core/utils/reconstitution_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(MedicationAdapter());
  if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(MedicationTypeAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(DoseScheduleAdapter());
  if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(TitrationStepAdapter());
  if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(FrequencyAdapter());
  if (!Hive.isAdapterRegistered(8)) Hive.registerAdapter(TimeOfDayAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(DoseLogAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(SupplyAdapter());
  if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(ReconstitutionAdapter());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Test code here if wanted
  final repo = MedicationRepository();
  await repo.init();
  final supplyRepo = SupplyRepository();
  await supplyRepo.init();
  final reconRepo = ReconstitutionRepository();
  await reconRepo.init();

  final medKey = await repo.addMedication(Medication(
    name: 'Test Med',
    type: MedicationType.tablet,
    strength: 10.0,
    unit: 'mg',
    stock: 20,
    lowStockThreshold: 5,
    reconstitution: true,
  ));

  await reconRepo.addReconstitution(Reconstitution(
    powderAmount: 100.0,
    solventVolume: 10.0,
    desiredConcentration: 10.0,
    calculatedVolumePerDose: calculateVolumePerDose(100.0, 10.0, 10.0),
    medId: medKey,
  ));

  await supplyRepo.addSupply(Supply(
    name: 'Test Supply',
    unit: 'units',
    stock: 50,
    lowStockThreshold: 10,
    linkedMedId: medKey,
  ));

  print(repo.getMedications());
  print(supplyRepo.getSupplies());
  print(reconRepo.getReconstitutions());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dosify.v2',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthScreen(),
    );
  }
}
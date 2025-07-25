import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/data/models/medication.dart';
import 'core/data/models/dose_schedule.dart';
import 'core/data/models/dose_log.dart';
import 'core/data/models/supply.dart';
import 'core/data/models/reconstitution.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Init Hive
  Hive.registerAdapter(MedicationAdapter());
  Hive.registerAdapter(MedicationTypeAdapter()); // If enum needs adapter (auto-generated)
  Hive.registerAdapter(DoseScheduleAdapter());
  Hive.registerAdapter(TitrationStepAdapter());
  Hive.registerAdapter(FrequencyAdapter());
  Hive.registerAdapter(DoseLogAdapter());
  Hive.registerAdapter(SupplyAdapter());
  Hive.registerAdapter(ReconstitutionAdapter());

  final repo = MedicationRepository();
  await repo.init();
// Add test data
  await repo.addMedication(Medication(
    name: 'Test Med',
    type: MedicationType.tablet,
    strength: 10.0,
    unit: 'mg',
    stock: 20,
    lowStockThreshold: 5,
  ));
  print(repo.getMedications()); // Check console

  // Open boxes later in repositories
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dosify.v2',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(body: Center(child: Text('Dosify.v2 Setup Complete'))),
    );
  }
}
import 'package:dosify_v2/features/auth/ui/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/data/models/dose_log.dart';
import 'core/data/models/dose_schedule.dart';
import 'core/data/models/medication.dart';
import 'core/data/models/reconstitution.dart';
import 'core/data/models/supply.dart';
import 'core/data/models/time_of_day_adapter.dart';
import 'core/utils/notification_utils.dart'; // New import
import 'package:timezone/data/latest.dart' as tz_data;

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
  await NotificationUtils.init(); // New: Init notifications

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
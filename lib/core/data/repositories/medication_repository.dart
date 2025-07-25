import 'package:hive/hive.dart';
import '../models/medication.dart';

class MedicationRepository {
  late Box<Medication> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Medication>('medications');
  }

  Future<void> addMedication(Medication med) async {
    await _box.add(med);
  }

  List<Medication> getMedications() {
    return _box.values.toList();
  }
}
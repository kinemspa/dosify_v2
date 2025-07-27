import 'package:hive/hive.dart';
import '../models/medication.dart';

class MedicationRepository {
  late Box<Medication> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Medication>('medications');
  }

  Future<int> addMedication(Medication med) async {
    return await _box.add(med);
  }

  Future<void> updateMedication(int key, Medication med) async {
    await _box.put(key, med);
  }

  List<Medication> getMedications() {
    return _box.values.toList();
  }
}
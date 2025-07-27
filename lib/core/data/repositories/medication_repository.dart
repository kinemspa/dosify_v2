import 'package:hive/hive.dart';
import '../models/medication.dart';
import 'package:logger/logger.dart';

class MedicationRepository {
  late Box<Medication> _box;
  final _logger = Logger();

  Future<void> init() async {
    _logger.d('Initializing MedicationRepository');
    _box = await Hive.openBox<Medication>('medications');
  }

  Future<int> addMedication(Medication med) async {
    _logger.d('Adding medication: ${med.name}');
    final key = await _box.add(med);
    med.id = key; // Assign Hive-generated key to med.id
    await _box.put(key, med); // Update Hive with assigned id
    _logger.d('Medication added with key: $key');
    return key;
  }

  Future<void> updateMedication(int key, Medication med) async {
    _logger.d('Updating medication with key: $key');
    await _box.put(key, med);
  }

  Future<void> deleteMedication(int key) async {
    _logger.d('Deleting medication with key: $key');
    await _box.delete(key);
  }

  List<Medication> getMedications() {
    _logger.d('Fetching medications');
    return _box.values.toList();
  }
}
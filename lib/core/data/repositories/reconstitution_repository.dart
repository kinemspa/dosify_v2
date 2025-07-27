import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import '../models/reconstitution.dart';

class ReconstitutionRepository {
  Box<Reconstitution>? _box; // Allow null initially
  final _logger = Logger();

  Future<void> init() async {
    _logger.d('Initializing ReconstitutionRepository');
    if (!Hive.isBoxOpen('reconstitutions')) {
      _box = await Hive.openBox<Reconstitution>('reconstitutions');
    } else {
      _box = Hive.box<Reconstitution>('reconstitutions');
    }
    _logger.d('Reconstitution box initialized');
  }

  Future<int> addReconstitution(Reconstitution recon) async {
    if (_box == null) await init();
    _logger.d('Adding reconstitution for medId: ${recon.medId}');
    return await _box!.add(recon);
  }

  Reconstitution? getByMedId(int medId) {
    if (_box == null) {
      _logger.w('Box not initialized in getByMedId');
      return null;
    }
    _logger.d('Fetching reconstitution for medId: $medId');
    try {
      return _box!.values.firstWhere((recon) => recon.medId == medId);
    } on StateError {
      return null;
    }
  }

  Future<void> updateReconstitution(int key, Reconstitution recon) async {
    if (_box == null) await init();
    _logger.d('Updating reconstitution with key: $key');
    await _box!.put(key, recon);
  }

  Future<void> deleteReconstitution(int key) async {
    if (_box == null) await init();
    _logger.d('Deleting reconstitution with key: $key');
    await _box!.delete(key);
  }

  List<Reconstitution> getReconstitutions() {
    if (_box == null) {
      _logger.w('Box not initialized in getReconstitutions');
      return [];
    }
    _logger.d('Fetching all reconstitutions');
    return _box!.values.toList();
  }

  Reconstitution? getReconstitution(int key) {
    if (_box == null) {
      _logger.w('Box not initialized in getReconstitution');
      return null;
    }
    _logger.d('Fetching reconstitution with key: $key');
    return _box!.get(key);
  }
}
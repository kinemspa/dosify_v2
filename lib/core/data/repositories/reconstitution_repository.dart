import 'package:hive/hive.dart';
import '../models/reconstitution.dart';

class ReconstitutionRepository {
  late Box<Reconstitution> _box;

  Future<void> init() async {
    if (!Hive.isBoxOpen('reconstitutions')) {
      _box = await Hive.openBox<Reconstitution>('reconstitutions');
    } else {
      _box = Hive.box<Reconstitution>('reconstitutions');
    }
  }

  Future<int> addReconstitution(Reconstitution recon) async {
    return await _box.add(recon);
  }

  Reconstitution? getByMedId(int medId) {
    try {
      return _box.values.firstWhere((recon) => recon.medId == medId);
    } on StateError {
      return null;
    }
  }

  Future<void> updateReconstitution(int key, Reconstitution recon) async {
    await _box.put(key, recon);
  }

  Future<void> deleteReconstitution(int key) async {
    await _box.delete(key);
  }

  List<Reconstitution> getReconstitutions() {
    return _box.values.toList();
  }

  Reconstitution? getReconstitution(int key) {
    return _box.get(key);
  }
}
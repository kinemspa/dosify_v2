import 'package:hive/hive.dart';
import '../models/reconstitution.dart';

class ReconstitutionRepository {
  late Box<Reconstitution> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Reconstitution>('reconstitutions');
  }

  Future<int> addReconstitution(Reconstitution recon) async {
    return await _box.add(recon);
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

  Reconstitution? getByMedId(int medId) {
    return _box.values.firstWhere((recon) => recon.medId == medId, orElse: () => null);
  }
}
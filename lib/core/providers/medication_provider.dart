import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/data/repositories/medication_repository.dart';
import 'package:dosify_v2/core/data/models/medication.dart';

final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  final repo = MedicationRepository();
  repo.init();
  return repo;
});

final medicationsProvider = FutureProvider<List<Medication>>((ref) async {
  final repo = ref.watch(medicationRepositoryProvider);
  return repo.getMedications();
});

final addMedicationProvider = FutureProvider.autoDispose.family<int, Medication>((ref, med) async {
  final repo = ref.watch(medicationRepositoryProvider);
  final key = await repo.addMedication(med);
  ref.invalidate(medicationsProvider);
  return key;
});

final deleteMedicationProvider = FutureProvider.autoDispose.family<void, int>((ref, key) async {
  final repo = ref.watch(medicationRepositoryProvider);
  await repo.deleteMedication(key);
  ref.invalidate(medicationsProvider);
});
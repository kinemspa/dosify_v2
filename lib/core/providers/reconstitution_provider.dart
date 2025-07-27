import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/data/repositories/reconstitution_repository.dart';
import 'package:dosify_v2/core/data/models/reconstitution.dart';

final reconstitutionRepositoryProvider = Provider<ReconstitutionRepository>((ref) {
  final repo = ReconstitutionRepository();
  repo.init();
  return repo;
});

final reconstitutionsProvider = FutureProvider<List<Reconstitution>>((ref) async {
  final repo = ref.watch(reconstitutionRepositoryProvider);
  return repo.getReconstitutions();
});

final addReconstitutionProvider = FutureProvider.autoDispose.family<void, Reconstitution>((ref, recon) async {
  final repo = ref.watch(reconstitutionRepositoryProvider);
  await repo.addReconstitution(recon);
  ref.invalidate(reconstitutionsProvider);
});
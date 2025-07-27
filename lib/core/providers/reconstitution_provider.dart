import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/data/repositories/reconstitution_repository.dart';
import 'package:dosify_v2/core/data/models/reconstitution.dart';

final reconstitutionRepositoryProvider = FutureProvider<ReconstitutionRepository>((ref) async {
  final repo = ReconstitutionRepository();
  await repo.init();
  return repo;
});

final reconstitutionsProvider = FutureProvider<List<Reconstitution>>((ref) async {
  final repo = await ref.watch(reconstitutionRepositoryProvider.future);
  return repo.getReconstitutions();
});

final addReconstitutionProvider = FutureProvider.autoDispose.family<void, Reconstitution>((ref, recon) async {
  final repo = await ref.watch(reconstitutionRepositoryProvider.future);
  await repo.addReconstitution(recon);
  ref.invalidate(reconstitutionsProvider);
});
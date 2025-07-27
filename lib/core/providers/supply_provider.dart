import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/data/repositories/supply_repository.dart';
import 'package:dosify_v2/core/data/models/supply.dart';

final supplyRepositoryProvider = Provider<SupplyRepository>((ref) {
  final repo = SupplyRepository();
  repo.init();
  return repo;
});

final suppliesProvider = FutureProvider<List<Supply>>((ref) async {
  final repo = ref.watch(supplyRepositoryProvider);
  return repo.getSupplies();
});

final addSupplyProvider = FutureProvider.autoDispose.family<void, Supply>((ref, supply) async {
  final repo = ref.watch(supplyRepositoryProvider);
  await repo.addSupply(supply);
  ref.invalidate(suppliesProvider);
});
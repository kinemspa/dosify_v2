import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/data/repositories/dose_log_repository.dart';
import 'package:dosify_v2/core/data/models/dose_log.dart';

final doseLogRepositoryProvider = Provider<DoseLogRepository>((ref) {
  final repo = DoseLogRepository();
  repo.init();
  return repo;
});

final doseLogsProvider = FutureProvider<List<DoseLog>>((ref) async {
  final repo = ref.watch(doseLogRepositoryProvider);
  return repo.getDoseLogs();
});

final addDoseLogProvider = FutureProvider.autoDispose.family<void, DoseLog>((ref, log) async {
  final repo = ref.watch(doseLogRepositoryProvider);
  await repo.addDoseLog(log);
  ref.invalidate(doseLogsProvider);
});
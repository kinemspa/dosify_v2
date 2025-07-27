import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/data/repositories/dose_schedule_repository.dart';
import 'package:dosify_v2/core/data/models/dose_schedule.dart';

final doseScheduleRepositoryProvider = Provider<DoseScheduleRepository>((ref) {
  final repo = DoseScheduleRepository();
  repo.init();
  return repo;
});

final doseSchedulesProvider = FutureProvider<List<DoseSchedule>>((ref) async {
  final repo = ref.watch(doseScheduleRepositoryProvider);
  return repo.getDoseSchedules();
});

final addDoseScheduleProvider = FutureProvider.autoDispose.family<void, DoseSchedule>((ref, schedule) async {
  final repo = ref.watch(doseScheduleRepositoryProvider);
  await repo.addDoseSchedule(schedule);
  ref.refresh(doseSchedulesProvider);
});
import 'package:hive/hive.dart';
import '../models/dose_schedule.dart';

class DoseScheduleRepository {
  late Box<DoseSchedule> _box;

  Future<void> init() async {
    _box = await Hive.openBox<DoseSchedule>('dose_schedules');
  }

  Future<int> addDoseSchedule(DoseSchedule schedule) async {
    return await _box.add(schedule);
  }

  List<DoseSchedule> getDoseSchedules() {
    return _box.values.toList();
  }
}
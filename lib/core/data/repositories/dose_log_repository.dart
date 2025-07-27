import 'package:hive/hive.dart';
import '../models/dose_log.dart';

class DoseLogRepository {
  late Box<DoseLog> _box;

  Future<void> init() async {
    _box = await Hive.openBox<DoseLog>('dose_logs');
  }

  Future<int> addDoseLog(DoseLog log) async {
    return await _box.add(log);
  }

  List<DoseLog> getDoseLogs() {
    return _box.values.toList();
  }

  List<DoseLog> getLogsByScheduleId(int scheduleId) {
    return _box.values.where((log) => log.scheduleId == scheduleId).toList();
  }
}
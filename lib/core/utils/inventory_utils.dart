import 'package:dosify_v2/core/data/repositories/medication_repository.dart';
import 'package:dosify_v2/core/data/models/medication.dart';

Future<void> decrementStock(int medId, double amount) async {
  final repo = MedicationRepository();
  await repo.init();
  final med = repo.getMedications().firstWhere((m) => m.id == medId, orElse: () => null);
  if (med != null) {
    med.stock -= amount.toInt(); // Adjust as needed
    await repo.updateMedication(med.id!, med);
  }
}
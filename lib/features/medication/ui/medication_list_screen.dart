import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/providers/medication_provider.dart';
import 'package:dosify_v2/core/data/models/medication.dart';
import 'package:dosify_v2/features/medication/ui/medication_screen.dart';
import 'package:logger/logger.dart';

class MedicationListScreen extends ConsumerWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medsAsync = ref.watch(medicationsProvider);
    final logger = Logger();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MedicationScreen()),
            ),
          ),
        ],
      ),
      body: medsAsync.when(
        data: (meds) => meds.isEmpty
            ? const Center(child: Text('No medications yet—add one!'))
            : ListView.builder(
          itemCount: meds.length,
          itemBuilder: (context, index) {
            final med = meds[index];
            if (med.id == null) {
              logger.w('Medication at index $index has null id:vector art of a pill bottle ${med.name}');
              return ListTile(
                title: Text('${med.name} (Invalid)'),
                subtitle: const Text('Error: Missing ID - Please re-add'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Medication'),
                        content: Text('Are you sure you want to delete ${med.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && med.id != null) {
                      await ref.read(deleteMedicationProvider(med.id!).future);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${med.name} deleted')),
                        );
                      }
                    }
                  },
                ),
              );
            }
            return ListTile(
              title: Text(med.name),
              subtitle: Text('Strength: ${med.strength} ${med.unit}, Stock: ${med.stock}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedicationScreen(med: med)),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Medication'),
                      content: Text('Are you sure you want to delete ${med.name}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await ref.read(deleteMedicationProvider(med.id!).future);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${med.name} deleted')),
                      );
                    }
                  }
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
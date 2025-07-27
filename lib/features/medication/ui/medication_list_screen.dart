import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/providers/medication_provider.dart';
import 'package:dosify_v2/core/data/models/medication.dart';
import 'package:dosify_v2/features/medication/ui/medication_screen.dart';

class MedicationListScreen extends ConsumerWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medsAsync = ref.watch(medicationsProvider);

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
            return ListTile(
              title: Text(med.name),
              subtitle: Text('Strength: ${med.strength} ${med.unit}, Stock: ${med.stock}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedicationScreen(med: med)),
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
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/providers/dose_log_provider.dart';

class GraphScreen extends ConsumerWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(doseLogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Adherence Graph')),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(child: Text('No logs yet—start tracking doses!'));
          }
          // Group by date for adherence (e.g., daily taken vs scheduled; simplify for now)
          final dataPoints = logs.asMap().entries.map((entry) {
            final index = entry.key;
            final log = entry.value;
            return FlSpot(index.toDouble(), log.amountTaken);
          }).toList();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false), // Customize for user-friendliness
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
                lineBarsData: [
                  LineChartBarData(
                    spots: dataPoints,
                    isCurved: true,
                    color: Colors.blue,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
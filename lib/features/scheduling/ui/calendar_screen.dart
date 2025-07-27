import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/providers/dose_provider.dart';
import 'package:dosify_v2/core/data/models/dose_schedule.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosesAsync = ref.watch(doseSchedulesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dose Calendar')),
      body: dosesAsync.when(
        data: (schedules) => TableCalendar(
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: DateTime.now(),
          eventLoader: (day) => schedules.where((schedule) => isSameDay(schedule.startDate, day)).toList(),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}
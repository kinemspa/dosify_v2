import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/providers/dose_provider.dart';
import 'package:dosify_v2/core/data/models/dose_schedule.dart';
import 'package:dosify_v2/core/utils/notification_utils.dart'; // New import

class DoseScreen extends ConsumerStatefulWidget {
  const DoseScreen({super.key});

  @override
  ConsumerState<DoseScreen> createState() => _DoseScreenState();
}

class _DoseScreenState extends ConsumerState<DoseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doseAmountController = TextEditingController();
  final _unitController = TextEditingController();
  Frequency _frequency = Frequency.daily;
  final List<TimeOfDay> _times = [];
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _isActive = true;
  int? _cycleWeeks;
  int? _cycleOffWeeks;
  bool _isCycling = false;
  final List<TitrationStep> _titrationSteps = [];

  void _addTime() async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) setState(() => _times.add(time));
  }

  void _addTitrationStep() {
    final periodController = TextEditingController();
    final doseController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Titration Step'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: periodController, decoration: const InputDecoration(labelText: 'Period (days)'), keyboardType: TextInputType.number),
            TextField(controller: doseController, decoration: const InputDecoration(labelText: 'Dose Amount'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (periodController.text.isNotEmpty && doseController.text.isNotEmpty) {
                setState(() {
                  _titrationSteps.add(TitrationStep(
                    period: int.parse(periodController.text),
                    doseAmount: double.parse(doseController.text),
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveDose() async {
    if (_formKey.currentState!.validate()) {
      final schedule = DoseSchedule(
        medId: 0,  // Replace with actual medId
        doseAmount: double.parse(_doseAmountController.text),
        unit: _unitController.text,
        frequency: _frequency,
        times: _times,
        startDate: _startDate,
        endDate: _endDate,
        isActive: _isActive,
        cycleWeeks: _cycleWeeks,
        cycleOffWeeks: _cycleOffWeeks,
        isCycling: _isCycling,
        titrationSteps: _titrationSteps,
      );
      await ref.read(addDoseScheduleProvider(schedule).future);
      // Schedule notification (example for first time)
      if (_times.isNotEmpty) {
        final notificationTime = DateTime(_startDate.year, _startDate.month, _startDate.day, _times[0].hour, _times[0].minute);
        await NotificationUtils.scheduleNotification(1, 'Dose Reminder', 'Time for your dose!', notificationTime);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dose Schedule saved!')));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Dose Schedule')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _doseAmountController,
                decoration: const InputDecoration(labelText: 'Dose Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Unit'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<Frequency>(
                value: _frequency,
                decoration: const InputDecoration(labelText: 'Frequency'),
                items: Frequency.values.map((f) => DropdownMenuItem(value: f, child: Text(f.toString().split('.').last))).toList(),
                onChanged: (value) => setState(() => _frequency = value!),
              ),
              ElevatedButton(onPressed: _addTime, child: const Text('Add Time')),
              ElevatedButton(onPressed: _addTitrationStep, child: const Text('Add Titration Step')),
              ElevatedButton(onPressed: _saveDose, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
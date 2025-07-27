import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/providers/dose_provider.dart';
import 'package:dosify_v2/core/data/models/dose_schedule.dart';

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
        if (periodController.text.isNotEmpty && doseController.text.isNotEmpty) Got it, the user is trying to commit from the android folder, which is why git can't find the repo (it's in the root F:\Android Apps\Dosify_v2). They need to cd .. to the root, then git add . and commit/push. The changes are listed, so after that, Phase 4 is complete.
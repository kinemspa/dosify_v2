import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/providers/supply_provider.dart';
import 'package:dosify_v2/core/providers/medication_provider.dart';
import 'package:dosify_v2/core/data/models/supply.dart';

class SupplyScreen extends ConsumerStatefulWidget {
  final Supply? supply;  // Optional for edit

  const SupplyScreen({super.key, this.supply});

  @override
  ConsumerState<SupplyScreen> createState() => _SupplyScreenState();
}

class _SupplyScreenState extends ConsumerState<SupplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitController = TextEditingController();
  final _stockController = TextEditingController();
  final _thresholdController = TextEditingController();
  int? _linkedMedId;

  @override
  void initState() {
    super.initState();
    if (widget.supply != null) {
      _nameController.text = widget.supply!.name;
      _unitController.text = widget.supply!.unit;
      _stockController.text = widget.supply!.stock.toString();
      _thresholdController.text = widget.supply!.lowStockThreshold.toString();
      _linkedMedId = widget.supply!.linkedMedId;
    }
  }

  Future<void> _saveSupply() async {
    if (_formKey.currentState!.validate()) {
      if (widget.supply == null) {
        final supply = Supply(
          name: _nameController.text,
          unit: _unitController.text,
          stock: int.parse(_stockController.text),
          lowStockThreshold: int.parse(_thresholdController.text),
          linkedMedId: _linkedMedId,
        );
        await ref.read(addSupplyProvider(supply).future);
      } else {
        widget.supply!.name = _nameController.text;
        widget.supply!.unit = _unitController.text;
        widget.supply!.stock = int.parse(_stockController.text);
        widget.supply!.lowStockThreshold = int.parse(_thresholdController.text);
        widget.supply!.linkedMedId = _linkedMedId;
        await widget.supply!.save();
        ref.invalidate(suppliesProvider);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Supply saved!')));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final medsAsync = ref.watch(medicationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.supply == null ? 'Add Supply' : 'Edit Supply')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Unit'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _thresholdController,
                decoration: const InputDecoration(labelText: 'Low Stock Threshold'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              medsAsync.when(
                data: (meds) => DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Linked Medication (optional)'),
                  value: _linkedMedId,
                  items: meds.map((med) => DropdownMenuItem(value: med.id, child: Text(med.name))).toList(),
                  onChanged: (value) => setState(() => _linkedMedId = value),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              ElevatedButton(
                onPressed: _saveSupply,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/providers/medication_provider.dart';
import 'package:dosify_v2/core/providers/reconstitution_provider.dart';
import 'package:dosify_v2/core/data/models/medication.dart';
import 'package:dosify_v2/core/data/models/reconstitution.dart';
import 'package:dosify_v2/core/utils/reconstitution_utils.dart';
import 'package:dosify_v2/core/data/repositories/medication_repository.dart';
import 'package:dosify_v2/core/data/repositories/reconstitution_repository.dart';

class MedicationScreen extends ConsumerStatefulWidget {
  final Medication? med;

  const MedicationScreen({super.key, this.med});

  @override
  ConsumerState<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends ConsumerState<MedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _strengthController = TextEditingController();
  final _unitController = TextEditingController();
  final _stockController = TextEditingController();
  final _thresholdController = TextEditingController();
  MedicationType _type = MedicationType.tablet;
  bool _reconstitution = false;
  final _powderAmountController = TextEditingController();
  final _solventVolumeController = TextEditingController();
  final _desiredConcentrationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.med != null) {
      _nameController.text = widget.med!.name;
      _type = widget.med!.type;
      _strengthController.text = widget.med!.strength.toString();
      _unitController.text = widget.med!.unit;
      _stockController.text = widget.med!.stock.toString();
      _thresholdController.text = widget.med!.lowStockThreshold.toString();
      _reconstitution = widget.med!.reconstitution ?? false;
      final reconRepo = ref.read(reconstitutionRepositoryProvider);
      final recon = reconRepo.getByMedId(widget.med!.id!);
      if (recon != null) {
        _powderAmountController.text = recon.powderAmount.toString();
        _solventVolumeController.text = recon.solventVolume.toString();
        _desiredConcentrationController.text = recon.desiredConcentration?.toString() ?? '';
      }
    }
  }

  Future<void> _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      try {
        final med = Medication(
          name: _nameController.text,
          type: _type,
          strength: double.parse(_strengthController.text),
          unit: _unitController.text,
          stock: int.parse(_stockController.text),
          lowStockThreshold: int.parse(_thresholdController.text),
          reconstitution: _reconstitution,
        );

        if (widget.med == null) {
          final key = await ref.read(addMedicationProvider(med).future);
          if (_reconstitution) {
            final recon = Reconstitution(
              powderAmount: double.parse(_powderAmountController.text),
              solventVolume: double.parse(_solventVolumeController.text),
              desiredConcentration: double.tryParse(_desiredConcentrationController.text) ?? 0,
              calculatedVolumePerDose: calculateVolumePerDose(
                double.parse(_powderAmountController.text),
                double.parse(_solventVolumeController.text),
                double.tryParse(_desiredConcentrationController.text) ?? 0,
              ),
              medId: key,
            );
            await ref.read(addReconstitutionProvider(recon).future);
          }
        } else {
          med.id = widget.med!.id;
          final medRepo = ref.read(medicationRepositoryProvider);
          await medRepo.updateMedication(widget.med!.id!, med);
          final reconRepo = ref.read(reconstitutionRepositoryProvider);
          if (_reconstitution) {
            Reconstitution? recon = reconRepo.getByMedId(widget.med!.id!);
            if (recon == null) {
              recon = Reconstitution(
                powderAmount: double.parse(_powderAmountController.text.isEmpty ? '0' : _powderAmountController.text),
                solventVolume: double.parse(_solventVolumeController.text.isEmpty ? '0' : _solventVolumeController.text),
                desiredConcentration: double.tryParse(_desiredConcentrationController.text) ?? 0,
                medId: widget.med!.id,
              );
              await reconRepo.addReconstitution(recon);
            } else {
              recon.powderAmount = double.parse(_powderAmountController.text);
              recon.solventVolume = double.parse(_solventVolumeController.text);
              recon.desiredConcentration = double.tryParse(_desiredConcentrationController.text) ?? recon.desiredConcentration;
            }
            recon.calculatedVolumePerDose = calculateVolumePerDose(
              recon.powderAmount,
              recon.solventVolume,
              recon.desiredConcentration ?? 0,
            );
            await reconRepo.updateReconstitution(recon.key as int, recon);
          } else if (widget.med!.reconstitution == true) {
            final recon = reconRepo.getByMedId(widget.med!.id!);
            if (recon != null) await reconRepo.deleteReconstitution(recon.key as int);
          }
          ref.invalidate(medicationsProvider);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medication saved!')));
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
        }
      }
    }
  }

  String? _numberValidator(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (double.tryParse(value) == null) return 'Invalid number';
    return null;
  }

  String? _intValidator(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (int.tryParse(value) == null) return 'Invalid integer';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.med == null ? 'Add Medication' : 'Edit Medication')),
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
              DropdownButtonFormField<MedicationType>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: MedicationType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.toString().split('.').last))).toList(),
                onChanged: (value) => setState(() => _type = value!),
              ),
              TextFormField(
                controller: _strengthController,
                decoration: const InputDecoration(labelText: 'Strength'),
                keyboardType: TextInputType.number,
                validator: _numberValidator,
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
                validator: _intValidator,
              ),
              TextFormField(
                controller: _thresholdController,
                decoration: const InputDecoration(labelText: 'Low Stock Threshold'),
                keyboardType: TextInputType.number,
                validator: _intValidator,
              ),
              SwitchListTile(
                title: const Text('Reconstitution'),
                value: _reconstitution,
                onChanged: (value) => setState(() => _reconstitution = value),
              ),
              if (_reconstitution) ...[
                TextFormField(
                  controller: _powderAmountController,
                  decoration: const InputDecoration(labelText: 'Powder Amount'),
                  keyboardType: TextInputType.number,
                  validator: _numberValidator,
                ),
                TextFormField(
                  controller: _solventVolumeController,
                  decoration: const InputDecoration(labelText: 'Solvent Volume'),
                  keyboardType: TextInputType.number,
                  validator: _numberValidator,
                ),
                TextFormField(
                  controller: _desiredConcentrationController,
                  decoration: const InputDecoration(labelText: 'Desired Concentration'),
                  keyboardType: TextInputType.number,
                  validator: _numberValidator,
                ),
              ],
              ElevatedButton(
                onPressed: _saveMedication,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
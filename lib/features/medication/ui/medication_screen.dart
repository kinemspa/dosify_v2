import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/providers/medication_provider.dart';
import 'package:dosify_v2/core/providers/reconstitution_provider.dart';
import 'package:dosify_v2/core/data/models/medication.dart';
import 'package:dosify_v2/core/data/models/reconstitution.dart';
import 'package:dosify_v2/core/utils/reconstitution_utils.dart';

class MedicationScreen extends ConsumerStatefulWidget {
  final Medication? med;  // Optional for edit

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
      // Load reconstitution if exists (from repo)
      final recon = ref.read(reconstitutionRepositoryProvider).getByMedId(widget.med!.id!);
      if (recon != null) {
        _powderAmountController.text = recon.powderAmount.toString();
        _solventVolumeController.text = recon.solventVolume.toString();
        _desiredConcentrationController.text = recon.desiredConcentration?.toString() ?? '';
      }
    }
  }

  Future<void> _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      final med = Medication(
        id: widget.med?.id,
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
            desiredConcentration: double.parse(_desiredConcentrationController.text),
            calculatedVolumePerDose: calculateVolumePerDose(
              double.parse(_powderAmountController.text),
              double.parse(_solventVolumeController.text),
              double.parse(_desiredConcentrationController.text),
            ),
            medId: key,
          );
          ref.read(addReconstitutionProvider(recon));
        }
      } else {
        await widget.med!.save();  // Hive update
        if (_reconstitution) {
          final recon = ref.read(reconstitutionRepositoryProvider).getByMedId(widget.med!.id!) ?? Reconstitution(powderAmount: 0, solventVolume: 0);
          recon.powderAmount = double.parse(_powderAmountController.text);
          recon.solventVolume = double.parse(_solventVolumeController.text);
          recon.desiredConcentration = double.parse(_desiredConcentrationController.text);
          recon.calculatedVolumePerDose = calculateVolumePerDose(
            recon.powderAmount,
            recon.solventVolume,
            recon.desiredConcentration!,
          );
          recon.medId = widget.med!.id;
          if (recon.key == null) {
            await ref.read(addReconstitutionProvider(recon).future);
          } else {
            await recon.save();
          }
        } else if (widget.med!.reconstitution == true) {
          final recon = ref.read(reconstitutionRepositoryProvider).getByMedId(widget.med!.id!);
          if (recon != null) recon.delete();
        }
        ref.refresh(medicationsProvider);
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medication saved!')));
      Navigator.pop(context);
    }
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
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _solventVolumeController,
                  decoration: const InputDecoration(labelText: 'Solvent Volume'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _desiredConcentrationController,
                  decoration: const InputDecoration(labelText: 'Desired Concentration'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
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
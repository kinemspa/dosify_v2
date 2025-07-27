import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dosify_v2/core/providers/medication_provider.dart';
import 'package:dosify_v2/core/providers/reconstitution_provider.dart';
import 'package:dosify_v2/core/data/models/medication.dart';
import 'package:dosify_v2/core/data/models/reconstitution.dart';
import 'package:dosify_v2/core/utils/reconstitution_utils.dart';
import 'package:dosify_v2/core/data/repositories/medication_repository.dart';
import 'package:dosify_v2/core/data/repositories/reconstitution_repository.dart';
import 'package:logger/logger.dart';

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
  String? _selectedUnit; // For tablet dropdown
  bool _reconstitution = false;
  final _powderAmountController = TextEditingController();
  final _solventVolumeController = TextEditingController();
  final _desiredConcentrationController = TextEditingController();
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    _logger.d('Initializing MedicationScreen, med: ${widget.med}');
    if (widget.med != null) {
      _logger.d('Populating form for med: ${widget.med!.name}, id: ${widget.med!.id}');
      _nameController.text = widget.med!.name;
      _type = widget.med!.type;
      _strengthController.text = widget.med!.strength.toString();
      _unitController.text = widget.med!.unit;
      _selectedUnit = widget.med!.unit == 'mg' || widget.med!.unit == 'mcg' ? widget.med!.unit : null;
      _stockController.text = widget.med!.stock.toString();
      _thresholdController.text = widget.med!.lowStockThreshold.toString();
      _reconstitution = widget.med!.reconstitution ?? false;
      if (widget.med!.id != null) {
        _fetchReconstitution();
      } else {
        _logger.w('Medication id is null for edit');
      }
    }
  }

  Future<void> _fetchReconstitution() async {
    try {
      final reconRepo = await ref.read(reconstitutionRepositoryProvider.future);
      final recon = reconRepo.getByMedId(widget.med!.id!);
      if (recon != null && mounted) {
        setState(() {
          _powderAmountController.text = recon.powderAmount.toString();
          _solventVolumeController.text = recon.solventVolume.toString();
          _desiredConcentrationController.text = recon.desiredConcentration?.toString() ?? '';
        });
      }
    } catch (e) {
      _logger.e('Failed to fetch reconstitution: $e');
    }
  }

  Future<void> _saveMedication() async {
    _logger.d('Attempting to save medication');
    if (_formKey.currentState!.validate()) {
      try {
        final med = Medication(
          name: _nameController.text,
          type: _type,
          strength: double.parse(_strengthController.text),
          unit: _type == MedicationType.tablet ? _selectedUnit! : _unitController.text,
          stock: int.parse(_stockController.text),
          lowStockThreshold: int.parse(_thresholdController.text),
          reconstitution: _reconstitution,
        );

        if (widget.med == null) {
          _logger.d('Adding new medication');
          final key = await ref.read(addMedicationProvider(med).future);
          _logger.d('Medication added with key: $key');
          if (_reconstitution) {
            final reconRepo = await ref.read(reconstitutionRepositoryProvider.future);
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
            await reconRepo.addReconstitution(recon);
            _logger.d('Reconstitution added for medId: $key');
          }
        } else if (widget.med!.id != null) {
          _logger.d('Updating medication with id: ${widget.med!.id}');
          med.id = widget.med!.id;
          final medRepo = ref.read(medicationRepositoryProvider);
          await medRepo.updateMedication(widget.med!.id!, med);
          final reconRepo = await ref.read(reconstitutionRepositoryProvider.future);
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
              _logger.d('New reconstitution added for medId: ${widget.med!.id}');
            } else {
              recon.powderAmount = double.parse(_powderAmountController.text);
              recon.solventVolume = double.parse(_solventVolumeController.text);
              recon.desiredConcentration = double.tryParse(_desiredConcentrationController.text) ?? recon.desiredConcentration;
              recon.calculatedVolumePerDose = calculateVolumePerDose(
                recon.powderAmount,
                recon.solventVolume,
                recon.desiredConcentration ?? 0,
              );
              await reconRepo.updateReconstitution(recon.key as int, recon);
              _logger.d('Reconstitution updated for medId: ${widget.med!.id}');
            }
          } else if (widget.med!.reconstitution == true) {
            final recon = reconRepo.getByMedId(widget.med!.id!);
            if (recon != null) {
              await reconRepo.deleteReconstitution(recon.key as int);
              _logger.d('Reconstitution deleted for medId: ${widget.med!.id}');
            }
          }
          ref.invalidate(medicationsProvider);
        } else {
          _logger.e('Cannot update medication: id is null');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Save failed: Medication ID is missing')));
            return;
          }
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medication saved successfully!')));
          await Future.delayed(const Duration(seconds: 2)); // Delay to show SnackBar
          if (mounted) Navigator.pop(context);
        }
      } catch (e) {
        _logger.e('Save failed: $e');
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
                onChanged: (value) => setState(() {
                  _type = value!;
                  _reconstitution = value == MedicationType.injection ? _reconstitution : false; // Hide for non-injection
                }),
              ),
              if (_type == MedicationType.tablet) ...[
                TextFormField(
                  controller: _strengthController,
                  decoration: const InputDecoration(labelText: 'Strength'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Integer only
                  validator: _intValidator,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedUnit,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  items: ['mg', 'mcg'].map((unit) => DropdownMenuItem(value: unit, child: Text(unit))).toList(),
                  onChanged: (value) => setState(() => _selectedUnit = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
              ] else ...[
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
              ],
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Integer only
                validator: _intValidator,
              ),
              TextFormField(
                controller: _thresholdController,
                decoration: const InputDecoration(labelText: 'Low Stock Threshold'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Integer only
                validator: _intValidator,
              ),
              if (_type == MedicationType.injection) ...[
                SwitchListTile(
                  title: const Text('Reconstitution'),
                  value: _reconstitution,
                  onChanged: (value) => setState(() => _reconstitution = value),
                ),
                if (_reconstitution) ...[
                  TextFormField(
                    controller: _powderAmountController,
                    decoration: const InputDecoration(labelText: 'Powder Amount (e.g., mg)'),
                    keyboardType: TextInputType.number,
                    validator: _numberValidator,
                  ),
                  TextFormField(
                    controller: _solventVolumeController,
                    decoration: const InputDecoration(labelText: 'Solvent Volume (mL)'),
                    keyboardType: TextInputType.number,
                    validator: _numberValidator,
                  ),
                  TextFormField(
                    controller: _desiredConcentrationController,
                    decoration: const InputDecoration(labelText: 'Desired Concentration (e.g., mg/mL)'),
                    keyboardType: TextInputType.number,
                    validator: _numberValidator,
                  ),
                ],
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
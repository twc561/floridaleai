
import 'dart:math';
import 'package:flutter/material.dart';

// Enum to represent different road surfaces for clarity and type safety.
enum RoadSurface { asphalt, concrete, gravel, ice }

class SpeedCalculatorScreen extends StatefulWidget {
  const SpeedCalculatorScreen({super.key});

  @override
  SpeedCalculatorScreenState createState() => SpeedCalculatorScreenState();
}

class SpeedCalculatorScreenState extends State<SpeedCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skidLengthController = TextEditingController();

  // Use the enum for the current surface selection.
  RoadSurface _selectedSurface = RoadSurface.asphalt;
  double _brakingEfficiency = 1.0; // 100%
  
  // Use a ValueNotifier for the result to efficiently update only the widget that displays it.
  final ValueNotifier<double> _calculatedSpeed = ValueNotifier<double>(0.0);
  
  // A flag to control the enabled state of the calculate button.
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _skidLengthController.addListener(() {
      setState(() {
        _isFormValid = _formKey.currentState?.validate() ?? false;
      });
    });
  }

  // A map to get the drag factor from the selected RoadSurface enum.
  double get _dragFactor {
    switch (_selectedSurface) {
      case RoadSurface.asphalt:
        return 0.75;
      case RoadSurface.concrete:
        return 0.90;
      case RoadSurface.gravel:
        return 0.55;
      case RoadSurface.ice:
        return 0.35;
    }
  }

  void _calculateSpeed() {
    if (_formKey.currentState!.validate()) {
      final skidLength = double.parse(_skidLengthController.text);
      // Formula: S = sqrt(30 * D * f * n)
      final speed = sqrt(30 * skidLength * _dragFactor * _brakingEfficiency);
      _calculatedSpeed.value = speed;
    }
  }

  @override
  void dispose() {
    _skidLengthController.dispose();
    _calculatedSpeed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(),
              const SizedBox(height: 24),
              _buildRoadSurfaceSelector(theme),
              const SizedBox(height: 24),
              _buildBrakingEfficiencySelector(theme),
              const SizedBox(height: 32),
              _buildCalculateButton(theme),
              const SizedBox(height: 32),
              _buildResultDisplay(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return TextFormField(
      controller: _skidLengthController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Skid Mark Length (feet)',
        hintText: 'e.g., 85.5',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.linear_scale),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a skid length';
        }
        if (double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Please enter a valid positive number';
        }
        return null;
      },
    );
  }

  Widget _buildRoadSurfaceSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Road Surface', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<RoadSurface>(
          segments: const [
            ButtonSegment(value: RoadSurface.asphalt, label: Text('Asphalt')),
            ButtonSegment(value: RoadSurface.concrete, label: Text('Concrete')),
            ButtonSegment(value: RoadSurface.gravel, label: Text('Gravel')),
            ButtonSegment(value: RoadSurface.ice, label: Text('Ice')),
          ],
          selected: {_selectedSurface},
          onSelectionChanged: (Set<RoadSurface> newSelection) {
            setState(() {
              _selectedSurface = newSelection.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBrakingEfficiencySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Braking Efficiency', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<double>(
          segments: const [
            ButtonSegment(value: 1.0, label: Text('100%')),
            ButtonSegment(value: 0.9, label: Text('90%')),
            ButtonSegment(value: 0.8, label: Text('80%')),
            ButtonSegment(value: 0.7, label: Text('70%')),
          ],
          selected: {_brakingEfficiency},
          onSelectionChanged: (Set<double> newSelection) {
            setState(() {
              _brakingEfficiency = newSelection.first;
            });
          },
        ),
      ],
    );
  }
  
  Widget _buildCalculateButton(ThemeData theme) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.calculate),
      onPressed: _isFormValid ? _calculateSpeed : null, // Button is disabled if form is not valid
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        textStyle: theme.textTheme.titleMedium,
      ),
      label: const Text('Calculate Speed'),
    );
  }

  Widget _buildResultDisplay(ThemeData theme) {
    // Use a ValueListenableBuilder to only rebuild this widget when the speed changes.
    return ValueListenableBuilder<double>(
      valueListenable: _calculatedSpeed,
      builder: (context, speed, child) {
        if (speed <= 0) {
          return const SizedBox.shrink(); // Don't show anything if speed is 0
        }
        return Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Estimated Speed', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  '${speed.toStringAsFixed(1)} MPH',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


import 'package:flutter/material.dart';

class HgnTestScreen extends StatefulWidget {
  const HgnTestScreen({super.key});

  @override
  HgnTestScreenState createState() => HgnTestScreenState();
}

class HgnTestScreenState extends State<HgnTestScreen> {
  // A map to hold the checked state of each clue for each eye.
  final Map<String, bool> _clues = {
    'lack_of_smooth_pursuit_left': false,
    'lack_of_smooth_pursuit_right': false,
    'distinct_nystagmus_at_max_deviation_left': false,
    'distinct_nystagmus_at_max_deviation_right': false,
    'onset_of_nystagmus_prior_to_45_left': false,
    'onset_of_nystagmus_prior_to_45_right': false,
  };

  int get _totalClues {
    return _clues.values.where((v) => v).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('HGN Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructions(theme),
            const SizedBox(height: 24),
            _buildClueChecklist(theme),
            const SizedBox(height: 24),
            _buildResults(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions(ThemeData theme) {
    return _buildExpandableCard(
      theme: theme,
      title: 'Instructions',
      icon: Icons.integration_instructions,
      children: [
        _buildInstructionStep("1. Preparation", "Check for eyeglasses and equal pupil size. Position the stimulus 12-15 inches from the subject's nose and slightly above eye level."),
        _buildInstructionStep("2. Lack of Smooth Pursuit", "Move the stimulus smoothly from the center to the side (approx. 2 seconds). Check for a lack of smooth pursuit in each eye."),
        _buildInstructionStep("3. Distinct Nystagmus at Maximum Deviation", "Hold the stimulus at maximum deviation for a minimum of 4 seconds. Check for distinct and sustained nystagmus in each eye."),
        _buildInstructionStep("4. Onset of Nystagmus Prior to 45 Degrees", "Move the stimulus slowly (approx. 4 seconds) to a 45-degree angle. Check for the onset of nystagmus prior to 45 degrees in each eye."),
        _buildInstructionStep("5. Vertical Gaze Nystagmus", "Raise the stimulus until the eyes are elevated as far as possible. Hold for approximately 4 seconds. Check for VGN."),
      ],
    );
  }
  
  Widget _buildClueChecklist(ThemeData theme) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Clue Checklist", style: theme.textTheme.titleLarge),
            const Divider(),
            _buildClueRow('Lack of Smooth Pursuit', 'lack_of_smooth_pursuit'),
            _buildClueRow('Distinct Nystagmus at Max Deviation', 'distinct_nystagmus_at_max_deviation'),
            _buildClueRow('Onset of Nystagmus Prior to 45°', 'onset_of_nystagmus_prior_to_45'),
          ],
        ),
      ),
    );
  }

  Widget _buildClueRow(String title, String keyPrefix) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
        Row(
          children: [
            const Text('L'),
            Checkbox(
              value: _clues['${keyPrefix}_left'],
              onChanged: (val) => setState(() => _clues['${keyPrefix}_left'] = val!),
            ),
            const Text('R'),
            Checkbox(
              value: _clues['${keyPrefix}_right'],
              onChanged: (val) => setState(() => _clues['${keyPrefix}_right'] = val!),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildResults(ThemeData theme) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Clues:', style: theme.textTheme.titleLarge),
            Text(
              '$_totalClues / 6',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: _totalClues >= 4 ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ExpansionTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.titleLarge),
        childrenPadding: const EdgeInsets.all(16.0),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
  
  Widget _buildInstructionStep(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}

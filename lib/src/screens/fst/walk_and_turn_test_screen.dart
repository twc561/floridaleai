
import 'package:flutter/material.dart';

class WalkAndTurnTestScreen extends StatefulWidget {
  const WalkAndTurnTestScreen({super.key});

  @override
  WalkAndTurnTestScreenState createState() => WalkAndTurnTestScreenState();
}

class WalkAndTurnTestScreenState extends State<WalkAndTurnTestScreen> {
  // A map to hold the checked state of each clue.
  final Map<String, bool> _clues = {
    'instruction_starts_too_soon': false,
    'instruction_loses_balance': false,
    'walking_stops': false,
    'walking_misses_heel_toe': false,
    'walking_steps_off_line': false,
    'walking_raises_arms': false,
    'turn_improper': false,
    'turn_wrong_number_of_steps': false,
  };
  
  int get _totalClues {
    return _clues.values.where((v) => v).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk-and-Turn Test'),
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
        _buildInstructionStep("1. Instruction Stage", "Place your left foot on the line. Place your right foot on the line ahead of the left foot, with the heel of your right foot touching the toe of your left foot. Keep your arms at your sides. Do not start until I tell you to."),
        _buildInstructionStep("2. Walking Stage", "When I tell you to start, take nine heel-to-toe steps on the line. After the ninth step, keep your front foot on the line and turn, taking a series of small steps. Then, take nine heel-to-toe steps back. Count your steps out loud. Keep your arms at your sides. Watch your feet at all times."),
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
            Text("Clue Checklist (2 or more = impairment)", style: theme.textTheme.titleLarge),
            const Divider(),
            _buildClueCheckbox('Starts too soon', 'instruction_starts_too_soon'),
            _buildClueCheckbox('Loses balance during instructions', 'instruction_loses_balance'),
            const Divider(),
            _buildClueCheckbox('Stops while walking', 'walking_stops'),
            _buildClueCheckbox('Misses heel-to-toe', 'walking_misses_heel_toe'),
            _buildClueCheckbox('Steps off the line', 'walking_steps_off_line'),
            _buildClueCheckbox('Raises arms for balance', 'walking_raises_arms'),
            _buildClueCheckbox('Improper turn', 'turn_improper'),
            _buildClueCheckbox('Wrong number of steps', 'turn_wrong_number_of_steps'),
          ],
        ),
      ),
    );
  }

  Widget _buildClueCheckbox(String title, String key) {
    return CheckboxListTile(
      title: Text(title),
      value: _clues[key],
      onChanged: (val) => setState(() => _clues[key] = val!),
      controlAffinity: ListTileControlAffinity.leading,
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
              '$_totalClues / 8',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: _totalClues >= 2 ? Colors.red : Colors.green,
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

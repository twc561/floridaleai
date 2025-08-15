
import 'dart:async';
import 'package:flutter/material.dart';

class OneLegStandTestScreen extends StatefulWidget {
  const OneLegStandTestScreen({super.key});

  @override
  OneLegStandTestScreenState createState() => OneLegStandTestScreenState();
}

class OneLegStandTestScreenState extends State<OneLegStandTestScreen> {
  Timer? _timer;
  int _seconds = 30;
  bool _isRunning = false;

  final Map<String, bool> _clues = {
    'sways': false,
    'uses_arms': false,
    'hops': false,
    'puts_foot_down': false,
  };

  int get _totalClues {
    return _clues.values.where((v) => v).length;
  }

  void _startTimer() {
    if (_isRunning) return;
    _seconds = 30;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }
  
  void _resetTimer() {
    _stopTimer();
    setState(() => _seconds = 30);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('One-Leg Stand Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructions(theme),
            const SizedBox(height: 24),
            _buildTimer(theme),
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
        _buildInstructionStep("1. Instruction Stage", "Stand with your feet together and your arms at your sides. Do not start until I tell you to."),
        _buildInstructionStep("2. Balance & Counting Stage", "When I tell you to start, raise one leg, either leg, approximately six inches off the ground, foot pointed out. Keep both legs straight. While holding that position, count out loud: one thousand-one, one thousand-two, one thousand-three, and so on, until told to stop."),
      ],
    );
  }

  Widget _buildTimer(ThemeData theme) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('30 Second Timer', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('$_seconds', style: theme.textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _startTimer, child: const Text('Start')),
                ElevatedButton(onPressed: _stopTimer, child: const Text('Stop')),
                ElevatedButton(onPressed: _resetTimer, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
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
            _buildClueCheckbox('Sways while balancing', 'sways'),
            _buildClueCheckbox('Uses arms for balance', 'uses_arms'),
            _buildClueCheckbox('Hops to maintain balance', 'hops'),
            _buildClueCheckbox('Puts foot down', 'puts_foot_down'),
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
              '$_totalClues / 4',
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

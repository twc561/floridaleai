import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/field_simulator/scenario_info.dart';

class ScenarioSelectionScreen extends StatelessWidget {
  const ScenarioSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Simulator Scenarios'),
      ),
      body: ListView.builder(
        itemCount: scenarioLibrary.length,
        itemBuilder: (context, index) {
          final scenario = scenarioLibrary[index];
          return _ScenarioCard(scenario: scenario);
        },
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final ScenarioInfo scenario;

  const _ScenarioCard({required this.scenario});

  Color _getDifficultyColor(ScenarioDifficulty difficulty) {
    switch (difficulty) {
      case ScenarioDifficulty.easy:
        return Colors.green;
      case ScenarioDifficulty.medium:
        return Colors.amber;
      case ScenarioDifficulty.hard:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scenario.title,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                scenario.difficulty.toString().split('.').last.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: _getDifficultyColor(scenario.difficulty),
            ),
            const SizedBox(height: 12),
            Text(
              scenario.briefing,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () {
                  // Pass the entire scenario object to the simulator screen.
                  GoRouter.of(context).push('/simulator/chat', extra: scenario);
                },
                child: const Text('Start Simulation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

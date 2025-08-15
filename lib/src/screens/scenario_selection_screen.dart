
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/data/scenario_data.dart';

class ScenarioSelectionScreen extends StatelessWidget {
  const ScenarioSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scenarios = getScenarios(); // Fetch the static list of scenarios
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Training Simulator'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: scenarios.length,
        itemBuilder: (context, index) {
          final scenario = scenarios[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(scenario.title, style: theme.textTheme.titleLarge),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  scenario.briefing,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to the simulator screen with the selected scenario
                GoRouter.of(context).push('/field-simulator', extra: scenario);
              },
            ),
          );
        },
      ),
    );
  }
}

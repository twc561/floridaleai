import 'package:flutter/material.dart';
import 'package:myapp/src/models/field_simulator/report_card.dart';

class ScenarioSummaryScreen extends StatelessWidget {
  final ReportCard reportCard;

  const ScenarioSummaryScreen({super.key, required this.reportCard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Report Card'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeader(theme),
          const SizedBox(height: 24),
          _buildSectionTitle(theme, 'Learning Objectives'),
          const SizedBox(height: 8),
          ...reportCard.learningObjectives.map(
            (objective) => Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(objective),
              ),
            ),
          ),
          const Divider(height: 32),
          _buildSectionTitle(theme, 'Key Actions & Performance'),
          const SizedBox(height: 8),
          ...reportCard.performanceNotes.map(
            (note) => Card(
              color: theme.colorScheme.secondaryContainer,
              child: ListTile(
                leading: const Icon(Icons.comment),
                title: Text(note),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    IconData icon;
    Color color;
    String text;

    switch (reportCard.overallPerformance) {
      case OverallPerformance.excellent:
        icon = Icons.star;
        color = Colors.green;
        text = 'Excellent';
        break;
      case OverallPerformance.good:
        icon = Icons.check_circle;
        color = Colors.blue;
        text = 'Good';
        break;
      case OverallPerformance.needsImprovement:
        icon = Icons.warning;
        color = Colors.amber;
        text = 'Needs Improvement';
        break;
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 48),
            const SizedBox(height: 8),
            Text(
              'Overall Performance: $text',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              reportCard.scenarioTitle,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

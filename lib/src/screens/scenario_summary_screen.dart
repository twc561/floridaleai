
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/field_simulator/report_card.dart';

class ScenarioSummaryScreen extends StatelessWidget {
  final ReportCard reportCard;
  const ScenarioSummaryScreen({super.key, required this.reportCard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGoodPerformance = reportCard.overallPerformance == OverallPerformance.excellent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scenario Report Card'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSummaryCard(theme, isGoodPerformance),
          const SizedBox(height: 24),
          _buildSectionHeader(theme, 'Learning Objectives'),
          ...reportCard.learningObjectives.map((item) => _buildListItem(item)),
          const SizedBox(height: 24),
          _buildSectionHeader(theme, 'Performance Notes'),
          ...reportCard.performanceNotes.map((item) => _buildListItem(item, isNote: true)),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.article_outlined),
              label: const Text('Generate Incident Report'),
              onPressed: () {
                // Navigate to the new report screen, passing the report card
                GoRouter.of(context).push('/report-generation', extra: reportCard);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => GoRouter.of(context).go('/scenario-selection'),
              child: const Text('Return to Scenarios'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme, bool isGoodPerformance) {
    return Card(
      elevation: 4,
      color: isGoodPerformance ? Colors.green.shade50 : Colors.orange.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              isGoodPerformance ? Icons.check_circle_outline : Icons.warning_amber_rounded,
              size: 48,
              color: isGoodPerformance ? Colors.green.shade700 : Colors.orange.shade700,
            ),
            const SizedBox(height: 16),
            Text(
              reportCard.scenarioTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Overall Performance: ${reportCard.overallPerformance.name}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isGoodPerformance ? Colors.green.shade800 : Colors.orange.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: theme.textTheme.titleLarge,
      ),
    );
  }

  Widget _buildListItem(String item, {bool isNote = false}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isNote ? Icons.feedback_outlined : Icons.school_outlined,
              size: 20,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(item)),
          ],
        ),
      ),
    );
  }
}

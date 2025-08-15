
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/data/case_law_data.dart';
import '../models/statute.dart';

class StatuteDetailScreen extends StatelessWidget {
  final Statute statute;

  const StatuteDetailScreen({super.key, required this.statute});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(statute.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statute.title,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(statute.severity, style: textTheme.labelLarge),
              backgroundColor: theme.colorScheme.secondaryContainer,
            ),
            const SizedBox(height: 16),
            Text(
              statute.content,
              style: textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildExpandableSection(
              theme: theme,
              title: 'Subsections',
              icon: Icons.functions,
              children: statute.subsections.entries
                  .map((e) => _buildDefinitionCard(e.key, e.value, theme))
                  .toList(),
            ),
            _buildExpandableSection(
              theme: theme,
              title: 'Enhancements',
              icon: Icons.arrow_upward,
              children:
                  statute.enhancements.map((e) => _buildListItem(e)).toList(),
            ),
            _buildExpandableSection(
              theme: theme,
              title: 'Real-World Examples',
              icon: Icons.lightbulb_outline,
              children: statute.examples.map((e) => _buildListItem(e)).toList(),
            ),
            _buildExpandableSection(
              theme: theme,
              title: 'Related Case Law',
              icon: Icons.gavel,
              children: statute.relatedCaseLaw
                  .map((e) => _buildCaseLawLink(context, e))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 1.0,
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

  Widget _buildDefinitionCard(String term, String definition, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyLarge,
          children: <TextSpan>[
            TextSpan(
                text: '$term: ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: definition),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildCaseLawLink(BuildContext context, String caseTitle) {
    final caseItem = caseLawMap[caseTitle];
    if (caseItem == null) {
      return ListTile(
        title: Text(caseTitle),
        subtitle: const Text('Case not found'),
      );
    }
    return ListTile(
      title: Text(caseTitle),
      subtitle: Text(caseItem.citation, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        GoRouter.of(context).push('/case-law/details', extra: caseItem);
      },
    );
  }
}

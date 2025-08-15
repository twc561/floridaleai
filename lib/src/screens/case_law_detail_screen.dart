
import 'package:flutter/material.dart';
import 'package:myapp/src/models/case_law.dart';

class CaseLawDetailScreen extends StatelessWidget {
  final CaseLaw caseItem;
  const CaseLawDetailScreen({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(caseItem.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const Divider(height: 32),
            _buildSection("Summary", caseItem.summary, theme),
            const SizedBox(height: 24),
            _buildSection("Legal Analysis", caseItem.fullText, theme),
            const SizedBox(height: 24),
            _buildKeywords(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caseItem.title,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '${caseItem.citation} (${caseItem.court}, ${caseItem.date})',
          style: theme.textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SelectableText(
          content,
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Widget _buildKeywords(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Keywords", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: caseItem.keywords.map((keyword) {
            return Chip(
              label: Text(keyword),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            );
          }).toList(),
        ),
      ],
    );
  }
}

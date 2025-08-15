
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/data/legal_guides_data.dart';

class LegalGuidesScreen extends StatelessWidget {
  const LegalGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal Guides'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: legalGuides.length,
        itemBuilder: (context, index) {
          final guide = legalGuides[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: ListTile(
              leading: Icon(guide.icon, color: theme.colorScheme.primary, size: 40),
              title: Text(guide.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Text(guide.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (guide.id == 'ai-search-and-seizure-advisor') {
                  context.go('/legal-guides/ai-search-advisor');
                } else {
                  context.go('/legal-guides/${guide.id}');
                }
              },
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            ),
          );
        },
      ),
    );
  }
}

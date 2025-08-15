
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(context, 'Florida LEO News'),
          _buildNewsCard(
            context,
            title: 'New Legislation Impacts Officer Training Standards',
            source: 'Florida Police Chiefs Association',
            date: 'Oct 26, 2023',
            imageUrl: 'https://picsum.photos/seed/news1/400/200',
          ),
          _buildNewsCard(
            context,
            title: 'Miami-Dade Police Department Launches New Community Outreach Program',
            source: 'Miami Herald',
            date: 'Oct 25, 2023',
            imageUrl: 'https://picsum.photos/seed/news2/400/200',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Recent Case Law Updates'),
          _buildCaseLawCard(
            context,
            caseName: 'State v. Johnson',
            citation: 'SC22-1234',
            summary: 'The Florida Supreme Court rules on the admissibility of evidence from a new type of surveillance technology...',
          ),
          _buildCaseLawCard(
            context,
            caseName: 'Smith v. City of Orlando',
            citation: '11th Cir. 22-5678',
            summary: 'The 11th Circuit clarifies the standard for qualified immunity in cases involving use of force...',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, {required String title, required String source, required String date, required String imageUrl}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('$source - $date', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseLawCard(BuildContext context, {required String caseName, required String citation, required String summary}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(caseName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(citation, style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
            const SizedBox(height: 12),
            Text(summary, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

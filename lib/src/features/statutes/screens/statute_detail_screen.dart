
import 'package:flutter/material.dart';
import 'package:myapp/src/features/statutes/models/statute.dart';
import 'package:myapp/src/features/statutes/services/statute_service.dart';

class StatuteDetailScreen extends StatelessWidget {
  final String statuteId;

  const StatuteDetailScreen({super.key, required this.statuteId});

  @override
  Widget build(BuildContext context) {
    final StatuteService _statuteService = StatuteService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statute Details'),
      ),
      body: FutureBuilder<Statute>(
        future: _statuteService.getStatuteById(statuteId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Statute not found.'));
          } else {
            final statute = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  statute.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text('Code: ${statute.code}'),
                const SizedBox(height: 20),
                _buildSectionTitle(context, 'Description'),
                Text(statute.description),
                const SizedBox(height: 20),
                _buildSectionTitle(context, 'Practical Summary'),
                Text(statute.practicalSummary),
                const SizedBox(height: 20),
                _buildSectionTitle(context, 'Elements of the Crime'),
                ...statute.elementsOfTheCrime.map((element) => Text('• $element')),
                const SizedBox(height: 20),
                _buildSectionTitle(context, 'Real-World Example'),
                Text(statute.realWorldExample),
                const SizedBox(height: 20),
                _buildSectionTitle(context, 'Investigative Tips'),
                ...statute.investigativeTips.map((tip) => Text('• $tip')),
                const SizedBox(height: 20),
                _buildSectionTitle(context, 'Common Mistakes'),
                ...statute.commonMistakes.map((mistake) => Text('• $mistake')),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

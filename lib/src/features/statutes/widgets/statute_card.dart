
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/features/statutes/models/statute_index.dart';

class StatuteCard extends StatelessWidget {
  final StatuteIndex statute;

  const StatuteCard({super.key, required this.statute});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(statute.title),
        subtitle: Text('Code: ${statute.code}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          context.push('/search/statute-detail/${statute.id}');
        },
      ),
    );
  }
}

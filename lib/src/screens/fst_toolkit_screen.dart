
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FstToolkitScreen extends StatelessWidget {
  const FstToolkitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FST Toolkit'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const [
          _FstTestMenuItem(
            title: 'Horizontal Gaze Nystagmus (HGN)',
            subtitle: 'Check for involuntary jerking of the eyes.',
            icon: Icons.visibility,
            route: '/fst-toolkit/hgn',
          ),
          _FstTestMenuItem(
            title: 'Walk-and-Turn',
            subtitle: 'A divided attention test with two stages.',
            icon: Icons.directions_walk,
            route: '/fst-toolkit/walk-and-turn',
          ),
          _FstTestMenuItem(
            title: 'One-Leg Stand',
            subtitle: 'A divided attention test of balance.',
            icon: Icons.balance,
            route: '/fst-toolkit/one-leg-stand',
          ),
        ],
      ),
    );
  }
}

class _FstTestMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  const _FstTestMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary, size: 36),
        title: Text(title, style: theme.textTheme.titleLarge),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => GoRouter.of(context).push(route),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }
}

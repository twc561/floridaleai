
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CrashHelperScreen extends StatelessWidget {
  const CrashHelperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crash Investigation Helper'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const [
          _CrashToolMenuItem(
            title: 'Investigation Checklists',
            subtitle: 'Step-by-step duties for various crash types.',
            icon: Icons.checklist_rtl,
            route: '/crash-helper/checklists',
          ),
          _CrashToolMenuItem(
            title: 'Speed Calculator',
            subtitle: 'Estimate speed from skid marks.',
            icon: Icons.speed,
            route: '/crash-helper/speed-calculator',
          ),
          _CrashToolMenuItem(
            title: 'Information Guide',
            subtitle: 'Required info for drivers, vehicles, witnesses.',
            icon: Icons.description,
            route: '/crash-helper/info-guide', // Placeholder
          ),
          _CrashToolMenuItem(
            title: 'Scene Diagram Tool',
            subtitle: '(Coming Soon) Sketch crash scenes.',
            icon: Icons.draw,
            route: '', // Disabled for now
          ),
        ],
      ),
    );
  }
}

class _CrashToolMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  const _CrashToolMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isEnabled = route.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: Icon(
          icon,
          color: isEnabled ? theme.colorScheme.primary : theme.disabledColor,
          size: 36,
        ),
        title: Text(title, style: theme.textTheme.titleLarge),
        subtitle: Text(subtitle),
        trailing: isEnabled ? const Icon(Icons.chevron_right) : null,
        onTap: isEnabled ? () => GoRouter.of(context).push(route) : null,
        enabled: isEnabled,
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A list of all the feature tiles to be displayed.
    final List<FeatureTile> featureTiles = [
      FeatureTile(
        title: 'Report Assistant',
        icon: Icons.edit_document,
        subtitle: 'AI-powered report narrative generator.',
        onTap: () => GoRouter.of(context).go('/report-assistant'),
      ),
      FeatureTile(
        title: 'Legal Guides',
        icon: Icons.menu_book,
        subtitle: 'Interactive guides for common procedures.',
        onTap: () => GoRouter.of(context).go('/legal-guides'),
      ),
      FeatureTile(
        title: 'Case Law DB',
        icon: Icons.gavel,
        subtitle: 'Search recent and landmark case law.',
        onTap: () => GoRouter.of(context).go('/case-law'),
      ),
       FeatureTile(
        title: 'Statute Navigator',
        icon: Icons.balance,
        subtitle: 'Intelligent search for Florida Statutes.',
        onTap: () => GoRouter.of(context).go('/search'),
      ),
      FeatureTile(
        title: 'FST Toolkit',
        icon: Icons.directions_car,
        subtitle: 'Field Sobriety Test checklists and timer.',
        onTap: () => GoRouter.of(context).go('/fst-toolkit'),
      ),
      FeatureTile(
        title: 'Crash Helper',
        icon: Icons.car_crash,
        subtitle: 'Tools for traffic crash investigation.',
        onTap: () => GoRouter.of(context).go('/crash-helper'),
      ),
      FeatureTile(
        title: 'Language Helper',
        icon: Icons.translate,
        subtitle: 'Common phrases in Spanish and Creole.',
        onTap: () => GoRouter.of(context).go('/language-helper'),
      ),
      FeatureTile(
        title: 'Case of the Week',
        icon: Icons.quiz,
        subtitle: 'Weekly training scenario from real cases.',
        onTap: () => GoRouter.of(context).go('/case-of-the-week'),
      ),
      FeatureTile(
        title: 'Training Bulletins',
        icon: Icons.article,
        subtitle: 'Bite-sized summaries of new training.',
        onTap: () => GoRouter.of(context).go('/training-bulletins'),
      ),
      FeatureTile(
        title: 'Favorites',
        icon: Icons.favorite,
        subtitle: 'Your saved statutes and resources.',
        onTap: () => GoRouter.of(context).go('/favorites'),
      ),
      FeatureTile(
        title: 'Recents',
        icon: Icons.history,
        subtitle: 'Your recent search history.',
        onTap: () => GoRouter.of(context).go('/recents'),
      ),
      FeatureTile(
        title: 'Settings',
        icon: Icons.settings,
        subtitle: 'Configure app settings and preferences.',
        onTap: () => GoRouter.of(context).go('/settings'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Tools'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.9,
        ),
        itemCount: featureTiles.length,
        itemBuilder: (context, index) {
          return featureTiles[index];
        },
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const FeatureTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  icon,
                  size: 28.0,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

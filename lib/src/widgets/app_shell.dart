import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/widgets/adaptive_layout.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter.of(context);
    final currentLocation = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    return AdaptiveLayout(
      body: child,
      selectedIndex: _calculateSelectedIndex(currentLocation),
      onDestinationSelected: (index) {
        HapticFeedback.lightImpact();

        switch (index) {
          case 0:
            goRouter.go('/search');
            break;
          case 1:
            goRouter.go('/favorites');
            break;
          case 2:
            goRouter.go('/recents');
            break;
          case 3:
            goRouter.go('/simulator');
            break;
          case 4:
            goRouter.go('/settings');
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Search',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'Recents',
        ),
        NavigationDestination(
          icon: Icon(Icons.videogame_asset_outlined),
          selectedIcon: Icon(Icons.videogame_asset),
          label: 'Simulator',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/favorites')) {
      return 1;
    }
    if (location.startsWith('/recents')) {
      return 2;
    }
    if (location.startsWith('/simulator')) {
      return 3;
    }
    if (location.startsWith('/settings')) {
      return 4;
    }
    return 0;
  }
}

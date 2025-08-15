
import 'package:flutter/material.dart';
import 'package:myapp/src/screens/more_menu_screen.dart';
import 'package:myapp/src/widgets/app_navigation_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const AppNavigationBar(),
      endDrawer: const Drawer(
        child: MoreMenuScreen(),
      ),
    );
  }
}

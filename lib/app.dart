import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/routing/app_router.dart';
import 'src/theme_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter, // Use the new appRouter instance
      title: 'Flutter Material AI App',
      themeMode: context.watch<ThemeProvider>().themeMode,
      // You might need to define your light and dark themes here
      // theme: lightTheme,
      // darkTheme: darkTheme,
    );
  }
}

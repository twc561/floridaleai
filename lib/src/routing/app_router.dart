import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/field_simulator/report_card.dart';
import 'package:myapp/src/models/field_simulator/scenario_info.dart';
import 'package:myapp/src/models/statute.dart';
import 'package:myapp/src/screens/field_simulator_screen.dart';
import 'package:myapp/src/screens/favorites_screen.dart';
import 'package:myapp/src/screens/recents_screen.dart';
import 'package:myapp/src/screens/scenario_selection_screen.dart';
import 'package:myapp/src/screens/scenario_summary_screen.dart';
import 'package:myapp/src/screens/search_screen.dart';
import 'package:myapp/src/screens/settings_screen.dart';
import 'package:myapp/src/screens/statute_detail_screen.dart';
import 'package:myapp/src/widgets/app_shell.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/search',
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/search',
            builder: (BuildContext context, GoRouterState state) {
              return const SearchScreen();
            },
          ),
          GoRoute(
            path: '/favorites',
            builder: (BuildContext context, GoRouterState state) {
              return const FavoritesScreen();
            },
          ),
          GoRoute(
            path: '/recents',
            builder: (BuildContext context, GoRouterState state) {
              return const RecentsScreen();
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsScreen();
            },
          ),
          GoRoute(
            path: '/simulator',
            builder: (BuildContext context, GoRouterState state) {
              return const ScenarioSelectionScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/simulator/chat',
        builder: (BuildContext context, GoRouterState state) {
          // Pass the entire ScenarioInfo object to the simulator screen.
          final scenarioInfo = state.extra as ScenarioInfo;
          return FieldSimulatorScreen(scenarioInfo: scenarioInfo);
        },
      ),
      GoRoute(
        path: '/statute-details',
        builder: (BuildContext context, GoRouterState state) {
          final statute = state.extra as Statute;
          return StatuteDetailScreen(statute: statute);
        },
      ),
      GoRoute(
        path: '/scenario-summary',
        builder: (BuildContext context, GoRouterState state) {
          final reportCard = state.extra as ReportCard;
          return ScenarioSummaryScreen(reportCard: reportCard);
        },
      ),
    ],
  );
}

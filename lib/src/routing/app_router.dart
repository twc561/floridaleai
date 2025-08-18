
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Correctly import the package
import 'package:myapp/src/features/statutes/screens/statute_detail_screen.dart';
import '../models/case_law.dart';
import '../models/field_simulator/report_card.dart';
import '../models/field_simulator/scenario_info.dart';
import '../screens/ai_search_advisor_screen.dart';
import '../screens/case_law_detail_screen.dart';
import '../screens/case_law_screen.dart';
import '../screens/case_of_the_week_screen.dart';
import '../screens/crash/crash_checklists_screen.dart';
import '../screens/crash/speed_calculator_screen.dart';
import '../screens/crash_helper_screen.dart';
import '../screens/field_simulator_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/fst/hgn_test_screen.dart';
import '../screens/fst/one_leg_stand_test_screen.dart';
import '../screens/fst/walk_and_turn_test_screen.dart';
import '../screens/fst_toolkit_screen.dart';
import '../screens/home_screen.dart';
import '../screens/language_helper_screen.dart';
import '../screens/legal_guide_detail_screen.dart';
import '../screens/legal_guides_screen.dart';
import '../screens/more_menu_screen.dart';
import '../screens/recents_screen.dart';
import '../screens/report_assistant_screen.dart';
import '../screens/report_generation_screen.dart';
import '../screens/scenario_selection_screen.dart';
import '../screens/scenario_summary_screen.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/training_bulletins_screen.dart';
import '../widgets/app_shell.dart';

// Navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchScreen(),
          ),
          routes: [
            // Statute detail is a sub-route of search
            GoRoute(
              path: 'statute-detail/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return StatuteDetailScreen(statuteId: id);
              },
            ),
          ]
        ),
        GoRoute(
          path: '/scenario-selection',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ScenarioSelectionScreen(),
          ),
        ),
        GoRoute(
          path: '/more',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MoreMenuScreen(),
          ),
        ),
      ],
    ),

    // Top-level routes
    GoRoute(
      path: '/favorites',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/recents',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RecentsScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/report-assistant',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReportAssistantScreen(),
    ),
    GoRoute(
      path: '/legal-guides',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LegalGuidesScreen(),
      routes: [
        GoRoute(
          path: 'ai-search-advisor',
          builder: (context, state) => const AiSearchAdvisorScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return LegalGuideDetailScreen(guideId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/case-law',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CaseLawScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final caseItem = state.extra as CaseLaw;
            return CaseLawDetailScreen(caseItem: caseItem);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/fst-toolkit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FstToolkitScreen(),
      routes: [
        GoRoute(
          path: 'hgn',
          builder: (context, state) => const HgnTestScreen(),
        ),
        GoRoute(
          path: 'walk-and-turn',
          builder: (context, state) => const WalkAndTurnTestScreen(),
        ),
        GoRoute(
          path: 'one-leg-stand',
          builder: (context, state) => const OneLegStandTestScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/crash-helper',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CrashHelperScreen(),
      routes: [
        GoRoute(
          path: 'checklists',
          builder: (context, state) => const CrashChecklistsScreen(),
        ),
        GoRoute(
          path: 'speed-calculator',
          builder: (context, state) => const SpeedCalculatorScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/language-helper',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LanguageHelperScreen(),
    ),
    GoRoute(
      path: '/case-of-the-week',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CaseOfTheWeekScreen(),
    ),
    GoRoute(
      path: '/training-bulletins',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TrainingBulletinsScreen(),
    ),
    GoRoute(
      path: '/field-simulator',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final scenario = state.extra as ScenarioInfo;
        return FieldSimulatorScreen(scenarioInfo: scenario);
      },
    ),
    GoRoute(
      path: '/scenario-summary',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final reportCard = state.extra as ReportCard;
        return ScenarioSummaryScreen(reportCard: reportCard);
      },
    ),
    GoRoute(
      path: '/report-generation',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final reportCard = state.extra as ReportCard;
        return ReportGenerationScreen(reportCard: reportCard);
      },
    ),
  ],
);

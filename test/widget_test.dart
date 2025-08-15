import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/app.dart';
import 'package:myapp/src/theme_provider.dart';
import 'package:myapp/src/widgets/app_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('App renders correctly and navigates', (WidgetTester tester) async {
    // Wrap the test in mockNetworkImagesFor to handle network images
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const App(),
        ),
      );

      // Verify that the AppBar is displayed
      expect(find.byType(AppBar), findsOneWidget);

      // Verify that the title 'Home' is in the AppBar
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Home'),
        ),
        findsOneWidget,
      );

      // Verify that the AppNavigationBar is displayed
      expect(find.byType(AppNavigationBar), findsOneWidget);

      // Find the NavigationBar within the AppNavigationBar
      final navBar = find.descendant(
        of: find.byType(AppNavigationBar),
        matching: find.byType(NavigationBar),
      );
      expect(navBar, findsOneWidget);

      // Find and tap the 'Statutes' navigation destination
      await tester.tap(find.descendant(
        of: navBar,
        matching: find.byWidgetPredicate(
          (Widget widget) => widget is NavigationDestination && widget.icon is Icon && (widget.icon as Icon).icon == Icons.gavel,
        ),
      ));
      await tester.pumpAndSettle(); // Wait for navigation to complete

      // Verify that the Statutes screen is displayed
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Statutes'),
        ),
        findsOneWidget,
      );
    });
  });
}

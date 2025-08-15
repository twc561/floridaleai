import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'src/theme_provider.dart';
import 'firebase_options.dart';
import 'src/services/gemini_service.dart';
import 'src/routing/app_router.dart';

void main() async {
  // Ensure Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables.
  await dotenv.load(fileName: ".env");

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Activate Firebase App Check with the debug provider.
  // For production, you would use AndroidProvider.playIntegrity
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    // appleProvider: AppleProvider.appAttest, // For iOS
  );

  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null) {
    print('Error: GEMINI_API_KEY is not set in .env file');
    return;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        Provider<GeminiService>(
          create: (_) => GeminiService(apiKey: apiKey),
        ),
        Provider<AppRouter>(
          create: (_) => AppRouter(),
        ),
      ],
      child: const StatefulApp(),
    ),
  );
}

class StatefulApp extends StatelessWidget {
  const StatefulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final textTheme = TextTheme(
          displayLarge: GoogleFonts.robotoFlex(fontSize: 57, fontWeight: FontWeight.w400),
          headlineMedium: GoogleFonts.robotoFlex(fontSize: 28, fontWeight: FontWeight.w400),
          titleLarge: GoogleFonts.robotoFlex(fontSize: 22, fontWeight: FontWeight.w500),
          bodyLarge: GoogleFonts.robotoFlex(fontSize: 16, fontWeight: FontWeight.w400),
          labelSmall: GoogleFonts.robotoFlex(fontSize: 11, fontWeight: FontWeight.w500),
        );
        
        final lightTheme = ThemeData(
          colorScheme: lightDynamic,
          useMaterial3: true,
          textTheme: textTheme,
          fontFamily: 'RobotoFlex',
        );

        final darkTheme = ThemeData(
          colorScheme: darkDynamic,
          useMaterial3: true,
          textTheme: textTheme,
          fontFamily: 'RobotoFlex',
        );

        return MaterialApp.router(
          routerConfig: context.watch<AppRouter>().router,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: context.watch<ThemeProvider>().themeMode,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            physics: const BouncingScrollPhysics(),
          )
        );
      },
    );
  }
}

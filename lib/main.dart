
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'src/theme_provider.dart';
import 'firebase_options.dart';
import 'src/services/gemini_service.dart';
import 'app.dart'; // Import the new App widget

void main() async {
  // Ensure Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables.
  await dotenv.load(fileName: ".env");

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get the API key from environment variables.
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null) {
    // In a real app, you'd want to handle this more gracefully.
    throw Exception('GEMINI_API_KEY not found in .env file');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // Provide the GeminiService instance.
        Provider<GeminiService>(
          create: (_) => GeminiService(apiKey: apiKey),
        ),
      ],
      child: const App(), // Use the new App widget
    ),
  );
}

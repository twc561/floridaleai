
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:myapp/src/data/translations_data.dart';
import 'package:myapp/src/models/translation.dart';
import 'dart:collection';

class LanguageHelperScreen extends StatefulWidget {
  const LanguageHelperScreen({super.key});

  @override
  LanguageHelperScreenState createState() => LanguageHelperScreenState();
}

class LanguageHelperScreenState extends State<LanguageHelperScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  late final LinkedHashMap<String, List<Translation>> _categorizedTranslations;

  @override
  void initState() {
    super.initState();
    _categorizedTranslations = _groupTranslations();
  }

  // Helper to group translations by category
  LinkedHashMap<String, List<Translation>> _groupTranslations() {
    final map = <String, List<Translation>>{};
    for (var t in translations) {
      (map[t.category] ??= []).add(t);
    }
    return map as LinkedHashMap<String, List<Translation>>;
  }

  Future<void> _speak(String text, String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = _categorizedTranslations.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Helper'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryTranslations = _categorizedTranslations[category]!;
          return _buildCategoryCard(theme, category, categoryTranslations);
        },
      ),
    );
  }

  Widget _buildCategoryCard(ThemeData theme, String category, List<Translation> translations) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ExpansionTile(
        title: Text(category, style: theme.textTheme.titleLarge),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: translations.map((t) => _buildTranslationTile(t)).toList(),
      ),
    );
  }

  Widget _buildTranslationTile(Translation translation) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '"${translation.english}"',
                style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 12),
              _buildTranslationRow('es-ES', translation.spanish, 'Spanish'),
              const SizedBox(height: 8),
              _buildTranslationRow('fr-HT', translation.creole, 'Haitian Creole'),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildTranslationRow(String langCode, String text, String langName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(langName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(text, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () => _speak(text, langCode),
          tooltip: 'Play translation',
        ),
      ],
    );
  }
}

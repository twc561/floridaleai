
// lib/src/screens/search_screen.dart
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- CORRECT IMPORT ADDED
import 'package:myapp/src/screens/statute_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SearchScreenContent();
  }
}

class _SearchScreenContent extends StatefulWidget {
  const _SearchScreenContent();

  @override
  __SearchScreenContentState createState() => __SearchScreenContentState();
}

class __SearchScreenContentState extends State<_SearchScreenContent> {
  final _textController = TextEditingController();
  final List<String> _recentSearches = ["DUI", "316.193", "Burglary"];

  void _search(String query) {
    if (query.isEmpty) {
      return;
    }
    // Call haptic feedback on user action
    HapticFeedback.lightImpact(); // <-- CORRECTED USAGE

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatuteDetailScreen(query: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverAppBar.large(
            title: Text('Florida Statute AI'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'The AI-Powered Field Guide for Law Enforcement',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 48),
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter a keyword, phrase, or statute number',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8.0,
                    children: _recentSearches
                        .map((term) => FilterChip(
                              label: Text(term),
                              onSelected: (selected) {
                                if (selected) {
                                  _textController.text = term;
                                  _search(term);
                                }
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => _search(_textController.text),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

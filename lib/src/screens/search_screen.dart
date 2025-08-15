// lib/src/screens/search_screen.dart
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- CORRECT IMPORT ADDED
import 'package:myapp/src/models/statute.dart';
import 'package:myapp/src/screens/statute_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/services/gemini_service.dart';

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
  bool _isLoading = false;
  final List<String> _recentSearches = ["DUI", "316.193", "Burglary"];
  Statute? _searchResult;

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      return;
    }
    // Call haptic feedback on user action
    HapticFeedback.lightImpact(); // <-- CORRECTED USAGE

    setState(() {
      _isLoading = true;
      _searchResult = null;
    });

    final geminiService = Provider.of<GeminiService>(context, listen: false);

    try {
      final statute = await geminiService.findStatute(query);
      setState(() {
        _searchResult = statute;
      });
      if (statute == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No statute found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                    onPressed: _isLoading ? null : () => _search(_textController.text),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Search'),
                  ),
                  if (_searchResult != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: SearchResultCard(statute: _searchResult!),
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

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({super.key, required this.statute});

  final Statute statute;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 500),
      closedBuilder: (context, action) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(statute.number, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(statute.title, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        );
      },
      openBuilder: (context, action) {
        return StatuteDetailScreen(statute: statute);
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/statute_data.dart';
import '../models/statute.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Statute> _searchResults = [];
  bool _isLoading = false;
  late final List<Statute> allStatutes;

  @override
  void initState() {
    super.initState();
    allStatutes = getStatutes();
  }

  void _performSearch() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // In a real app, you might perform a network request here.
    // For this example, we'll filter the local list of statutes.
    final results = allStatutes.where((statute) {
      return statute.title.toLowerCase().contains(query) ||
          statute.content.toLowerCase().contains(query) ||
          statute.severity.toLowerCase().contains(query) ||
          statute.enhancements.any((enhancement) => enhancement.toLowerCase().contains(query)) ||
          statute.subsections.values.any((subsection) => subsection.toLowerCase().contains(query)) ||
          statute.examples.any((example) => example.toLowerCase().contains(query));
    }).toList();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Statutes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter a statute number or keyword',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
            const SizedBox(height: 16.0),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_searchResults.isEmpty &&
                _searchController.text.isNotEmpty)
              const Center(child: Text('No statutes found.'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final statute = _searchResults[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(statute.title),
                        onTap: () {
                          // Navigate to the detail screen for the selected statute
                          GoRouter.of(context).push('/statute-details', extra: statute);
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

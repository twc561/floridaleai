
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/case_law_data.dart';
import '../models/case_law.dart';

class CaseLawScreen extends StatefulWidget {
  const CaseLawScreen({super.key});

  @override
  CaseLawScreenState createState() => CaseLawScreenState();
}

class CaseLawScreenState extends State<CaseLawScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CaseLaw> _filteredCases = caseLawData;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCases);
  }

  void _filterCases() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCases = caseLawData.where((caseItem) {
        return caseItem.title.toLowerCase().contains(query) ||
            caseItem.summary.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Law Database'),
      ),
      body: Column(
        children: [
          _buildSearchBar(theme),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _filteredCases.length,
              itemBuilder: (context, index) {
                return CaseLawCard(caseItem: _filteredCases[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search cases by name, keyword, or topic...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest,
        ),
      ),
    );
  }
}

class CaseLawCard extends StatelessWidget {
  final CaseLaw caseItem;
  const CaseLawCard({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        title: Text(caseItem.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(caseItem.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // We will create the detail screen next
          GoRouter.of(context).push('/case-law/details', extra: caseItem);
        },
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }
}

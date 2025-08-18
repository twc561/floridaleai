
import 'package:flutter/material.dart';
import 'package:myapp/src/features/statutes/models/statute_index.dart';
import 'package:myapp/src/features/statutes/services/gemini_statute_service.dart';
import 'package:myapp/src/features/statutes/services/statute_service.dart';
import 'package.myapp/src/features/statutes/widgets/statute_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final StatuteService _statuteService = StatuteService();
  final GeminiStatuteService _geminiStatuteService = GeminiStatuteService();
  late Future<List<StatuteIndex>> _statutesFuture;
  List<StatuteIndex> _allStatutes = [];
  List<StatuteIndex> _filteredStatutes = [];
  String _searchQuery = '';
  bool _isAiSearching = false;

  StatuteIndex? _aiSuggestedStatute;
  double _aiConfidence = 0.0;
  String _aiReasoning = '';

  @override
  void initState() {
    super.initState();
    _loadStatutes();
  }

  void _loadStatutes() {
    _statutesFuture = _statuteService.getStatuteIndex();
    _statutesFuture.then((statutes) {
      if (mounted) {
        setState(() {
          _allStatutes = statutes;
          _filteredStatutes = statutes;
        });
      }
    });
  }

  void _filterStatutes(String query) {
    setState(() {
      _searchQuery = query;
      _aiSuggestedStatute = null;
      _aiConfidence = 0.0;
      _aiReasoning = '';

      if (query.isEmpty) {
        _filteredStatutes = _allStatutes;
        _isAiSearching = false;
        return;
      }

      _filteredStatutes = _allStatutes
          .where((statute) =>
              statute.title.toLowerCase().contains(query.toLowerCase()) ||
              statute.code.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (_filteredStatutes.isEmpty && query.isNotEmpty) {
        _performAiSearch(query);
      }
    });
  }

  Future<void> _performAiSearch(String query) async {
    setState(() {
      _isAiSearching = true;
    });

    // 1. Correctly destructure the tuple response from the service.
    final (statuteId, confidence, reasoning) = await _geminiStatuteService.findStatuteWithAi(query);

    if (mounted) {
      StatuteIndex? aiResult;
      if (statuteId != null) {
        try {
          aiResult = _allStatutes.firstWhere((s) => s.id == statuteId);
        } catch (e) {
          debugPrint("AI returned invalid statute ID: $statuteId");
        }
      }
      
      // 2. Update all state variables in a single, atomic operation.
      setState(() {
        _aiSuggestedStatute = aiResult;
        _aiConfidence = confidence;
        _aiReasoning = reasoning;
        _isAiSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statute Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterStatutes,
              decoration: InputDecoration(
                labelText: 'Describe a situation to find a statute...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StatuteIndex>>(
              future: _statutesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && _allStatutes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading statutes: ${snapshot.error}'));
                }
                return _buildSearchResults();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isAiSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('AI is analyzing your query...'),
          ],
        ),
      );
    }

    if (_filteredStatutes.isNotEmpty) {
      return ListView.builder(
        itemCount: _filteredStatutes.length,
        itemBuilder: (context, index) {
          return StatuteCard(statute: _filteredStatutes[index]);
        },
      );
    }

    if (_aiSuggestedStatute != null && _aiConfidence >= 0.7) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'AI Suggestion (Confidence: ${(_aiConfidence * 100).toStringAsFixed(1)}%)\\n"${_aiReasoning}"',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          StatuteCard(statute: _aiSuggestedStatute!),
        ],
      );
    }
    
    if (_searchQuery.isNotEmpty && !_isAiSearching) {
      return const Center(
        child: Text('No relevant statutes found.'),
      );
    }

    return ListView.builder(
      itemCount: _allStatutes.length,
      itemBuilder: (context, index) {
        return StatuteCard(statute: _allStatutes[index]);
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:myapp/src/data/legal_guides_data.dart';
import 'package:myapp/src/services/gemini_service.dart';
import 'package:provider/provider.dart';

class LegalGuideDetailScreen extends StatelessWidget {
  final String guideId;
  const LegalGuideDetailScreen({super.key, required this.guideId});

  @override
  Widget build(BuildContext context) {
    final guide = legalGuidesMap[guideId];

    if (guide == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Guide not found.'),
        ),
      );
    }
    
    // The AI advisor is a special case.
    final isAiAdvisor = guide.id == 'ai-search-and-seizure-advisor';

    return Scaffold(
      appBar: AppBar(
        title: Text(guide.title),
      ),
      body: isAiAdvisor
          ? const AiSearchAndSeizureAdvisor()
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: guide.sections.length,
              itemBuilder: (context, index) {
                final section = guide.sections[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 6.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: ExpansionTile(
                    title: Text(section.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MarkdownBody(
                          data: section.content,
                          styleSheet: MarkdownStyleSheet.fromTheme(
                            Theme.of(context),
                          ).copyWith(
                            p: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class AiSearchAndSeizureAdvisor extends StatefulWidget {
  const AiSearchAndSeizureAdvisor({super.key});

  @override
  State<AiSearchAndSeizureAdvisor> createState() =>
      _AiSearchAndSeizureAdvisorState();
}

class _AiSearchAndSeizureAdvisorState extends State<AiSearchAndSeizureAdvisor> {
  final TextEditingController _scenarioController = TextEditingController();
  String _aiResponse = '';
  bool _isLoading = false;
  String? _error;

  Future<void> _getAiGuidance() async {
    if (_scenarioController.text.trim().isEmpty) {
      setState(() {
        _error = 'Please enter a scenario before getting guidance.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _aiResponse = '';
      _error = null;
    });

    try {
      final geminiService = Provider.of<GeminiService>(context, listen: false);
      final response = await geminiService.getSearchAndSeizureAdvice(
        _scenarioController.text,
      );
      setState(() {
        _aiResponse = response;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to get guidance: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputCard(theme),
          const SizedBox(height: 24),
          _buildGenerateButton(theme),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            _buildErrorDisplay(theme)
          else if (_aiResponse.isNotEmpty)
            _buildResponseDisplayCard(theme),
        ],
      ),
    );
  }

  Widget _buildInputCard(ThemeData theme) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter a Scenario",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Describe a search and seizure scenario. The more detail, the better.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _scenarioController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText:
                    "e.g., I stopped a car for speeding. I saw a bag of marijuana on the passenger seat. Can I search the car?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton(ThemeData theme) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.smart_toy),
      label: const Text('Get AI Guidance'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        textStyle: theme.textTheme.titleMedium,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      onPressed: _isLoading ? null : _getAiGuidance,
    );
  }

  Widget _buildErrorDisplay(ThemeData theme) {
    return Card(
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _error!,
          style: TextStyle(color: theme.colorScheme.onErrorContainer),
        ),
      ),
    );
  }

  Widget _buildResponseDisplayCard(ThemeData theme) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("AI Guidance", style: theme.textTheme.titleLarge),
            const Divider(height: 16),
            SelectableText(
              _aiResponse,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

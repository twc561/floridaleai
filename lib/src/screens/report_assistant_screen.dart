
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/src/services/gemini_service.dart';
import 'package:provider/provider.dart';

class ReportAssistantScreen extends StatefulWidget {
  const ReportAssistantScreen({super.key});

  @override
  ReportAssistantScreenState createState() => ReportAssistantScreenState();
}

class ReportAssistantScreenState extends State<ReportAssistantScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _generatedReport = '';
  bool _isLoading = false;
  String? _error;

  Future<void> _generateReport() async {
    if (_inputController.text.trim().isEmpty) {
      setState(() {
        _error = 'Please enter some key points before generating a report.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _generatedReport = '';
      _error = null;
    });

    try {
      final geminiService = Provider.of<GeminiService>(context, listen: false);
      // We will create a new, more suitable method in GeminiService
      final report = await geminiService.generateReportFromNotes(_inputController.text);
      setState(() {
        _generatedReport = report;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to generate report: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    if (_generatedReport.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedReport));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report copied to clipboard!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Assistant'),
      ),
      body: SingleChildScrollView(
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
            else if (_generatedReport.isNotEmpty)
              _buildReportDisplayCard(theme),
          ],
        ),
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
              "Enter Key Points",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Use bullet points or simple phrases. Include key actions, times, locations, and observations.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _inputController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "e.g.\n- Responded to 123 Main St re: theft\n- Arrived 14:30, met with victim Jane Doe\n- Suspect described as tall male, red shirt\n- Searched area, no suspect found",
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
      icon: const Icon(Icons.auto_awesome),
      label: const Text('Generate Report'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        textStyle: theme.textTheme.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      onPressed: _isLoading ? null : _generateReport,
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

  Widget _buildReportDisplayCard(ThemeData theme) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Generated Narrative", style: theme.textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.copy_all_outlined),
                  onPressed: _copyToClipboard,
                  tooltip: 'Copy to Clipboard',
                ),
              ],
            ),
            const Divider(height: 16),
            SelectableText(
              _generatedReport,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

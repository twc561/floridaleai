
import 'package:flutter/material.dart';
import 'package:myapp/src/models/field_simulator/report_card.dart';
import 'package:myapp/src/services/gemini_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReportGenerationScreen extends StatefulWidget {
  final ReportCard reportCard;
  const ReportGenerationScreen({super.key, required this.reportCard});

  @override
  State<ReportGenerationScreen> createState() => _ReportGenerationScreenState();
}

class _ReportGenerationScreenState extends State<ReportGenerationScreen> {
  late final GeminiService _geminiService;
  Future<String>? _reportFuture;

  @override
  void initState() {
    super.initState();
    _geminiService = Provider.of<GeminiService>(context, listen: false);
    _reportFuture = _geminiService.generateIncidentReport(widget.reportCard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Incident Report'),
      ),
      body: FutureBuilder<String>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error generating report: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No report generated.'));
          }

          final reportText = snapshot.data!;
          return Markdown(
            data: reportText,
            padding: const EdgeInsets.all(16.0),
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:myapp/src/models/statute_response.dart';
import 'package:myapp/src/services/rag_service.dart';
import 'package:provider/provider.dart';

// A map to hold the text styles for different parts of the statute.
final Map<String, TextStyle> _statuteStyles = {
  'STATUTE_TITLE': const TextStyle(
    color: Colors.blue,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
  'SUBSECTION_HEADER': const TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  'CONTENT_BODY': const TextStyle(
    color: Colors.black87,
    fontSize: 16,
    height: 1.5,
  ),
  'HIGHLIGHT': const TextStyle(
    color: Colors.black,
    backgroundColor: Colors.yellow,
    fontSize: 16,
    height: 1.5,
  ),
};

class StatuteDetailScreen extends StatefulWidget {
  final String query;

  const StatuteDetailScreen({super.key, required this.query});

  @override
  State<StatuteDetailScreen> createState() => _StatuteDetailScreenState();
}

class _StatuteDetailScreenState extends State<StatuteDetailScreen> {
  late final RAGService _ragService;
  Future<StatuteResponse>? _statuteResponseFuture;

  @override
  void initState() {
    super.initState();
    _ragService = RAGService(Provider.of(context, listen: false));
    _statuteResponseFuture = _ragService.getStatuteInfo(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statute Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<StatuteResponse>(
          future: _statuteResponseFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found.'));
            }

            final statuteResponse = snapshot.data!;
            return ListView(
              children: [
                Text(
                  statuteResponse.summary,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    style: _statuteStyles['CONTENT_BODY'], // Default style
                    children: statuteResponse.sections.map((section) {
                      return TextSpan(
                        text: '${section.content}\n\n', // Add spacing
                        style: _statuteStyles[section.type],
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


import 'dart:convert';
import 'dart:developer' as developer;
import 'package:firebase_ai/firebase_ai.dart';
import 'package:myapp/src/features/statutes/models/statute.dart';
import 'package:myapp/src/features/statutes/services/statute_service.dart';

// Define a simple class to hold the structured AI response.
class AiStatuteSuggestion {
  final String statuteId;
  final double confidenceScore;
  final String reasoning;

  AiStatuteSuggestion({
    required this.statuteId,
    required this.confidenceScore,
    required this.reasoning,
  });
}

class GeminiStatuteService {
  final StatuteService _statuteService = StatuteService();

  Future<List<AiStatuteSuggestion>> findStatuteWithAi(String naturalLanguageQuery) async {
    try {
      final jsonSchema = Schema.object(
        properties: {
          'suggestions': Schema.array(
            description: 'A ranked list of the top 3 most relevant statute suggestions.',
            items: Schema.object(
              properties: {
                'statuteId': Schema.string(description: 'The unique identifier of the statute.'),
                'confidenceScore': Schema.number(description: 'A score from 0.0 to 1.0 indicating confidence.'),
                'reasoning': Schema.string(description: 'A brief explanation for why this statute was chosen.'),
              },
            ),
          ),
        },
      );

      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-1.5-pro',
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: jsonSchema,
        ),
      );

      final List<Statute> allStatutes = await _statuteService.getAllStatutes();
      final String statutesContext = allStatutes
          .map((s) => json.encode({
                "id": s.id,
                "title": s.title,
                "description": s.description,
                "elementsOfTheCrime": s.elementsOfTheCrime,
              }))
          .join(',\\n');

      // 1. This is the new, more forceful and direct prompt.
      final prompt = '''
        You are an expert legal AI classification engine for Florida law enforcement. Your sole function is to analyze a user's query and classify it by choosing the three most relevant Florida Statutes from the provided list.

        You MUST compare the user's query to the "description", "practicalSummary", and critically, the "elementsOfTheCrime" for each statute. Your task is to find the best possible matches, even if the user's query is brief or does not perfectly align with the legal language.

        You WILL return a JSON object containing a 'suggestions' array with the top 3 most relevant statutes, ranked by your confidence. Do not ever return an empty array.

        Statute Data:
        ---
        [$statutesContext]
        ---

        User's Query: "$naturalLanguageQuery"
      ''';

      developer.log('Sending final, assertive prompt to Gemini...', name: 'GeminiStatuteService');
      final response = await model.generateContent([Content.text(prompt)]);
      developer.log('Received raw response from Gemini: ${response.text}', name: 'GeminiStatuteService');

      if (response.text != null) {
        final jsonResponse = json.decode(response.text!);
        final List<dynamic> suggestions = jsonResponse['suggestions'] ?? [];
        
        return suggestions.map((s) {
          return AiStatuteSuggestion(
            statuteId: s['statuteId'],
            confidenceScore: (s['confidenceScore'] as num).toDouble(),
            reasoning: s['reasoning'],
          );
        }).toList();
      }
    } catch (e) {
      developer.log('Error in Gemini Service: $e', name: 'GeminiStatuteService', error: e);
    }
    return [];
  }
}

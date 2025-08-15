
import 'dart:convert';
import 'dart:developer' as developer; // Import the developer logger

import 'package:myapp/src/services/gemini_service.dart';
import 'package:myapp/src/models/statute_response.dart';

class RAGService {
  final GeminiService _geminiService;

  RAGService(this._geminiService);

  Future<StatuteResponse> getStatuteInfo(String query) async {
    // 1. --- Retrieval (Simulated) ---
    // In a real RAG pipeline, this is where you would:
    // a. Create an embedding of the user's query.
    // b. Query a vector database to find relevant statute chunks.
    // c. For this example, we'll use a hardcoded, relevant statute.
    const String relevantStatuteText = r'''
    316.193  Driving under the influence; penalties.—
    (1) A person is guilty of the offense of driving under the influence and is punishable as provided in subsection (2), subsection (3), or subsection (4) if the person is driving or in actual physical control of a vehicle within this state and:
    (a) The person is under the influence of alcoholic beverages, any chemical substance set forth in s. 877.111, or any substance controlled under chapter 893, when affected to the extent that the person’s normal faculties are impaired;
    (b) The person has a blood-alcohol level of 0.08 or more grams of alcohol per 100 milliliters of blood; or
    (c) The person has a breath-alcohol level of 0.08 or more grams of alcohol per 210 liters of breath.
    (2)(a) Except as provided in paragraph (b), subsection (3), or subsection (4), any person who is convicted of a violation of subsection (1) shall be punished:
    1. By a fine of:
    a. Not less than $500 or more than $1,000 for a first conviction.
    b. Not less than $1,000 or more than $2,000 for a second conviction; and
    2. By imprisonment for:
    a. Not more than 6 months for a first conviction.
    b. Not more than 9 months for a second conviction.
    ''';

    // 2. --- Augmentation & Generation ---
    final prompt = """
    You are a helpful legal assistant for Florida Law Enforcement officers. Your task is to answer the user's question based *only* on the provided legal statutes. Do not use any outside knowledge.

    Format your response as a valid JSON object with the following structure:
    {
      "summary": "A brief, one-sentence summary of the answer.",
      "sections": [
        {
          "type": "STATUTE_TITLE",
          "content": "The full title of the statute."
        },
        {
          "type": "SUBSECTION_HEADER",
          "content": "The header for a specific subsection, like '(1)(a)'."
        },
        {
          "type": "CONTENT_BODY",
          "content": "The paragraph text of the statute itself."
        },
        {
          "type": "HIGHLIGHT",
          "content": "A key phrase or sentence directly relevant to the user's question."
        }
      ],
      "examples": [
        "A real-world example of this statute being applied.",
        "A second, different real-world example of this statute being applied."
      ]
    }

    ---
    **PROVIDED STATUTES:**
    $relevantStatuteText

    ---
    **USER'S QUESTION:**
    $query
    """;

    final response = await _geminiService.generateText(prompt);

    // --- LOG THE RAW RESPONSE ---
    developer.log('Raw AI Response:\n$response', name: 'rag_service');


    // 3. --- Parsing ---
    try {
      // Clean the response by extracting only the content between ```json and ```
      final jsonString = response.replaceAll('```json', '').replaceAll('```', '').trim();
      final jsonResponse = jsonDecode(jsonString);
      return StatuteResponse.fromJson(jsonResponse);
    } catch (e, s) {
      developer.log(
        'Failed to parse JSON response.',
        name: 'rag_service',
        error: e,
        stackTrace: s,
      );
      // Handle cases where Gemini doesn't return valid JSON
      // You could return a formatted error response or try to recover
      return const StatuteResponse(
        summary: 'Error parsing the response from the AI.',
        sections: [
          StatuteSection(
            type: 'CONTENT_BODY',
            content: 'The AI returned a response that could not be understood. Please try again.',
          ),
        ],
        examples: [],
      );
    }
  }
}

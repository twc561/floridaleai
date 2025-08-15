import 'dart:convert';
import 'dart:developer' as dev;

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:myapp/src/models/field_simulator/chat_message.dart';

import '../models/statute.dart';

/// A service that uses Gemini for both statute lookups and interactive chat simulations.
class GeminiService {
  final GenerativeModel _statuteModel;
  final GenerativeModel _chatModel;
  ChatSession? chat;

  GeminiService({required String apiKey, GenerativeModel? statuteModel, GenerativeModel? chatModel})
      : _statuteModel = statuteModel ??
            GenerativeModel(
              model: 'gemini-1.5-flash-latest',
              apiKey: apiKey,
              generationConfig: GenerationConfig(temperature: 0.2),
            ),
        _chatModel = chatModel ??
            GenerativeModel(
              model: 'gemini-1.5-pro-latest',
              apiKey: apiKey,
              generationConfig: GenerationConfig(
                temperature: 0.8,
              ),
              // Tools are used to enforce the JSON schema.
              tools: [
                Tool(
                  functionDeclarations: [
                    FunctionDeclaration(
                      'logScenarioResponse',
                      'Logs the AI actor\'s response and feedback.',
                      Schema(
                        SchemaType.object,
                        properties: {
                          'response': Schema(SchemaType.string, description: "In-character dialogue as the subject."),
                          'feedback': Schema(SchemaType.string, description: "Out-of-character training feedback for the officer."),
                          'report_card_note': Schema(SchemaType.string, description: "Brief summary for the end-of-scenario report card."),
                          'dynamic_event': Schema(SchemaType.string, description: "Optional: An unexpected event to change the scenario's direction."),
                        },
                        // [FIX]: Replaced the invalid 'required:' parameter with the correct 'requiredProperties:'.
                        requiredProperties: const ['response', 'feedback', 'report_card_note'],
                      ),
                    ),
                  ],
                ),
              ],
            );

  // --- STATUTE LOOKUP METHODS ---
  Future<Statute?> findStatute(String? query) async {
    final q = query?.trim() ?? '';
    if (q.isEmpty) return null;

    final prompt = '''
You are an expert AI assistant specialized in Florida law.
Identify the MOST relevant Florida Statute for this query: "$q".
Return ONLY a single valid JSON object with keys:
- "number" (e.g., "316.193")
- "title" (short statute title)
- "fullText" (plain text of the statute section)
''';

    try {
      final response = await _statuteModel.generateContent([Content.text(prompt)]);
      final responseText = response.text?.trim() ?? '';
      if (responseText.isEmpty) {
        dev.log('Received empty response from Gemini.', name: 'GeminiService');
        return null;
      }
      final match = RegExp(r'\{[\s\S]*?\}').firstMatch(responseText);
      if (match == null) {
        dev.log('No JSON object found in response.', name: 'GeminiService', error: responseText);
        return null;
      }
      final jsonString = match.group(0)!;
      return Statute.fromJson(jsonDecode(jsonString));
    } catch (e, s) {
      dev.log('Error finding statute', name: 'GeminiService', error: e, stackTrace: s);
      return null;
    }
  }

  /// Generates a plain-language summary for a given statute.
  Future<String> getSummary(String statuteNumber) async {
    final prompt = '''
You are an expert AI assistant specializing in Florida law.
Provide a clear, plain-language summary for Florida Statute $statuteNumber.
Focus on key elements of the offense and important definitions.
No markdown or extra formatting.
''';
    return _generateText(prompt);
  }

  /// Generates a list of common scenarios for a given statute.
  Future<String> getScenarios(String statuteNumber) async {
    final prompt = '''
You are an expert AI assistant specializing in Florida law.
List 3–5 concise, real-world scenarios for Florida Statute $statuteNumber that an officer might encounter.
For each scenario, briefly state how the statute applies.
No markdown or extra formatting.
''';
    return _generateText(prompt);
  }

  /// Summarizes relevant case law for a given statute.
  Future<String> getCaseLaw(String statuteNumber) async {
    final prompt = '''
You are an expert AI assistant specializing in Florida law.
Summarize 1–2 key cases interpreting Florida Statute $statuteNumber and the practical takeaways for officers.
Be concise and easy to understand.
No markdown or extra formatting.
''';
    return _generateText(prompt);
  }

  /// Helper to generate text from a prompt using the statute model.
  Future<String> _generateText(String prompt) async {
    try {
      final response = await _statuteModel.generateContent([Content.text(prompt)]);
      final text = response.text?.trim();
      return (text == null || text.isEmpty) ? 'No response from model.' : text;
    } catch (e, s) {
      dev.log('Error generating text', name: 'GeminiService', error: e, stackTrace: s);
      return 'Error: Could not generate a response.';
    }
  }

  // --- INTERACTIVE CHAT SIMULATOR METHODS ---
  void startChatSession(String personaPrompt) {
    chat = _chatModel.startChat(history: [Content.text(personaPrompt)]);
  }

  Future<ChatMessage> continueChat(String message) async {
    if (chat == null) {
      throw Exception("Chat session not started.");
    }
    try {
      final response = await chat!.sendMessage(Content.text(message));
      final functionCall = response.functionCalls.first;
      final jsonResponse = {
        for (final key in functionCall.args.keys)
          key: functionCall.args[key]
      };
      return ChatMessage(
        text: jsonResponse['response'] as String,
        sender: ChatSender.subject,
        feedback: jsonResponse['feedback'] as String,
        reportCardNote: jsonResponse['report_card_note'] as String,
        dynamicEvent: jsonResponse['dynamic_event'] as String?,
      );
    } catch (e, s) {
      dev.log('Error in continueChat', name: 'GeminiService', error: e, stackTrace: s);
      return ChatMessage(
        text: "A system error occurred. The AI's response could not be understood. Please try a different input or restart.",
        sender: ChatSender.system,
      );
    }
  }
}

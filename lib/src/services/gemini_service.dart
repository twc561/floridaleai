import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_ai/firebase_ai.dart';
import 'package:myapp/src/models/field_simulator/chat_message.dart';
import 'package:myapp/src/models/field_simulator/report_card.dart';

import 'gemini_scenario_prompts.dart';

class GeminiService {
  final String apiKey;
  final FirebaseAI _firebaseAI;
  ChatSession? _chatSession;

  GeminiService({required this.apiKey}) : _firebaseAI = FirebaseAI.googleAI();

  GenerativeModel _getModel(String personaPrompt) {
    return _firebaseAI.generativeModel(
      model: 'gemini-1.5-pro',
      systemInstruction: Content.text(personaPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.9,
        topK: 1,
        topP: 1,
        maxOutputTokens: 2048,
      ),
    );
  }

  void startChatSession(String personaPrompt) {
    developer.log('Starting new chat session.', name: 'com.myapp.gemini');
    _chatSession = _getModel(personaPrompt).startChat();
  }

  Future<ChatMessage> continueChat(String text) async {
    if (_chatSession == null) {
      throw Exception(
          'Chat session not started. Call startChatSession first.');
    }

    developer.log('Sending message to Gemini: $text',
        name: 'com.myapp.gemini');
    final response = await _chatSession!.sendMessage(Content.text(text));
    final aiResponse = response.text;

    if (aiResponse == null) {
      developer.log('Received null response from Gemini.',
          name: 'com.myapp.gemini', level: 900);
      return const ChatMessage(
        text: 'Sorry, I did not understand that. Please try again.',
        sender: ChatSender.system,
        feedback: 'The model returned an empty response.',
        reportCardNote: 'Model failed to generate a valid response.',
      );
    }

    developer.log('Received raw response from Gemini: $aiResponse',
        name: 'com.myapp.gemini');
    return _parseAiResponse(aiResponse);
  }

  ChatMessage _parseAiResponse(String response) {
    try {
      // Find the start and end of the JSON object
      final startIndex = response.indexOf('{');
      final endIndex = response.lastIndexOf('}');

      if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
        final jsonString = response.substring(startIndex, endIndex + 1);
        final jsonResponse = jsonDecode(jsonString) as Map<String, dynamic>;
        return ChatMessage.fromJson(jsonResponse);
      } else {
        throw const FormatException('No valid JSON object found in the response.');
      }
    } catch (e) {
      developer.log(
        'Error parsing JSON response from Gemini.',
        name: 'com.myapp.gemini',
        level: 1000,
        error: e,
        stackTrace: StackTrace.current,
      );
      return ChatMessage(
        text: 'The model provided an invalid response. Please try again.\n\n*Raw response:*\n`$response`',
        sender: ChatSender.system,
        feedback:
            'Failed to parse the AI\'s JSON response. This may be a model error.',
        reportCardNote: 'Model returned a malformed JSON response.',
      );
    }
  }

  Future<String> getSearchAndSeizureAdvice(String scenario) async {
    try {
      final model = _getModel(searchAndSeizurePersonaPrompt);
      final response = await model.generateContent([
        Content.text('Analyze this search and seizure scenario: $scenario'),
      ]);
      return response.text ?? 'No response from model.';
    } catch (e) {
      developer.log(
        'Error getting search and seizure advice: $e',
        name: 'com.myapp.gemini',
        level: 1000,
        error: e,
      );
      return 'Error generating advice: $e';
    }
  }

  Future<String> generateReportFromNotes(String notes) async {
    try {
      final model = _getModel(incidentReportPersonaPrompt);
      final response = await model.generateContent([
        Content.text(
            'Generate a formal police incident report based on the following notes:\n\n$notes'),
      ]);
      return response.text ??
          'Could not generate a report from the provided notes.';
    } catch (e) {
      developer.log(
        'Error generating report from notes: $e',
        name: 'com.myapp.gemini',
        level: 1000,
        error: e,
      );
      return 'Error generating report: $e';
    }
  }

  Future<String> generateIncidentReport(ReportCard reportCard) async {
    try {
      final model = _getModel(incidentReportPersonaPrompt);
      final prompt =
          'Generate a formal police incident report based on the following scenario and officer actions:\n\n${_reportCardToPrompt(reportCard)}';
      final response = await model.generateContent([
        Content.text(prompt),
      ]);
      return response.text ??
          'Could not generate a report from the provided data.';
    } catch (e) {
      developer.log(
        'Error generating incident report: $e',
        name: 'com.myapp.gemini',
        level: 1000,
        error: e,
      );
      return 'Error generating report: $e';
    }
  }

  String _reportCardToPrompt(ReportCard reportCard) {
    final buffer = StringBuffer();
    buffer.writeln('Scenario: ${reportCard.scenarioTitle}');
    buffer.writeln('Learning Objectives:');
    for (final objective in reportCard.learningObjectives) {
      buffer.writeln('- $objective');
    }
    buffer.writeln('\nOfficer Actions (Performance Notes):');
    for (final note in reportCard.performanceNotes) {
      buffer.writeln('- $note');
    }
    buffer.writeln(
        '\nOverall Performance: ${reportCard.overallPerformance.toString().split('.').last}');
    return buffer.toString();
  }
}

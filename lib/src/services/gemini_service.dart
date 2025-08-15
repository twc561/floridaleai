
import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService()
      : _model = FirebaseVertexAI.instance.generativeModel(
          model: 'gemini-1.5-flash',
          generationConfig: GenerationConfig(
            temperature: 0.4,
            topK: 1,
            topP: 1,
            maxOutputTokens: 2048,
          ),
        );

  Future<String> generateText(String prompt) async {
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      if (response.text == null) {
        throw Exception('No response from model.');
      }
      return response.text!;
    } catch (e) {
      throw Exception('Error generating text: $e');
    }
  }
}

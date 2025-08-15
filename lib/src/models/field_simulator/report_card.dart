
import 'package:myapp/src/models/field_simulator/chat_message.dart';

enum OverallPerformance { excellent, needsImprovement }

class ReportCard {
  final String scenarioTitle;
  final List<String> learningObjectives;
  final List<String> performanceNotes;
  final OverallPerformance overallPerformance;
  final List<ChatMessage> chatHistory;


  ReportCard({
    required this.scenarioTitle,
    required this.learningObjectives,
    required this.performanceNotes,
    required this.overallPerformance,
    required this.chatHistory,
  });
}

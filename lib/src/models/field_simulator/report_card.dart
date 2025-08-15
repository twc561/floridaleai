enum OverallPerformance { excellent, good, needsImprovement }

class ReportCard {
  final String scenarioTitle;
  final List<String> learningObjectives;
  final List<String> performanceNotes; // These are the 'report_card_note' items from the chat
  final OverallPerformance overallPerformance;

  ReportCard({
    required this.scenarioTitle,
    required this.learningObjectives,
    required this.performanceNotes,
    required this.overallPerformance,
  });
}

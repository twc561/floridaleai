
class Statute {
  final String title;
  final String content;
  final String severity;
  final List<String> enhancements;
  final Map<String, String> subsections;
  final List<String> examples;
  final List<String> relatedCaseLaw;

  Statute({
    required this.title,
    required this.content,
    required this.severity,
    this.enhancements = const [],
    this.subsections = const {},
    this.examples = const [],
    this.relatedCaseLaw = const [],
  });
}

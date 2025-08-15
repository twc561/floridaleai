
// Represents a single case law entry.
class CaseLaw {
  final String title;
  final String citation;
  final String date;
  final String court;
  final String summary;
  final String fullText; // The full text or detailed analysis of the ruling.
  final List<String> keywords;

  CaseLaw({
    required this.title,
    required this.citation,
    required this.date,
    required this.court,
    required this.summary,
    required this.fullText,
    required this.keywords,
  });
}

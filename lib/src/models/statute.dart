class Statute {
  final String number;
  final String title;
  final String fullText;

  Statute({required this.number, required this.title, required this.fullText});

  factory Statute.fromJson(Map<String, dynamic> json) {
    return Statute(
      number: json['number'],
      title: json['title'],
      fullText: json['fullText'],
    );
  }
}

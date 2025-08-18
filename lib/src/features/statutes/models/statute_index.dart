
class StatuteIndex {
  final String id;
  final String title;
  final String code;
  final String category;
  final String degreeOfCharge;
  final String difficulty;

  StatuteIndex({
    required this.id,
    required this.title,
    required this.code,
    required this.category,
    required this.degreeOfCharge,
    required this.difficulty,
  });

  factory StatuteIndex.fromJson(Map<String, dynamic> json) {
    return StatuteIndex(
      id: json['id'],
      title: json['title'],
      code: json['code'],
      category: json['category'],
      degreeOfCharge: json['degreeOfCharge'],
      difficulty: json['difficulty'],
    );
  }
}

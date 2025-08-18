
import 'dart:convert';

class Statute {
  final String id;
  final String title;
  final String code;
  final String description;
  final String practicalSummary;
  final List<String> elementsOfTheCrime;
  final String degreeOfCharge;
  final String difficulty;
  final String category;
  final List<String> relatedStatutes;
  final String realWorldExample;
  final List<String> investigativeTips;
  final List<String> commonMistakes;
  final DateTime lastUpdated;
  final int popularity;
  bool isFavorite;

  Statute({
    required this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.practicalSummary,
    required this.elementsOfTheCrime,
    required this.degreeOfCharge,
    required this.difficulty,
    required this.category,
    required this.relatedStatutes,
    required this.realWorldExample,
    required this.investigativeTips,
    required this.commonMistakes,
    required this.lastUpdated,
    required this.popularity,
    this.isFavorite = false,
  });

  factory Statute.fromJson(Map<String, dynamic> json) {
    return Statute(
      id: json['id'],
      title: json['title'],
      code: json['code'],
      description: json['description'],
      practicalSummary: json['practicalSummary'],
      elementsOfTheCrime: List<String>.from(json['elementsOfTheCrime']),
      degreeOfCharge: json['degreeOfCharge'],
      difficulty: json['difficulty'],
      category: json['category'],
      relatedStatutes: List<String>.from(json['relatedStatutes']),
      realWorldExample: json['realWorldExample'],
      investigativeTips: List<String>.from(json['investigativeTips']),
      commonMistakes: List<String>.from(json['commonMistakes']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      popularity: json['popularity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'description': description,
      'practicalSummary': practicalSummary,
      'elementsOfTheCrime': elementsOfTheCrime,
      'degreeOfCharge': degreeOfCharge,
      'difficulty': difficulty,
      'category': category,
      'relatedStatutes': relatedStatutes,
      'realWorldExample': realWorldExample,
      'investigativeTips': investigativeTips,
      'commonMistakes': commonMistakes,
      'lastUpdated': lastUpdated.toIso8601String(),
      'popularity': popularity,
    };
  }
}

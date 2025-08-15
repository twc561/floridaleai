
import 'package:flutter/foundation.dart';

@immutable
class StatuteResponse {
  final String summary;
  final List<StatuteSection> sections;

  const StatuteResponse({
    required this.summary,
    required this.sections,
  });

  factory StatuteResponse.fromJson(Map<String, dynamic> json) {
    final sectionsList = json['sections'] as List;
    final sections = sectionsList
        .map((sectionJson) => StatuteSection.fromJson(sectionJson as Map<String, dynamic>))
        .toList();
    return StatuteResponse(
      summary: json['summary'] as String,
      sections: sections,
    );
  }
}

@immutable
class StatuteSection {
  final String type;
  final String content;

  const StatuteSection({
    required this.type,
    required this.content,
  });

  factory StatuteSection.fromJson(Map<String, dynamic> json) {
    return StatuteSection(
      type: json['type'] as String,
      content: json['content'] as String,
    );
  }
}

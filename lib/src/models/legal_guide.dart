
import 'package:flutter/material.dart';
import 'package:myapp/src/models/guide_section.dart';

class LegalGuide {
  final String id;
  final String title;
  final String summary;
  final IconData icon;
  final List<GuideSection> sections;

  LegalGuide({
    required this.id,
    required this.title,
    required this.summary,
    required this.icon,
    required this.sections,
  });
}

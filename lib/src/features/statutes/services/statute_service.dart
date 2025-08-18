
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:myapp/src/features/statutes/models/statute.dart';
import 'package:myapp/src/features/statutes/models/statute_index.dart';

class StatuteService {
  Future<List<StatuteIndex>> getStatuteIndex() async {
    final String response = await rootBundle.loadString('assets/data/statute_index.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => StatuteIndex.fromJson(json)).toList();
  }

  Future<Statute> getStatuteById(String id) async {
    final String response = await rootBundle.loadString('assets/data/statutes_full_data.json');
    final Map<String, dynamic> data = json.decode(response);
    return Statute.fromJson(data[id]);
  }

  Future<List<Statute>> getAllStatutes() async {
    final String response = await rootBundle.loadString('assets/data/statutes_full_data.json');
    final Map<String, dynamic> data = json.decode(response);
    return data.values.map((json) => Statute.fromJson(json)).toList();
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';

// Define a class to represent the facts
class Fact {
  final String fact;
  final String source;

  Fact({
    required this.fact,
    required this.source,
  });

  // Factory method to create a Fact from a JSON object
  factory Fact.fromJson(Map<String, dynamic> json) {
    return Fact(
      fact: json['fact'],
      source: json['source'],
    );
  }
}

// Define a class to hold the list of facts
class FactList {
  final List<Fact> facts;

  FactList({required this.facts});

  // Factory method to create a FactList from JSON
  factory FactList.fromJson(Map<String, dynamic> json) {
    var factsFromJson = json['facts'] as List;
    List<Fact> factList =
        factsFromJson.map((factJson) => Fact.fromJson(factJson)).toList();

    return FactList(facts: factList);
  }
}

// Function to load the JSON file and parse it
Future<FactList> loadFacts() async {
  // Load the JSON file from the assets
  String jsonString = await rootBundle.loadString('lib/assets/json/facts.json');

  // Parse the JSON string into a Map
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);

  // Return the parsed object
  return FactList.fromJson(jsonMap);
}

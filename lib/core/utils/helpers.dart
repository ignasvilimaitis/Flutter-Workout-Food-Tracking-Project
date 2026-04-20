import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

// Helper function to read JSON file from assets
Future<dynamic> readJson(final String path) async {
  final String resp = await rootBundle.loadString(path);
  return await jsonDecode(resp);
}

double getNutrientAmount(List nutrients, String nutrientName) {
  final match = nutrients.firstWhere(
    (n) => (n['nutrient']['name'] as String).toLowerCase().contains(nutrientName.toLowerCase()),
    orElse: () => null,
  );

  if (match == null) return 0.0;
  return (match["amount"] as num?)?.toDouble() ?? 0.0;
}

Map<String, dynamic> usdaToDb(Map<String, dynamic> json) {
  final nutrients = json["foodNutrients"] ?? [];

  // Serving size formatting
  String servingSize = "Unknown";
  if (json["foodPortions"] != null && json["foodPortions"].isNotEmpty) {
    final p = json["foodPortions"][0];
    servingSize =
        "${p['amount']} ${p['measureUnit']['abbreviation'] ?? p['measureUnit']['name']} "
        "(${p['gramWeight']} g)";
  }

  return {
    "name": json["description"],
    "brand": null,
    "calories": getNutrientAmount(nutrients, "Energy"),
    "carbohydrates": getNutrientAmount(nutrients, "Carbohydrate, by difference"),
    "fat": getNutrientAmount(nutrients, "Total lipid (fat)"),
    "protein": getNutrientAmount(nutrients, "Protein"),
    "nutrients": jsonEncode(nutrients),
    "serving_Size": servingSize,
    "is_favourite": 0,                    
    "is_custom": 0,                      
    "last_used": 0                     
  };

  
}

Future<void> importUsdaFoodsFromAsset(String assetPath, Database db) async {
  final jsonMap = await readJson(assetPath);

  final foods = jsonMap["FoundationFoods"] as List;

  for (final food in foods) {
    final map = usdaToDb(food);
    await db.insert("FoodItem", map);
  }
  
}

String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}
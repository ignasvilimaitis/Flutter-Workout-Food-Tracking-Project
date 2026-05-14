import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart';

/// Helper function to read JSON file from assets
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


/// Apply a color to a specific [idToColor] in an SVG element. 
/// 
/// Parses the [rawSvg] XML file to locate the ID and apply a styling to it.
/// 
/// [idToColor] is a map of the target ID and the HEX color to be applied e.g., {'pathId': '#fff', 'groupId': '#000'}
String applyColorsToSvg(String rawSvg, Map<String, String> idToColor) {
  final document = XmlDocument.parse(rawSvg);

  for (final element in document.descendantElements) {
    final id = element.getAttribute('id');
    if (id != null && idToColor.containsKey(id)) {
      final color = idToColor[id];
      final existingStyle = element.getAttribute('style') == null ? '' : '${element.getAttribute('style')};';

      element.setAttribute('style', '${existingStyle}fill:$color;fill-opacity:.8;stroke-width:0.25;stroke: #000;');
      
      // Remove child elements fill attribute.
      for (final child in element.childElements){
        child.removeAttribute('style');
      }
    }
  }
  return document.toXmlString();
}

/// Because the "Color" class that deals with explicitly colors doesn't have a way to
/// return a color in its hex form.
String colorToHex(Color? color){
  if (color != null) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }
  return '#fff';
}
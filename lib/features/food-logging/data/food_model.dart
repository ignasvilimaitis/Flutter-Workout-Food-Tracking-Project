import 'package:openfoodfacts/openfoodfacts.dart';

class FoodItem {

  final int id;
  final String name;
  final String? brand;
  final double calories;
  final double carbs; 
  final double fats;
  final double proteins;
  final String? nutriments;
  final String servingSize;
  final bool isFavourite;
  final bool isCustom;
  final DateTime? lastUsed;

  FoodItem( {
    required this.id,
    this.brand,
    required this.name,
    required this.calories,
    required this.carbs,
    required this.fats,
    required this.proteins,
    required this.nutriments,
    required this.servingSize,
    required this.isFavourite,
    required this.isCustom,
    this.lastUsed,
  });



  factory FoodItem.fromMap(Map<String, dynamic> map) {
    final lastActive = DateTime.fromMillisecondsSinceEpoch(map['last_used'] * 1000);
    return FoodItem(
        id: map["pk_fooditem_id"],
        name: map["name"],
        brand: map["brand"],
        calories: map["calories"],
        carbs: map["carbohydrates"],
        fats: map["fat"],      
        proteins: map["protein"],
        nutriments: map["nutrients"],
        servingSize: map["serving_size"],
        isFavourite: map["is_favourite"] == 1,
        isCustom: map["is_custom"] == 1,
        lastUsed: lastActive,
        
    );
  }

}
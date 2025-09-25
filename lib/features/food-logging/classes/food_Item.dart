import 'package:openfoodfacts/openfoodfacts.dart';

class FoodItem {

  FoodItem( {
    required this.brand,
    required this.ingredientsText,
    required this.productName,
    required this.calories,
    required this.carbs,
    required this.fats,
    required this.proteins,
    required this.nutriments,
  });

  final String? brand;
  String? ingredientsText;
  final String productName;
  final double calories;
  final double carbs; // TODO: per serving size or per 100g?
  final double fats;
  final double proteins;
  final Nutriments? nutriments;

  factory FoodItem.fromMap(Map<String, dynamic> json) => FoodItem(
        calories: json["energy-kcal_100g"],
        brand: json["brands"],
        carbs: json["carbohydrates_100g"],
        fats: json["fat_100g"],
        ingredientsText: json["ingredients_text"],
        productName: json["product_name"],
        proteins: json["proteins_100g"],
        nutriments: json[""]
      );

  Map<String, dynamic> toMap() => {
        "brands": brand,
        "carbohydrates_100g": carbs,
        "fat_100g": fats,
        "ingredients_text": ingredientsText,
        "product_name": productName,
        "proteins_100g": proteins,
      };
}
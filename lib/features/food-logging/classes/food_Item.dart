class FoodItem {
  final String name;
  final double calories;
  final double carbs;
  final double fats;
  final double proteins;

  FoodItem({
    required this.name,
    required this.calories,
    required this.carbs,
    required this.fats,
    required this.proteins
  });

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is FoodItem &&
//           runtimeType == other.runtimeType &&
//           name == other.name && calories == other.calories &&
//           carbs == other.carbs && fats == other.fats &&
//            proteins == other.proteins;
           
//   @override
//   int get hashCode => name.hashCode ^ calories.hashCode;
// 
}
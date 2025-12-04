import 'package:flutter_application_1/features/food-logging/data/food_data_source.dart';
import 'package:flutter_application_1/features/food-logging/data/food_model.dart';


class ExerciseRepository {
  final FoodDataSource dataSource;

  ExerciseRepository(this.dataSource);

  Future<List<FoodItem>> getSearchedFoods(String input) async {
    return await dataSource.getSearchedFoods(input);
  }
}
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class GetQuery {
  Future<Product?> fetchProduct() async {
    final String barcode = '737628064502';
    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage
          .ENGLISH, // TODO: Here you call set the language of the user
      fields: [ProductField.ALL],
      version: ProductQueryVersion.v3,
    );
    final ProductResultV3 result = await OpenFoodAPIClient.getProductV3(
      configuration,
    );

    if (result.status != ProductResultV3.statusSuccess) {
      // Error handling
      throw Exception(
        'Failed to load product: ${result.status} - ${result.status}',
      );
    }
    return result.product;
  }

  Future<SearchResult?> searchProducts(String query) async {
    final ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(
          parametersList: [
            SearchTerms(terms: [query]),
          ],
          version: ProductQueryVersion.v3,
          fields: [ProductField.ALL],
        );
    final SearchResult result = await OpenFoodAPIClient.searchProducts(
      User(
        userId: "test",
        password: "test",
      ), // TODO: Here you should use the user credentials
      configuration,
    );

    if (result.products == null || result.products!.isEmpty) {
      // No products found
      return null;
    }

    return result;
  }

  List<FoodItem> getSearchResults(SearchResult? result) {
    List<Product>? products = result?.products;
    List<FoodItem> foods = products?.map((product) {
          final nutr = product.nutriments;

          // helper to read most nutrients per 100g
          double _get(Nutrient n) =>
              nutr?.getValue(n, PerSize.oneHundredGrams) ?? 0.0;
          // Gotta use helper methods for all the macros since they removed direct getters, e.g. product.carbohydrates
          // -- now you have to read through enum values

          // Calories: prefer kcal; if not available, try kJ -> convert to kcal (1 kcal = 4.184 kJ)
          double _getCalories() {
            final kcal = nutr?.getValue(
              Nutrient.energyKCal,
              PerSize.oneHundredGrams,
            );
            if (kcal != null) return kcal;
            final kj = nutr?.getComputedKJ(PerSize.oneHundredGrams);
            if (kj != null) return kj / 4.184;
            return 0.0;
          }

          return FoodItem(
            brand: product.brands ?? 'Unknown Brand',
            productName: product.productName ?? 'Unknown Product',
            calories: _getCalories(),
            carbs: _get(Nutrient.carbohydrates),
            fats: _get(Nutrient.fat),
            proteins: _get(Nutrient.proteins),
            ingredientsText: product.ingredientsText ?? 'No ingredients listed',
          );
        }).toList() ??
        [];

        return foods;
  }
}

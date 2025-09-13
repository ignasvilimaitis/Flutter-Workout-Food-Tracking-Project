
import 'package:openfoodfacts/openfoodfacts.dart';

class GetQuery {

  Future<Product?> fetchProduct() async {
    final String barcode = '737628064502';
    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage.ENGLISH, // TODO: Here you call set the language of the user
      fields: [ProductField.ALL],
      version: ProductQueryVersion.v3,
    );
    final ProductResultV3 result = await OpenFoodAPIClient.getProductV3(
      configuration,
    );

    if (result.status != ProductResultV3.statusSuccess) {
      // Error handling
      throw Exception('Failed to load product: ${result.status} - ${result.status}');
    }
    return result.product;
  }

  Future<SearchResult?> searchProducts(String query) async {
    final ProductSearchQueryConfiguration configuration = ProductSearchQueryConfiguration(
      parametersList: [
        SearchTerms(terms: [query]),

      ],
      version: ProductQueryVersion.v3,
      fields: [ProductField.ALL],
    );
    final SearchResult result = await OpenFoodAPIClient.searchProducts(
      User(userId: "test", password: "test"), // TODO: Here you should use the user credentials
      configuration,
    );

    if (result.products == null || result.products!.isEmpty) {
      // No products found
      return null;
    }

    return result;
}
}
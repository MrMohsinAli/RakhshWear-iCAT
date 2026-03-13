import 'package:smart_ecommerce_app/models/data_models.dart';
import 'package:smart_ecommerce_app/services/generated_product_database.dart';

class BackendService {
  // Returns all products
  static List<Product> get products => GeneratedProductDatabase.products;

  /// Attempts to place an order for a specific product size.
  /// Validates stock availability and decrements the quantity if available.
  /// Returns true if the order was placed successfully, false otherwise.
  static bool placeOrder(String productId, String size, int quantity) {
    // 1. Find product
    final index =
        products.indexWhere((p) => p.id == productId);
    if (index == -1) return false;

    final product = products[index];
    
    // 2. Validate stock
    if (!product.inventory.containsKey(size)) return false;
    final currentStock = product.inventory[size]!;

    if (currentStock >= quantity) {

      // 3. Decrement stock
      product.inventory[size] = currentStock - quantity;
      return true;
    }

    // Insufficient stock
    return false;
  }
}

import 'package:smart_ecommerce_app/models/data_models.dart';
import 'package:smart_ecommerce_app/services/backend_service.dart';

class MockDataService {
  static final List<Category> categories = [
    const Category(
      id: 'shirts',
      title: 'Shirts',
      subcategories: ['Polos', 'Tees', 'Formals'],
    ),
    const Category(
      id: 'bottoms',
      title: 'Bottoms',
      subcategories: ['Jeans', 'Denim', 'Chinos', 'Shorts'],
    ),
    const Category(
      id: 'outerwear',
      title: 'Outerwear',
      subcategories: ['Jackets', 'Blazers', 'Hoodies', 'Shawls'],
    ),
    const Category(
      id: 'knitwear',
      title: 'Knitwear',
      subcategories: ['Sweaters', 'Sweatshirts', 'Mufflers'],
    ),
    const Category(
      id: 'kurta-shalwar',
      title: 'Traditional',
      subcategories: ['Kameez Shalwar', 'Kurta Trouser', 'Unstitched Fabric'],
    ),
    const Category(
      id: 'footwear',
      title: 'Footwear',
      subcategories: ['Casual', 'Comfort', 'Sandals', 'Sneakers', 'Formal'],
    ),
    const Category(
      id: 'accessories',
      title: 'Accessories',
      subcategories: ['Glasses', 'Belts', 'Caps'],
    ),
    const Category(
      id: 'fragrances',
      title: 'Fragrances',
      subcategories: ['Perfumes', 'Body Spray', 'Attar'],
    ),
  ];

  static List<Product> get products => BackendService.products;

  static List<Product> getProductsByCategory(String categoryId) {
    if (categoryId == 'new-arrivals' || categoryId == 'sale') {
      return products;
    }
    return products.where((p) => p.categoryId == categoryId).toList();
  }

  static Product? getProductById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Product> getRelatedProducts(String categoryId, String currentProductId, int count) {
    var related = products
        .where((p) => p.categoryId == categoryId && p.id != currentProductId)
        .toList();
    related.shuffle();
    return related.take(count).toList();
  }

  static int getSubcategoryPriority(String subcategory) {
    final sub = subcategory.toLowerCase();
    
    // Tops / Shirts / Jackets (Priority 1)
    final tops = ['polos', 'tees', 'formals', 'jackets', 'blazers', 'hoodies', 'shawls', 'sweaters', 'sweatshirts', 'kameez shalwar', 'kurta trouser'];
    if (tops.contains(sub)) return 1;

    // Bottoms (Priority 2)
    final bottoms = ['jeans', 'denim', 'chinos', 'shorts', 'unstitched fabric'];
    if (bottoms.contains(sub)) return 2;

    // Footwear (Priority 3)
    final footwear = ['casual', 'comfort', 'sandals', 'sneakers', 'formal'];
    if (footwear.contains(sub)) return 3;

    // Accessories & Others (Priority 4)
    final accessories = ['glasses', 'belts', 'caps', 'mufflers', 'perfumes', 'body spray', 'attar'];
    if (accessories.contains(sub)) return 4;

    return 5;
  }

  static List<Product> sortProductsByPriority(List<Product> products) {
    final sorted = List<Product>.from(products);
    sorted.sort((a, b) {
      final priorityA = getSubcategoryPriority(a.subcategory);
      final priorityB = getSubcategoryPriority(b.subcategory);
      
      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }
      // If same priority, sort by isNew (newest first)
      if (a.isNew != b.isNew) return a.isNew ? -1 : 1;
      // Finally, alphabetically
      return a.title.compareTo(b.title);
    });
    return sorted;
  }
}

class Category {
  final String id;
  final String title;
  final String? imageUrl;
  final List<String> subcategories;

  const Category({
    required this.id,
    required this.title,
    this.imageUrl,
    this.subcategories = const [],
  });
}

class Review {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class Product {
  final String id;
  final String title;
  final String price;
  final List<String> images;
  final String description;
  final String categoryId;
  final String subcategory;
  final List<Review> reviews;
  final Map<String, int> inventory;
  final Map<String, String>? sizePrices;
  final bool isNew;
  final bool isSale;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.images,
    required this.description,
    required this.categoryId,
    required this.subcategory,
    this.reviews = const [],
    this.inventory = const {'S': 10, 'M': 5, 'L': 5, 'XL': 0},
    this.sizePrices,
    this.isNew = false,
    this.isSale = false,
  });

  String getPriceForSize(String size) {
    if (sizePrices != null && sizePrices!.containsKey(size)) {
      return sizePrices![size]!;
    }
    return price;
  }
}

class CartItem {
  final Product product;
  final String selectedSize;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'productId': product.id,
        'selectedSize': selectedSize,
        'quantity': quantity,
      };

  double get totalPrice {
    final effectivePrice = product.getPriceForSize(selectedSize);
    final priceString = effectivePrice.replaceAll(RegExp(r'[^0-9]'), '');
    final price = double.tryParse(priceString) ?? 0.0;
    return price * quantity;
  }
}


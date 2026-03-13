import 'dart:convert';

import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:smart_ecommerce_app/data/review_data.dart';
import 'package:smart_ecommerce_app/models/data_models.dart';
import 'package:smart_ecommerce_app/services/backend_service.dart';
import 'package:http/http.dart' as http;
import 'package:smart_ecommerce_app/services/mock_data_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  String? _userId;

  List<CartItem> get items => _items;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void setUserId(String? id) {
    _userId = id;
  }

  void restoreCart(List<CartItem> items) {
    _items = items;
    notifyListeners();
  }

  Future<void> _syncToBackend() async {
    if (_userId == null) return;
    try {
      final cartJson = jsonEncode(_items.map((i) => i.toJson()).toList());
      await http.post(
        Uri.parse('http://127.0.0.1:5000/update_cart'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': _userId,
          'cart_data': cartJson,
        }),
      );
    } catch (e) {
      debugPrint('Sync error: $e');
      // Background sync failed, ignore for now
    }
  }

  bool addToCart(Product product, String size) {
    final existingIndex = _items.indexWhere(
        (item) => item.product.id == product.id && item.selectedSize == size);

    // Check stock limit
    final stockLimit = product.inventory.isEmpty
        ? null // no-size products (shawls, etc.) — unlimited
        : (product.inventory[size] ?? 0);

    if (existingIndex >= 0) {
      // Already in cart — only increment if below stock limit
      if (stockLimit == null || _items[existingIndex].quantity < stockLimit) {
        _items[existingIndex].quantity++;
        notifyListeners();
        _syncToBackend();
        return true;
      } else {
        // At stock limit — do nothing
        return false;
      }
    } else {
      if (stockLimit == null || stockLimit > 0) {
        _items.add(CartItem(product: product, selectedSize: size));
        notifyListeners();
        _syncToBackend();
        return true;
      }
      return false;
    }
  }

  void decrementQuantity(String productId, String size) {
    final index = _items.indexWhere(
        (item) => item.product.id == productId && item.selectedSize == size);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
      _syncToBackend();
    }
  }

  void removeFromCart(String productId, String size) {
    _items.removeWhere(
        (item) => item.product.id == productId && item.selectedSize == size);
    notifyListeners();
    _syncToBackend();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _syncToBackend();
  }

  /// Attempts to checkout all items in the cart.
  /// Returns true if all items were successfully ordered (stock available),
  /// or false if any item failed stock validation. In a real app,
  bool checkout() {
    bool allSuccess = true;
    for (var item in _items) {
      final success = BackendService.placeOrder(
        item.product.id,
        item.selectedSize,
        item.quantity,
      );
      if (!success) {
        allSuccess = false;
        // Depending on requirements, we could break here or continue
      }
    }

    if (allSuccess) {
      clearCart();
    }
    return allSuccess;
  }
}

class WishlistProvider extends ChangeNotifier {
  final List<Product> _wishlist = [];

  List<Product> get wishlist => _wishlist;

  bool isInWishlist(String productId) {
    return _wishlist.any((item) => item.id == productId);
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      _wishlist.removeWhere((item) => item.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }
}

class AuthProvider extends ChangeNotifier {
  final CartProvider cartProvider;
  
  bool _isLoggedIn = false;
  String _userName = '';
  String? _userId;

  AuthProvider(this.cartProvider);

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String? get userId => _userId;

  void login(String name, String id) {
    _isLoggedIn = true;
    _userName = name;
    _userId = id;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _userId = null;
    cartProvider.setUserId(null);
    cartProvider.clearCart();
    notifyListeners();
  }
}

// ── ReviewProvider
// Fetches and saves reviews to the python backend instead of local storage,
// allowing reviews to persist across app restarts and multiple devices.

class ReviewProvider extends ChangeNotifier {
  final Map<String, List<Review>> _productReviews = {};
  final Map<String, bool> _hasFetchedBackend = {};

  /// Returns reviews for [productId]. If not fetched yet from the backend,
  /// it initiates a fetch and temporarily returns the local seed reviews.
  List<Review> getUserReviews(String productId) {
    if (_hasFetchedBackend[productId] != true) {
      _hasFetchedBackend[productId] = true;
      _fetchReviewsFromBackend(productId);
    }

    if (_productReviews.containsKey(productId)) {
      return _productReviews[productId]!;
    }
    
    // Fallback immediately so UI is not empty while loading
    return ReviewData.seedReviews[productId] ?? [];
  }

  /// Adds a new review for [productId] locally for immediate UI update,
  /// and persists it to the backend.
  void addReview(String productId, Review review) {
    if (!_productReviews.containsKey(productId)) {
       _productReviews[productId] = List.from(ReviewData.seedReviews[productId] ?? []);
    }
    
    _productReviews[productId]!.insert(0, review); // newest first
    notifyListeners();

    _saveReviewToBackend(productId, review);
  }

  Future<void> _fetchReviewsFromBackend(String productId) async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/get_reviews/$productId'));
      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        _productReviews[productId] = decoded.map((e) {
          final m = e as Map<String, dynamic>;
          return Review(
            id: m['id'] as String,
            userName: m['userName'] as String,
            rating: (m['rating'] as num).toDouble(),
            comment: m['comment'] as String,
            date: DateTime.parse(m['date'] as String),
          );
        }).toList();
        notifyListeners();
      }
    } catch (_) {
      // Backend unavailable; ignore
    }
  }

  Future<void> _saveReviewToBackend(String productId, Review review) async {
    try {
      await http.post(
        Uri.parse('http://127.0.0.1:5000/add_review'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'product_id': productId,
          'user_name': review.userName,
          'rating': review.rating,
          'comment': review.comment,
        }),
      );
    } catch (_) {}
  }
}

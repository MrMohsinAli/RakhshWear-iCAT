import 'dart:convert';
import 'dart:io';
import 'package:smart_ecommerce_app/services/generated_product_database.dart';
import 'package:smart_ecommerce_app/models/data_models.dart';

void main() {
  final List<Map<String, dynamic>> productsJson = GeneratedProductDatabase.products.map((p) {
    return {
      'id': p.id,
      'title': p.title,
      'price': p.price,
      'images': p.images,
      'description': p.description,
      'categoryId': p.categoryId,
      'subcategory': p.subcategory,
      'reviews': p.reviews.map((r) => {
        'id': r.id,
        'userName': r.userName,
        'rating': r.rating,
        'comment': r.comment,
        'date': r.date.toIso8601String(),
      }).toList(),
      'inventory': p.inventory,
      'sizePrices': p.sizePrices,
      'isNew': p.isNew,
      'isSale': p.isSale,
    };
  }).toList();
  
  File('products.json').writeAsStringSync(jsonEncode(productsJson));
  print('Export complete');
}

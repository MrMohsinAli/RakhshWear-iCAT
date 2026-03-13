// ignore_for_file: avoid_print
import 'dart:io';


void main() async {
  final productsDir = Directory('assets/products');
  if (!productsDir.existsSync()) {
    print('Error: assets/products directory not found.');
    return;
  }

  List<String> assetPaths = [];
  List<Map<String, dynamic>> productsData = [];
  int idCounter = 1;

  print('Scanning categories in assets/products...');
  final categoryDirs = productsDir.listSync().whereType<Directory>();
  
  for (final categoryDir in categoryDirs) {
    final rootCategoryName = categoryDir.path.split(Platform.pathSeparator).last;
    final subcategoryDirs = categoryDir.listSync().whereType<Directory>();
    
    for (final subDir in subcategoryDirs) {
      final subcategoryName = subDir.path.split(Platform.pathSeparator).last;
      
      final productDirs = subDir.listSync().whereType<Directory>();
      for (final productDir in productDirs) {
        final productName = productDir.path.split(Platform.pathSeparator).last;
        final imageFiles = productDir.listSync().whereType<File>().where((f) => 
            f.path.endsWith('.png') || f.path.endsWith('.jpg') || f.path.endsWith('.jpeg')).toList();
        
        List<String> images = [];
        if (imageFiles.isNotEmpty) {
          // Add the root folder to pubspec paths
          final assetRelativePath = productDir.path.replaceAll('\\', '/');
          assetPaths.add('- $assetRelativePath/'); 
          
          images = imageFiles.map((f) => f.path.replaceAll('\\', '/')).toList();
        }

        productsData.add({
          'id': 'gen_$idCounter',
          'title': productName.replaceAll('_', ' '),
          'price': 'PKR 2500', // Default mock price
          'images': images,
          'description': 'A high-quality product from $rootCategoryName - $subcategoryName.',
          'categoryId': rootCategoryName.toLowerCase().replaceAll(' ', '-'),
          'subcategory': subcategoryName,
        });
        idCounter++;
      }
    }
  }

  print('Found ${productsData.length} products.');

  // Generate Dart file
  final fileContent = '''
import 'package:smart_ecommerce_app/models/data_models.dart';

class GeneratedProductDatabase {
  static final List<Product> products = [
${productsData.map((p) {
  final pi = _getPriceAndInventory(p['categoryId'] as String, p['subcategory'] as String, p['id'] as String);
  return '''
    Product(
      id: '${p['id']}',
      title: '${p['title']}',
      price: '${pi['price']}',
      images: [${(p['images'] as List).map((i) => "'$i'").join(', ')}],
      description: '${p['description']}',
      categoryId: '${p['categoryId']}',
      subcategory: '${p['subcategory']}',
      inventory: ${pi['inventory']},
      sizePrices: ${pi['sizePrices']},
    ),''';
}).join('\n')}
  ];
}
''';

  final dbFile = File('lib/services/generated_product_database.dart');
  await dbFile.writeAsString(fileContent);
  print('Generated lib/services/generated_product_database.dart');

  // Update pubspec.yaml
  final pubspecFile = File('pubspec.yaml');
  String pubspecContent = await pubspecFile.readAsString();
  
  // Find where assets start
  final assetsHeader = '  assets:';
  if (pubspecContent.contains(assetsHeader)) {
    // Remove old generated product assets to avoid duplicates (heuristic)
    final lines = pubspecContent.split('\n');
    List<String> newLines = [];
    bool inAssets = false;
    for (var line in lines) {
      if (line.trim() == 'assets:') {
        inAssets = true;
        newLines.add(line);
        continue;
      }
      
      if (inAssets && line.trim().startsWith('- ') && line.contains('assets/products/')) {
        continue; // Skip existing asset/products definitions
      }
      
      if (inAssets && line.trim() != '' && !line.trim().startsWith('- ') && !line.trim().startsWith('#') && !line.startsWith('  ')) {
        inAssets = false; // Exited assets section
      }
      
      newLines.add(line);
    }
    
    // Insert new asset paths
    final assetIndex = newLines.indexWhere((l) => l.trim() == 'assets:');
    if (assetIndex != -1) {
      // Find the last asset to append after it
      int insertIndex = assetIndex + 1;
      while (insertIndex < newLines.length && (newLines[insertIndex].trim().startsWith('-') || newLines[insertIndex].trim().startsWith('#') || newLines[insertIndex].trim().isEmpty)) {
        insertIndex++;
      }
      
      // We deduplicate assetPaths
      final uniqueAssetPaths = assetPaths.toSet().toList();
      newLines.insertAll(insertIndex, uniqueAssetPaths.map((p) => '    $p'));
    }
    
    await pubspecFile.writeAsString(newLines.join('\n'));
    print('Updated pubspec.yaml with ${assetPaths.toSet().length} asset directories.');
  }

  print('Backend generation complete.');
}

Map<String, String> _getPriceAndInventory(String categoryId, String subcategory, String id) {
  final subLower = subcategory.toLowerCase();
  int numId = int.tryParse(id.replaceFirst('gen_', '')) ?? id.hashCode;
  
  String inventory = '{}';
  String sizePrices = 'null';
  int basePrice = 2500;
  int variance = ((numId * 17) % 15) * 100 - 400; // Variation between -400 and +1000

  final noSizeCategories = ['mufflers', 'shawls', 'belts', 'caps', 'wallets', 'ties', 'socks', 'glasses'];
  
  if (noSizeCategories.contains(categoryId) || noSizeCategories.contains(subLower)) {
    inventory = '{}';
  } else if (categoryId == 'bottoms' || categoryId == 'pants' || categoryId == 'jeans' || categoryId == 'trousers' || subLower.contains('jeans') || subLower.contains('chinos') || subLower.contains('shorts')) {
    inventory = "{'32': 10, '34': 5, '36': 5, '38': 2, '40': 0}";
  } else if (categoryId == 'fragrances' || subLower.contains('fragrance') || subLower.contains('perfume') || subLower.contains('attar') || subLower.contains('body spray')) {
    inventory = "{'50ml': 10, '100ml': 5}";
  } else if (categoryId == 'footwear' || subLower.contains('shoes') || subLower.contains('sneakers') || subLower.contains('loafers') || subLower.contains('boots')) {
    inventory = "{'39': 5, '40': 10, '41': 10, '42': 8, '43': 4, '44': 2}";
  } else {
    // Default sizes for shirts, outerwear, knitwear, traditional
    inventory = "{'S': 10, 'M': 5, 'L': 5, 'XL': 0}";
  }
  
  if (subLower.contains('fabric') || subLower.contains('unstitched')) {
    int v = ((numId * 23) % 45) * 100; // 0 to 4500
    basePrice = 5000 + v;
    variance = 0; 
  } else if (subLower.contains('attar')) {
    sizePrices = "{'50ml': 'PKR 1100', '100ml': 'PKR 2000'}";
    basePrice = 1100;
    variance = 0;
  } else if (subLower.contains('body spray')) {
    int v50 = ((numId * 13) % 5) * 100; // 0 to 500
    int v100 = ((numId * 19) % 5) * 100; // 0 to 500
    sizePrices = "{'50ml': 'PKR ${800 + v50}', '100ml': 'PKR ${1900 + v100}'}";
    basePrice = 800 + v50;
    variance = 0;
  } else if (subLower.contains('perfume') || categoryId == 'fragrances') {
    int v50 = ((numId * 13) % 12) * 100; // 0 to 1200
    int v100 = ((numId * 19) % 15) * 100; // 0 to 1500
    sizePrices = "{'50ml': 'PKR ${1500 + v50}', '100ml': 'PKR ${3300 + v100}'}";
    basePrice = 1500 + v50;
    variance = 0;
  } else if (categoryId == 'outerwear' || subLower.contains('jacket') || subLower.contains('coat')) {
    basePrice = 6500;
  } else if (categoryId == 'footwear' || subLower.contains('shoes')) {
    basePrice = 4500;
  } else if (categoryId == 'bottoms' || subLower.contains('jeans') || subLower.contains('pants')) {
    basePrice = 3500;
  } else if (categoryId == 'knitwear' || subLower.contains('sweater') || subLower.contains('hoodie')) {
    basePrice = 4000;
  } else if (categoryId == 'shirts') {
    basePrice = 2500;
  } else if (categoryId == 'accessories' || subLower.contains('cap') || subLower.contains('belt')) {
    basePrice = 1500;
  }
  
  int finalPrice = basePrice + variance;
  if (finalPrice < 900) finalPrice = 900;
  
  return {
    'price': 'PKR $finalPrice',
    'inventory': inventory,
    'sizePrices': sizePrices,
  };
}



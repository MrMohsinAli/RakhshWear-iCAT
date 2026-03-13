import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'package:smart_ecommerce_app/services/mock_data_service.dart';
import 'package:smart_ecommerce_app/models/data_models.dart';
import 'package:smart_ecommerce_app/widgets/product_card.dart';
import 'package:smart_ecommerce_app/screens/product_detail_page.dart';
import 'package:smart_ecommerce_app/screens/web_layout.dart';
import 'package:smart_ecommerce_app/screens/product_listing_page.dart';

class SearchOverlay extends StatefulWidget {
  /// Called when the user wants to close the overlay.
  final VoidCallback onClose;

  final double navbarBottom;

  const SearchOverlay({
    super.key,
    required this.onClose,
    required this.navbarBottom,
  });

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _hasSearched = false;

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  // Spring cubic bezier: overshoots ~1.06 then snaps to 1.0
  static const _springCurve = Cubic(0.34, 1.56, 0.64, 1.0);

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 460),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(begin: 0.82, end: 1.0)
        .animate(CurvedAnimation(parent: _animCtrl, curve: _springCurve));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    final q = query.trim().toLowerCase();

    // Map keywords to specific collection subcategories
    final Map<String, List<String>> keywordToSubcategories = {
      'winter': ['jackets', 'sweaters', 'hoodies', 'shawls', 'jeans', 'mufflers'],
      'street': ['tees', 'hoodies', 'shorts', 'comfort', 'caps', 'chinos'],
      'streetwear': ['tees', 'hoodies', 'shorts', 'comfort', 'caps', 'chinos'],
      'arrival': ['polos', 'jeans', 'unstitched fabric', 'kurta trouser', 'caps', 'sneakers'],
      'new arrival': ['polos', 'jeans', 'unstitched fabric', 'kurta trouser', 'caps', 'sneakers'],
      'spring': ['polos', 'denim', 'jeans', 'kurta trouser', 'sneakers', 'caps'],
      'summer': ['polos', 'denim', 'jeans', 'kurta trouser', 'sneakers', 'caps'],
      'occasional': ['blazers', 'formals', 'formal', 'glasses', 'belts'],
      'comfortwear': ['tees', 'kameez shalwar', 'chinos', 'shorts', 'comfort'],
    };

    // Gather all target subcategories if the query overlaps with any keywords
    final List<String> matchedSubcategories = [];
    keywordToSubcategories.forEach((key, subcategories) {
      if (key.contains(q) || q.contains(key)) {
        matchedSubcategories.addAll(subcategories.map((s) => s.toLowerCase()));
      }
    });

    final results = MockDataService.products.where((product) {
      final subcategoryLower = product.subcategory.toLowerCase();
      
      final matchesText = product.title.toLowerCase().contains(q) ||
          product.categoryId.toLowerCase().contains(q) ||
          subcategoryLower.contains(q);

      final matchesCollection = matchedSubcategories.contains(subcategoryLower);

      return matchesText || matchesCollection;
    }).toList();

    // Sort results to prioritize accessories at the end, etc.
    final sortedResults = MockDataService.sortProductsByPriority(results);

    setState(() {
      _searchResults = sortedResults;
      _hasSearched = true;
    });
  }

  void _navigateToSearch(String query) {
    if (query.trim().isEmpty) return;
    _close();
    Navigator.push(
      context,
      FadeSlideRoute(
        builder: (context) => WebLayout(
          body: ProductListingPage(searchQuery: query.trim()),
        ),
      ),
    );
  }

  Future<void> _close() async {
    await _animCtrl.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // ── Blur + dim backdrop (covers entire screen below the navbar) ──
        Positioned(
          top: widget.navbarBottom,
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _close,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withValues(alpha: 0.18),
              ),
            ),
          ),
        ),

        //Results panel – anchored to the right, just below navbar
        Positioned(
          top: widget.navbarBottom,
          right: 24,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {}, // swallow taps inside the panel
                child: Material(
                  color: Colors.white,
                  elevation: 16,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 680,
                    constraints: BoxConstraints(
                      maxHeight: screenSize.height * 0.72,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey.shade100),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: Colors.grey.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.search,
                                          color: Colors.black54, size: 18),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          autofocus: true,
                                          style: const TextStyle(fontSize: 15),
                                          decoration: const InputDecoration(
                                            hintText: 'Search products...',
                                            hintStyle: TextStyle(
                                                color: Colors.black38),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12),
                                          ),
                                          onSubmitted: _navigateToSearch,
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              setState(() {
                                                _searchResults = [];
                                                _hasSearched = false;
                                              });
                                            } else {
                                              _performSearch(value);
                                            }
                                          },
                                        ),
                                      ),
                                      if (_searchController.text.isNotEmpty)
                                        GestureDetector(
                                          onTap: () {
                                            _searchController.clear();
                                            setState(() {
                                              _searchResults = [];
                                              _hasSearched = false;
                                            });
                                          },
                                          child: const Icon(Icons.cancel,
                                              size: 17, color: Colors.black38),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // "Go" button 
                              OutlinedButton(
                                onPressed: () =>
                                    _navigateToSearch(_searchController.text),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Colors.black),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 10),
                                ),
                                child: const Text(
                                  'Go',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Search Results
                        Flexible(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            child: _buildSearchResults(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_hasSearched && _searchResults.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 32),
          Icon(Icons.search_off, size: 52, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'No products found',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          const SizedBox(height: 32),
        ],
      );
    } else if (_searchResults.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Products',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              childAspectRatio: 0.52,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final product = _searchResults[index];
              return ProductCard(
                product: product,
                onTap: () {
                  _close();
                  Navigator.push(
                    context,
                    FadeSlideRoute(
                      builder: (context) => WebLayout(
                        body: ProductDetailPage(productId: product.id),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular searches',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildPopularSearchItem('Shirts'),
          _buildPopularSearchItem('Footwear'),
          _buildCuratedSearchItem(
            'New Arrival',
            subcategories: ['Polos', 'Jeans', 'Unstitched Fabric', 'Kurta Trouser', 'Caps', 'Sneakers'],
            collectionTitle: 'New Arrival',
          ),
          _buildCuratedSearchItem(
            'Occasional',
            subcategories: ['Blazers', 'Formals', 'Formal', 'Glasses', 'Belts'],
            collectionTitle: 'Occasional Collection',
          ),
          _buildCuratedSearchItem(
            'Comfortwear',
            subcategories: ['Tees', 'Kameez Shalwar', 'Chinos', 'Shorts', 'Comfort'],
            collectionTitle: 'Comfortwear',
          ),
        ],
      );
    }
  }

  Widget _buildPopularSearchItem(String title) {
    return InkWell(
      onTap: () {
        _searchController.text = title;
        _performSearch(title);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildCuratedSearchItem(
    String title, {
    required List<String> subcategories,
    required String collectionTitle,
  }) {
    return InkWell(
      onTap: () {
        _close();
        Navigator.push(
          context,
          FadeSlideRoute(
            builder: (context) => WebLayout(
              body: ProductListingPage(
                subcategories: subcategories,
                collectionTitle: collectionTitle,
              ),
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 11, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

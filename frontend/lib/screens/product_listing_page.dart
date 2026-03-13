import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_ecommerce_app/models/data_models.dart';
import 'package:smart_ecommerce_app/services/mock_data_service.dart';
import 'package:smart_ecommerce_app/widgets/product_card.dart';
import 'package:smart_ecommerce_app/screens/product_detail_page.dart';
import 'package:smart_ecommerce_app/screens/web_layout.dart';
import 'package:smart_ecommerce_app/widgets/footer.dart';
import 'package:smart_ecommerce_app/screens/home_screen.dart';

class ProductListingPage extends StatefulWidget {
  final String? categoryId;
  final String? subcategory;
  final List<String>? subcategories; // multiple subcategories cross-category
  final String? collectionTitle;    // custom heading for curated pages
  final String? searchQuery;

  const ProductListingPage({
    super.key,
    this.categoryId,
    this.subcategory,
    this.subcategories,
    this.collectionTitle,
    this.searchQuery,
  });

  @override
  State<ProductListingPage> createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  String _selectedSort = 'RECOMMENDED';
  bool _isSortMenuOpen = false;

  final List<String> _sortOptions = [
    'RECOMMENDED',
    'ALPHABETICALLY (A TO Z)',
    'ALPHABETICALLY (Z TO A)',
    'PRICE (LOW TO HIGH)',
    'PRICE (HIGH TO LOW)',
    'NEWEST ARRIVALS',
    'BEST SELLING',
    'TOP RATED',
    'MOST REVIEWED',
  ];

  List<dynamic> _sortProducts(List<dynamic> products) {
    final sorted = List.from(products);

    double getPrice(dynamic p) {
      // Basic parsing of "PKR 4,990" -> 4990.0
      final priceString = p.price.replaceAll(RegExp(r'[^0-9]'), '');
      return double.tryParse(priceString) ?? 0.0;
    }

    switch (_selectedSort) {
      case 'RECOMMENDED':
        return MockDataService.sortProductsByPriority(sorted.cast<Product>());
      case 'ALPHABETICALLY (A TO Z)':
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'ALPHABETICALLY (Z TO A)':
        sorted.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'PRICE (LOW TO HIGH)':
        sorted.sort((a, b) => getPrice(a).compareTo(getPrice(b)));
        break;
      case 'PRICE (HIGH TO LOW)':
        sorted.sort((a, b) => getPrice(b).compareTo(getPrice(a)));
        break;
      case 'NEWEST ARRIVALS':
        sorted.sort((a, b) {
          if (a.isNew != b.isNew) return a.isNew ? -1 : 1;
          return b.id.compareTo(a.id); // Fallback to ID for consistency
        });
        break;
      case 'BEST SELLING':
        // Simulate by shuffling or using a seed based on ID for consistency
        sorted.shuffle();
        break;
      case 'TOP RATED':
        sorted.sort((a, b) {
          double avgA = a.reviews.isEmpty ? 0 : a.reviews.map((r) => r.rating).reduce((v, e) => v + e) / a.reviews.length;
          double avgB = b.reviews.isEmpty ? 0 : b.reviews.map((r) => r.rating).reduce((v, e) => v + e) / b.reviews.length;
          return avgB.compareTo(avgA);
        });
        break;
      case 'MOST REVIEWED':
        sorted.sort((a, b) => b.reviews.length.compareTo(a.reviews.length));
        break;
      default:
        break;
    }
    return sorted;
  }
  @override
  Widget build(BuildContext context) {
    // Search mode: filter all products across all categories
    late List<dynamic> products;
    String? categoryName;

    if (widget.searchQuery != null && widget.searchQuery!.trim().isNotEmpty) {
      final q = widget.searchQuery!.toLowerCase();
      products = MockDataService.products.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.categoryId.toLowerCase().contains(q) ||
            p.subcategory.toLowerCase().contains(q);
      }).toList();
    } else if (widget.subcategories != null && widget.subcategories!.isNotEmpty) {
      // Curated multi-subcategory cross-category page (New Arrival, Winter Collection, etc.)
      final subs = widget.subcategories!.map((s) => s.toLowerCase()).toSet();
      products = MockDataService.products
          .where((p) => subs.contains(p.subcategory.toLowerCase()))
          .toList();
      categoryName = widget.collectionTitle ?? 'Collection';
    } else {
      products = widget.categoryId != null
          ? MockDataService.getProductsByCategory(widget.categoryId!)
          : MockDataService.products;
      if (widget.subcategory != null) {
        products = products.where((p) => p.subcategory == widget.subcategory).toList();
      }
      final category = widget.categoryId != null
          ? MockDataService.categories.firstWhere(
              (c) => c.id == widget.categoryId,
              orElse: () => const Category(id: 'unknown', title: 'Products'),
            )
          : const Category(id: 'all', title: 'Products');
      categoryName = widget.collectionTitle ?? category.title;
    }

    products = _sortProducts(products);
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumbs
                _buildBreadcrumbs(context, categoryName),
                const SizedBox(height: 12),

                // Products Found & Sort Row
                // Parent Stack for everything that needs overlays
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Main Content (Header Row + Grid)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Products Found & Sort Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${products.length} Products Found',
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            SelectionContainer.disabled(
                              child: InkWell(
                                onTap: () => setState(() => _isSortMenuOpen = !_isSortMenuOpen),
                                child: Row(
                                  children: [
                                    Icon(Icons.sort, size: 16, color: Colors.grey.shade500),
                                    const SizedBox(width: 8),
                                    Text(
                                      'SORT BY: $_selectedSort',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.1,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(_isSortMenuOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, size: 20, color: Colors.grey.shade500),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),

                        // Product Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            childAspectRatio: 0.55,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              onTap: () {
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
                    ),

                    // Sort Dropdown Overlay (LAST in Stack list to be on TOP)
                    Positioned(
                      top: 25,
                      right: 0,
                    child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 140),
                        reverseDuration: const Duration(milliseconds: 140),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: _isSortMenuOpen
                            ? Container(
                                key: const ValueKey('sort-open'),
                                width: 240,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.12),
                                      blurRadius: 25,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _sortOptions.map((opt) {
                                    final isSelected = opt == _selectedSort;
                                    return SelectionContainer.disabled(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedSort = opt;
                                            _isSortMenuOpen = false;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                          child: Text(
                                            opt,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 13,
                                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                              color: isSelected ? Colors.black : Colors.grey.shade800,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : const SizedBox.shrink(key: ValueKey('sort-closed')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          const Footer(),
          const CopyrightFooter(),
        ],
      ),
    );
  }
  Widget _buildBreadcrumbs(BuildContext context, String? categoryName) {
    List<Widget> breadcrumbs = [];

    // HOME
    breadcrumbs.add(_BreadcrumbItem(
      label: 'HOME',
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        FadeSlideRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      ),
    ));



    if (widget.searchQuery != null && widget.searchQuery!.trim().isNotEmpty) {
      breadcrumbs.add(const _BreadcrumbSeparator());
      breadcrumbs.add(Text(
        'SEARCH',
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ));

    } else if (categoryName != null) {
      breadcrumbs.add(const _BreadcrumbSeparator());
      
      if (widget.subcategory != null) {
        // Category is clickable
        breadcrumbs.add(_BreadcrumbItem(
          label: categoryName.toUpperCase(),
          onTap: () => Navigator.pushReplacement(
            context,
            FadeSlideRoute(
              builder: (_) => WebLayout(
                body: ProductListingPage(categoryId: widget.categoryId),
              ),
            ),
          ),
        ));
        breadcrumbs.add(const _BreadcrumbSeparator());
        breadcrumbs.add(Text(
          widget.subcategory!.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ));

      } else {
        // Only Category is active
        breadcrumbs.add(Text(
          categoryName.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ));

      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: breadcrumbs,
        ),
      ],
    );
  }
}

class _BreadcrumbItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _BreadcrumbItem({required this.label, required this.onTap});

  @override
  State<_BreadcrumbItem> createState() => _BreadcrumbItemState();
}

class _BreadcrumbItemState extends State<_BreadcrumbItem> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: Colors.black,
            fontWeight: _hovering ? FontWeight.w800 : FontWeight.w600,
            letterSpacing: 0.5,
            decoration:
                _hovering ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

class _BreadcrumbSeparator extends StatelessWidget {
  const _BreadcrumbSeparator();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '>',
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

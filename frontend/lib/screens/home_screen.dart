import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_ecommerce_app/screens/web_layout.dart';
import 'package:smart_ecommerce_app/services/mock_data_service.dart';
import 'package:smart_ecommerce_app/screens/product_detail_page.dart';
import 'package:smart_ecommerce_app/screens/product_listing_page.dart';
import 'package:smart_ecommerce_app/widgets/product_card.dart';
import 'package:smart_ecommerce_app/widgets/subcategory_card.dart';
import 'package:smart_ecommerce_app/widgets/footer.dart';
import 'package:smart_ecommerce_app/models/data_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  int _currentPage = 0;

  static const int _slideCount = 6;

  void _goToPage(int page) {
    if (mounted) setState(() => _currentPage = page);
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _goToPage((_currentPage + 1) % _slideCount);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return WebLayout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section — cross-fade carousel
            SizedBox(
              height: isMobile ? 350 : 500,
              child: Stack(
                children: [
                  // ── Slides ────
                  // ── Slides ────
                  ...List.generate(_slideCount, (index) {
                    final slides = _getSlides();
                    final s = slides[index];
                    final isActive = index == _currentPage;

                    return Positioned.fill(
                      child: IgnorePointer(
                        ignoring: !isActive,
                        child: AnimatedOpacity(
                          opacity: isActive ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                          child: _buildHeroItemWithDescription(
                            context,
                            s.title,
                            s.description,
                            s.imageUrl,
                            s.subcategories,
                            s.collectionTitle,
                            isMobile,
                            isActive,
                          ),
                        ),
                      ),
                    );
                  }),

                  // ── Dot indicators ─────────────────────────────────────
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_slideCount, (i) {
                        final active = i == _currentPage;
                        return GestureDetector(
                          onTap: () {
                            _timer.cancel();
                            _goToPage(i);
                            // Restart timer after manual tap
                            _timer = Timer.periodic(
                              const Duration(seconds: 5),
                              (_) => _goToPage((_currentPage + 1) % _slideCount),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: active ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Subcategories Section
            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: _buildSubcategoryCards(context),
              ),
            ),
            const SizedBox(height: 48),

            // Featured Products
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 40.0, vertical: isMobile ? 8 : 16),
              child: Text(
                'FEATURED PRODUCTS',
                style: GoogleFonts.montserrat(
                  fontSize: isMobile ? 20 : 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 0.55,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                ),
                itemCount: _getSortedHomeProducts().length,
                itemBuilder: (context, index) {
                  final product = _getSortedHomeProducts()[index];
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
            ),

            const SizedBox(height: 48),
            const Footer(),
            const CopyrightFooter(),
          ],
        ),
      ),
    );
  }

  List<Product> _getSortedHomeProducts() {
    final products = List<Product>.from(MockDataService.products);
    
    // Priority: shirts > outerwear > bottoms > knitwear > footwear > accessories > fragrances
    final priority = {
      'shirts': 0,
      'outerwear': 1,
      'bottoms': 2,
      'knitwear': 3,
      'footwear': 4,
      'accessories': 5,
      'fragrances': 6,
    };

    products.sort((a, b) {
      final pA = priority[a.categoryId] ?? 99;
      final pB = priority[b.categoryId] ?? 99;
      return pA.compareTo(pB);
    });

    return products;
  }

  /// Returns all hero slides
  List<({String collectionTitle, String description, String imageUrl, List<String> subcategories, String title})> _getSlides() {
    return [
      (
        title: 'NEW ARRIVAL',
        description: 'Discover vibrant styles for the season',
        imageUrl: 'assets/carousal/new arrival.png',
        subcategories: ['Polos', 'Jeans', 'Unstitched Fabric', 'Kurta Trouser', 'Caps', 'Sneakers'],
        collectionTitle: 'New Arrival',
      ),
      (
        title: 'STREETWEAR',
        description: 'Elevate your urban style with our exclusive streetwear line',
        imageUrl: 'assets/carousal/streetwear.png',
        subcategories: ['Tees', 'Hoodies', 'Shorts', 'Comfort', 'Caps', 'Chinos'],
        collectionTitle: 'Premium Streetwear',
      ),
      (
        title: 'WINTER ESSENTIALS',
        description: 'Stay warm and stylish with our latest winter collection',
        imageUrl: 'assets/carousal/winter essentials.png',
        subcategories: ['Jackets', 'Sweaters', 'Hoodies', 'Shawls', 'Jeans', 'Mufflers'],
        collectionTitle: 'Winter Collection',
      ),
      (
        title: 'SPRING SUMMER COLLECTION',
        description: 'Breathe easy with our highly anticipated spring styles',
        imageUrl: 'assets/carousal/spring summer collection.png',
        subcategories: ['Polos', 'Denim', 'Jeans', 'Kurta Trouser', 'Sneakers', 'Caps'],
        collectionTitle: 'Spring Summer Collection',
      ),
      (
        title: 'OCCASIONAL',
        description: 'Dress strictly to impress for those special nights out',
        imageUrl: 'assets/carousal/occassional.jpg',
        subcategories: ['Blazers', 'Formals', 'Formal', 'Glasses', 'Belts'],
        collectionTitle: 'Occasional Collection',
      ),
      (
        title: 'COMFORTWEAR',
        description: 'Experience unparalleled relaxation',
        imageUrl: 'assets/carousal/comfortwear.jpg',
        subcategories: ['Tees', 'Kameez Shalwar', 'Chinos', 'Shorts', 'Comfort'],
        collectionTitle: 'Comfortwear',
      ),
    ];
  }

  Widget _buildHeroItemWithDescription(
    BuildContext context,
    String title,
    String description,
    String imageUrl,
    List<String> subcategories,
    String collectionTitle,
    bool isMobile,
    bool isActive,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Ken Burns slow zoom image
        _KenBurnsImage(imageUrl: imageUrl, isActive: isActive),
        // Gradient overlay + text content
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.6),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: EdgeInsets.only(
            left: isMobile ? 24 : 40,
            right: isMobile ? 24 : 40,
            bottom: isMobile ? 60 : 100, // Increased bottom padding to move content up
            top: 24,
          ),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: isMobile ? 32 : 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 18,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),
              _HoverShopNowButton(
                isMobile: isMobile,
                onTap: () {
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSubcategoryCards(BuildContext context) {
    // ── Custom display order ──────────────────────────────────────────────────
    // Each entry: (categoryId, subcategoryName) — must match MockDataService exactly
    const orderedSlots = [
      ('shirts',        'Polos'),
      ('outerwear',     'Hoodies'),
      ('bottoms',       'Jeans'),
      ('outerwear',     'Jackets'),
      ('knitwear',      'Sweaters'),
      ('shirts',        'Tees'),
      ('bottoms',       'Chinos'),
      ('outerwear',     'Blazers'),
      ('bottoms',       'Shorts'),
      ('shirts',        'Formals'),
      ('bottoms',       'Denim'),
      ('outerwear',     'Shawls'),
      ('knitwear',      'Mufflers'),
      ('kurta-shalwar', 'Kurta Trouser'),
      ('kurta-shalwar', 'Kameez Shalwar'),
      ('footwear',      'Sneakers'),
      ('accessories',   'Caps'),
      ('kurta-shalwar', 'Unstitched Fabric'),
      ('footwear',      'Comfort'),
      ('footwear',      'Casual'),
      ('footwear',      'Formal'),
      ('footwear',      'Sandals'),
      ('accessories',   'Glasses'),
      ('accessories',   'Belts'),
      ('fragrances',    'Perfumes'),
      ('fragrances',    'Body Spray'),
      ('fragrances',    'Attar'),
      ('knitwear',      'Sweatshirts'),
    ];

    // Build a lookup: categoryId → Category object
    final categoryMap = { for (var c in MockDataService.categories) c.id: c };

    // Track already-added slots to avoid duplicates when appending leftovers
    final added = <String>{};

    List<Widget> cards = [];

    Widget _makeCard(String catId, String subcategory) {
      final category = categoryMap[catId];
      if (category == null) return const SizedBox.shrink();
      final images = MockDataService.products
          .where((p) => p.categoryId == catId && p.subcategory == subcategory)
          .where((p) => p.images.isNotEmpty)
          .map((p) => p.images.first)
          .toList();
      return SubcategoryCard(
        title: subcategory,
        categoryId: catId,
        images: images,
        waveDelay: Duration.zero,
        onTap: () {
          Navigator.push(
            context,
            FadeSlideRoute(
              builder: (context) => WebLayout(
                body: ProductListingPage(
                  categoryId: catId,
                  subcategory: subcategory,
                ),
              ),
            ),
          );
        },
      );
    }

    // Add in custom order
    for (final (catId, sub) in orderedSlots) {
      final key = '$catId|$sub';
      if (added.contains(key)) continue;
      added.add(key);
      cards.add(_makeCard(catId, sub));
    }

    // Append any subcategories not already included
    for (var category in MockDataService.categories) {
      for (var subcategory in category.subcategories) {
        final key = '${category.id}|$subcategory';
        if (added.contains(key)) continue;
        added.add(key);
        cards.add(_makeCard(category.id, subcategory));
      }
    }

    return cards;
  }
}

// ── Ken Burns Image ─────────────────────────────────────────────────────────
// Displays a network image that very slowly zooms from 105% → 100% scale.
// This "Ken Burns" effect runs for the full hold duration of each slide.
class _KenBurnsImage extends StatefulWidget {
  final String imageUrl;
  final bool isActive;
  const _KenBurnsImage({required this.imageUrl, required this.isActive});

  @override
  State<_KenBurnsImage> createState() => _KenBurnsImageState();
}

class _KenBurnsImageState extends State<_KenBurnsImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );
    // Start at 1.05, slowly zoom down to 1.0 (subtle Ken Burns)
    _scaleAnim = Tween<double>(begin: 1.05, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.linear),
    );
    if (widget.isActive) {
      _ctrl.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _KenBurnsImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _ctrl.forward(from: 0.0);
    } else if (!widget.isActive && oldWidget.isActive) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Image.asset(
          widget.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class _HoverShopNowButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isMobile;

  const _HoverShopNowButton({required this.onTap, required this.isMobile});

  @override
  State<_HoverShopNowButton> createState() => _HoverShopNowButtonState();
}

class _HoverShopNowButtonState extends State<_HoverShopNowButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFF37474F);

    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isMobile ? 24 : 32,
              vertical: widget.isMobile ? 12 : 16,
            ),
            decoration: BoxDecoration(
              color: _isHovering ? baseColor : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'SHOP NOW',
              style: GoogleFonts.montserrat(
                fontSize: widget.isMobile ? 14 : 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: _isHovering ? Colors.white : const Color(0xFF9E6C47),
                shadows: _isHovering ? null : [
                  Shadow(
                    offset: const Offset(0, 2),
                    blurRadius: 6.0,
                    color: Colors.black.withValues(alpha: 0.7),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

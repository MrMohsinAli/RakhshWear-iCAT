import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_ecommerce_app/models/data_models.dart';
import 'package:smart_ecommerce_app/services/app_state.dart';
import 'package:smart_ecommerce_app/screens/footer_pages.dart';
import 'package:smart_ecommerce_app/services/mock_data_service.dart';
import 'package:smart_ecommerce_app/widgets/product_card.dart';
import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'package:smart_ecommerce_app/screens/web_layout.dart';
import 'package:smart_ecommerce_app/widgets/footer.dart';
import 'package:smart_ecommerce_app/screens/product_listing_page.dart';
import 'package:smart_ecommerce_app/screens/home_screen.dart';
import 'package:smart_ecommerce_app/utils/app_snackbar.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  Product? product;
  String? selectedSize;
  int _selectedImageIndex = 0;
  bool _moreInfoExpanded = false;

  // Shake animation
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  Timer? _shakeTimer;

  @override
  void initState() {
    super.initState();
    product = MockDataService.getProductById(widget.productId);
    
    // Auto-select size if there's only one option available
    if (product != null && product!.inventory.length == 1) {
      selectedSize = product!.inventory.keys.first;
    }

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    _shakeTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) _shakeController.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _shakeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const Center(child: Text('Product not found'));
    }

    final relatedProducts = MockDataService.getRelatedProducts(
        product!.categoryId, product!.id, 50);

    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          _buildBreadcrumb(),

          // Main content
          Padding(
            padding: EdgeInsets.only(
              left: isMobile ? 16 : 120,
              right: isMobile ? 16 : 40,
              top: 24,
              bottom: 24,
            ),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left: Image Gallery ──────────────────────────────────
                isMobile 
                  ? SizedBox(width: double.infinity, child: _buildMobileImageGallery())
                  : Expanded(flex: 3, child: _buildDesktopImageGallery()),

                if (!isMobile) const SizedBox(width: 80),
                if (isMobile) const SizedBox(height: 32),

                // ── Right: Product Info ──────────────────────────────────
                isMobile
                  ? SizedBox(width: double.infinity, child: _buildProductInfoColumn(isMobile))
                  : Expanded(flex: 5, child: _buildProductInfoColumn(isMobile)),
              ],
            ),
          ),

          // Related Products
          if (relatedProducts.isNotEmpty) ...[
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOU MAY ALSO LIKE',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 340,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: relatedProducts.length,
                      itemBuilder: (context, index) {
                        final p = relatedProducts[index];
                        return SizedBox(
                          width: 210,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: ProductCard(
                              product: p,
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  FadeSlideRoute(
                                    builder: (context) => WebLayout(
                                      body: ProductDetailPage(productId: p.id),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Footer(),
          const CopyrightFooter(),
        ],
      ),
    );
  }

  Widget _buildProductInfoColumn(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          product!.title.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),

        // Category
        Text(
          'Product Type: ${product!.categoryId.toUpperCase()}',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),

        // In Stock / Out of Stock badge
        Builder(builder: (context) {
          final inv = product!.inventory;
          final isFullyOutOfStock = inv.isNotEmpty &&
              inv.values.every((q) => q <= 0);
          return Row(
            children: [
              Icon(
                isFullyOutOfStock ? Icons.cancel : Icons.check_circle,
                size: 14,
                color: isFullyOutOfStock ? Colors.red.shade600 : Colors.green.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                isFullyOutOfStock ? 'OUT OF STOCK' : 'IN STOCK',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isFullyOutOfStock ? Colors.red.shade600 : Colors.green.shade600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 16),

        // Price
        Text(
          selectedSize != null && selectedSize!.isNotEmpty 
              ? product!.getPriceForSize(selectedSize!)
              : product!.price,
          style: GoogleFonts.montserrat(
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),

        Divider(height: 32, thickness: 1, color: Colors.grey.shade300),

        // Only show Size Selection if there is more than one size option available
        if (product!.inventory.length > 1) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SELECT SIZE',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              _SizeChartButton(),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product!.inventory.keys.map((size) {
              final isSelected = selectedSize == size;
              final stock = product!.inventory[size] ?? 0;
              final isOutOfStock = stock <= 0;

              return _SizeButton(
                size: size,
                isSelected: isSelected,
                onTap: isOutOfStock
                    ? null
                    : () => setState(() => selectedSize = size),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // ADD TO BAG button
        Builder(builder: (context) {
          final inv = product!.inventory;
          final isFullyOutOfStock = inv.isNotEmpty &&
              inv.values.every((q) => q <= 0);
          return AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) => Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: child,
            ),
            child: _AddToBagButton(
              label: isFullyOutOfStock ? 'OUT OF STOCK' : 'ADD TO BAG',
              disabled: isFullyOutOfStock,
              onPressed: isFullyOutOfStock
                  ? null
                  : () {
                      if (selectedSize == null) {
                        AppSnackBar.error(context, 'Please select a size first');
                        return;
                      }

                      final added = context.read<CartProvider>().addToCart(product!, selectedSize!);
                      if (added) {
                        AppSnackBar.success(context, 'Product added to cart.');
                      } else {
                        AppSnackBar.error(context, 'Maximum quantity reached for this size.');
                      }
                    },
            ),
          );
        }),
        const SizedBox(height: 24),

        // Collapsible: Description
        _CollapsibleSection(
          title: 'Description',
          isExpanded: _moreInfoExpanded,
          onToggle: () => setState(() => _moreInfoExpanded = !_moreInfoExpanded),
          child: Text(
            product!.description,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: Colors.black87,
              height: 1.8,
            ),
          ),
        ),
        Divider(height: 0, color: Colors.grey.shade300),

        // Reviews Section
        Consumer<ReviewProvider>(
          builder: (context, reviewProvider, _) {
            final allReviews = reviewProvider.getUserReviews(product!.id);
            return _ReviewsSection(
              reviews: allReviews,
              productId: product!.id,
            );
          },
        ),
      ],
    );
  }

  Widget _buildBreadcrumb() {
    final category = product!.categoryId.toUpperCase();
    final sub = product!.subcategory.toUpperCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _BreadcrumbItem(
            label: 'HOME',
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              FadeSlideRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            ),
          ),
          _BreadcrumbSeparator(),
          _BreadcrumbItem(
            label: category,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                FadeSlideRoute(
                  builder: (_) => WebLayout(
                    body: ProductListingPage(categoryId: product!.categoryId),
                  ),
                ),
                (route) => false,
              );
            },
          ),
          if (sub.isNotEmpty) ...[
            _BreadcrumbSeparator(),
            _BreadcrumbItem(
              label: sub,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  FadeSlideRoute(
                    builder: (_) => WebLayout(
                      body: ProductListingPage(
                        categoryId: product!.categoryId,
                        subcategory: product!.subcategory,
                      ),
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
          _BreadcrumbSeparator(),
          Text(
            product!.title.toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopImageGallery() {
    return Column(
      children: [
        // Main image
        AspectRatio(
          aspectRatio: 3 / 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              image: product!.images.isNotEmpty
                  ? DecorationImage(
                      image: AssetImage(
                          product!.images[_selectedImageIndex]),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
        ),
        if (product!.images.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            children: product!.images.asMap().entries.map((entry) {
              final idx = entry.key;
              final img = entry.value;
              return GestureDetector(
                onTap: () => setState(() => _selectedImageIndex = idx),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    height: 120,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedImageIndex == idx
                            ? Colors.black
                            : Colors.grey.shade200,
                        width: _selectedImageIndex == idx ? 2 : 1,
                      ),
                      image: DecorationImage(
                        image: AssetImage(img),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildMobileImageGallery() {
    return Column(
      children: [
        // Main image (smaller aspect ratio for mobile scrollability)
        AspectRatio(
          aspectRatio: 4 / 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              image: product!.images.isNotEmpty
                  ? DecorationImage(
                      image: AssetImage(
                          product!.images[_selectedImageIndex]),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
        ),
        if (product!.images.length > 1) ...[
          const SizedBox(height: 16),
          // Horizontal scrolling thumbnails
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: product!.images.asMap().entries.map((entry) {
                final idx = entry.key;
                final img = entry.value;
                return GestureDetector(
                  onTap: () => setState(() => _selectedImageIndex = idx),
                  child: Container(
                    width: 60,
                    height: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedImageIndex == idx
                            ? Colors.black
                            : Colors.grey.shade200,
                        width: _selectedImageIndex == idx ? 2 : 1,
                      ),
                      image: DecorationImage(
                        image: AssetImage(img),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}


// ── Subwidgets ──────────────────────────────────────────────────────────────

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
            decoration: _hovering ? TextDecoration.underline : TextDecoration.none,
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

class _SizeButton extends StatefulWidget {
  final String size;
  final bool isSelected;
  final VoidCallback? onTap; // Made nullable for out-of-stock items
  const _SizeButton(
      {required this.size, required this.isSelected, required this.onTap});

  @override
  State<_SizeButton> createState() => _SizeButtonState();
}

class _SizeButtonState extends State<_SizeButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onTap != null;
    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isSelected
                ? Colors.grey.shade800
                : (isEnabled && _hovering ? Colors.grey.shade100 : Colors.white),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.grey.shade800
                  : (isEnabled && _hovering ? Colors.black : Colors.grey.shade300),
              width: 1,
            ),
          ),
          child: Text(
            widget.size,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.isSelected
                  ? Colors.white
                  : (isEnabled ? Colors.black : Colors.grey.shade400),
            ),
          ),
        ),
      ),
    );
  }
}

class _SizeChartButton extends StatefulWidget {
  const _SizeChartButton();
  @override
  State<_SizeChartButton> createState() => _SizeChartButtonState();
}

class _SizeChartButtonState extends State<_SizeChartButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFF3894C9);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            FadeSlideRoute(builder: (context) => const SizeGuidePage()),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _hovering ? brandColor.withValues(alpha: 0.05) : Colors.transparent,
            border: Border.all(
                color: _hovering ? brandColor : brandColor.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.straighten,
                  size: 14,
                  color: brandColor),
              const SizedBox(width: 6),
              Text(
                'Size guide',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: brandColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddToBagButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool disabled;

  const _AddToBagButton({
    this.onPressed,
    this.label = 'ADD TO BAG',
    this.disabled = false,
  });

  @override
  State<_AddToBagButton> createState() => _AddToBagButtonState();
}

class _AddToBagButtonState extends State<_AddToBagButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.disabled || widget.onPressed == null;
    return MouseRegion(
      cursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: (_) { if (!isDisabled) setState(() => _hovering = true); },
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: isDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 300,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey.shade200
                : (_hovering ? Colors.black : Colors.white),
            border: Border.all(
              color: isDisabled ? Colors.grey.shade400 : Colors.black,
              width: 1.5,
            ),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: isDisabled
                  ? Colors.grey.shade500
                  : (_hovering ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child;

  const _CollapsibleSection({
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
  });

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_CollapsibleSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 0, color: Colors.grey.shade300),
        InkWell(
          onTap: widget.onToggle,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: widget.isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(Icons.keyboard_arrow_down, size: 20),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _sizeAnimation,
          axis: Axis.vertical,
          axisAlignment: -1.0, // Top alignment for blind effect
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}




// ── Reviews Section (Diners-style) ─────────────────────────────────────────

class _ReviewsSection extends StatefulWidget {
  final List<Review> reviews;
  final String productId;
  const _ReviewsSection({required this.reviews, required this.productId});

  @override
  State<_ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<_ReviewsSection> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _showForm = false;

  late AnimationController _formAnimController;
  late Animation<double> _formSizeAnim;

  @override
  void initState() {
    super.initState();
    _formAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _formSizeAnim = CurvedAnimation(
      parent: _formAnimController,
      curve: Curves.easeInOutCubic,
    );
  }

  // Form state
  int _formRating = 0;
  int _formHoverRating = 0;
  bool _btnWriteHover = false;
  bool _btnSubmitHover = false;
  
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _formAnimController.dispose();
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  double get _avgRating {
    if (widget.reviews.isEmpty) return 0;
    return widget.reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        widget.reviews.length;
  }

  int _countForStar(int star) =>
      widget.reviews.where((r) => r.rating.round() == star).length;

  @override
  Widget build(BuildContext context) {
    return _CollapsibleSection(
      title: 'Reviews (${widget.reviews.length})',
      isExpanded: _isExpanded,
      onToggle: () => setState(() => _isExpanded = !_isExpanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary bar
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Average score
              Column(
                children: [
                  Text(
                    _avgRating.toStringAsFixed(2),
                    style: GoogleFonts.montserrat(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _StarRow(rating: _avgRating, size: 20),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 13, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(
                        'Based on ${widget.reviews.length} review${widget.reviews.length == 1 ? '' : 's'}',
                        style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 32),
              // Histogram
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((star) {
                    final count = _countForStar(star);
                    final total = widget.reviews.length;
                    final fraction =
                        total > 0 ? count / total : 0.0;
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              star,
                              (_) => const Icon(Icons.star,
                                  size: 10, color: Colors.amber),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Stack(
                                  children: [
                                    Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(
                                                4),
                                      ),
                                    ),
                                    Container(
                                      height: 8,
                                      width: constraints.maxWidth *
                                          fraction,
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.grey.shade700,
                                        borderRadius:
                                            BorderRadius.circular(
                                                4),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 16,
                            child: Text(
                              '$count',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Write a Review button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _btnWriteHover = true),
            onExit: (_) => setState(() => _btnWriteHover = false),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showForm = !_showForm;
                  if (_showForm) {
                    _formAnimController.forward();
                  } else {
                    _formAnimController.reverse();
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: _btnWriteHover ? Colors.black : Colors.grey.shade800,
                ),
                child: Text(
                  _showForm ? 'Cancel Review' : 'Write a Review',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Write a Review form
          SizeTransition(
            sizeFactor: _formSizeAnim,
            axis: Axis.vertical,
            axisAlignment: -1.0,
            child: _buildReviewForm(),
          ),

          if (widget.reviews.isNotEmpty) ...[
            const SizedBox(height: 24),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            ...widget.reviews.map(_buildReviewCard),
          ] else ...[
            const SizedBox(height: 20),
            Text(
              'No reviews yet. Be the first!',
              style: GoogleFonts.montserrat(
                  fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write a review',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          // Rating selector
          Text('Rating',
              style: GoogleFonts.montserrat(
                  fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (i) {
              final filled = i < (_formHoverRating > 0
                  ? _formHoverRating
                  : _formRating);
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) =>
                    setState(() => _formHoverRating = i + 1),
                onExit: (_) => setState(() => _formHoverRating = 0),
                child: GestureDetector(
                  onTap: () => setState(() => _formRating = i + 1),
                  child: Icon(
                    filled ? Icons.star : Icons.star_border,
                    size: 28,
                    color: Colors.amber,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Review title
          _FormLabel('Review Title'),
          const SizedBox(height: 6),
          _FormField(
              controller: _titleCtrl,
              hint: 'Give your review a title'),
          const SizedBox(height: 14),

          // Review content
          _FormLabel('Review content'),
          const SizedBox(height: 6),
          TextField(
            controller: _bodyCtrl,
            maxLines: 5,
            style: GoogleFonts.montserrat(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Write your comments here',
              hintStyle: GoogleFonts.montserrat(
                  fontSize: 13, color: Colors.grey.shade400),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Display name
          _FormLabel('Display Name'),
          const SizedBox(height: 6),
          _FormField(
              controller: _nameCtrl,
              hint: 'Display name'),
          const SizedBox(height: 14),

          // Email
          _FormLabel('Email Address'),
          const SizedBox(height: 6),
          _FormField(
              controller: _emailCtrl,
              hint: 'Your email address'),
          const SizedBox(height: 20),

          // Submit button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _btnSubmitHover = true),
            onExit: (_) => setState(() => _btnSubmitHover = false),
            child: GestureDetector(
              onTap: () {
                // Validate required fields
                if (_formRating == 0) {
                  AppSnackBar.error(context, 'Please select a star rating.');
                  return;
                }
                if (_nameCtrl.text.trim().isEmpty) {
                  AppSnackBar.error(context, 'Please enter your display name.');
                  return;
                }
                if (_bodyCtrl.text.trim().isEmpty) {
                  AppSnackBar.error(context, 'Please write your review.');
                  return;
                }

                // Build review and save via ReviewProvider
                final review = Review(
                  id: 'user_${DateTime.now().millisecondsSinceEpoch}',
                  userName: _nameCtrl.text.trim(),
                  rating: _formRating.toDouble(),
                  comment: _bodyCtrl.text.trim(),
                  date: DateTime.now(),
                );
                context.read<ReviewProvider>().addReview(widget.productId, review);

                // Reset form
                _titleCtrl.clear();
                _bodyCtrl.clear();
                _nameCtrl.clear();
                _emailCtrl.clear();
                _formAnimController.reverse();
                setState(() {
                  _formRating = 0;
                  _showForm = false;
                });

                AppSnackBar.success(context, 'Review submitted — thank you!');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
                color: _btnSubmitHover ? Colors.black : Colors.grey.shade800,
                child: Text(
                  'Submit Review',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars + date
          Row(
            children: [
              _StarRow(rating: review.rating, size: 14),
              const Spacer(),
              Text(
                '${review.date.day.toString().padLeft(2, '0')}/'
                '${review.date.month.toString().padLeft(2, '0')}/'
                '${review.date.year}',
                style: GoogleFonts.montserrat(
                    fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // User info
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.person,
                    size: 18, color: Colors.grey.shade500),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    color: Colors.black,
                    child: Text(
                      'Verified',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Comment
          Text(
            review.comment,
            style: GoogleFonts.montserrat(
                fontSize: 13, color: Colors.black87, height: 1.7),
          ),
          const SizedBox(height: 16),
          Divider(height: 0, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}

// ── Star Row helper ────────────────────────────────────────────────────────

class _StarRow extends StatelessWidget {
  final double rating;
  final double size;
  const _StarRow({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return Icon(Icons.star, size: size, color: Colors.amber);
        } else if (i < rating) {
          return Icon(Icons.star_half, size: size, color: Colors.amber);
        }
        return Icon(Icons.star_border, size: size, color: Colors.amber);
      }),
    );
  }
}

// ── Form helpers ─────────────────────────────────────────────────────────────

class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _FormField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.montserrat(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.montserrat(
            fontSize: 13, color: Colors.grey.shade400),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

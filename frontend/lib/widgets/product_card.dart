import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_ecommerce_app/models/data_models.dart';
import 'package:smart_ecommerce_app/services/app_state.dart';
import 'package:smart_ecommerce_app/utils/app_snackbar.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  String? _selectedSize;
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;


  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.06)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    // Auto-select size if there's only one option available
    if (widget.product.inventory.length == 1) {
      _selectedSize = widget.product.inventory.keys.first;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onEnter(_) {
    setState(() => _isHovering = true);
    _ctrl.forward();
  }

  void _onExit(_) {
    setState(() => _isHovering = false);
    _ctrl.reverse();
  }

  // Returns true if every size in inventory has 0 stock
  bool get _isFullySoldOut =>
      widget.product.inventory.isNotEmpty &&
      widget.product.inventory.values.every((qty) => qty <= 0);

  void _addToCart() {
    final p = widget.product;

    // No validation needed if we already have a size selected
    if (_selectedSize != null) {
       final qty = p.inventory[_selectedSize!] ?? 0;
       if (qty <= 0) {
         AppSnackBar.error(context, 'Size $_selectedSize is out of stock.');
         return;
       }
       final added = context.read<CartProvider>().addToCart(p, _selectedSize!);
       if (added) {
         AppSnackBar.success(context, 'Product added to cart.');
       } else {
         AppSnackBar.error(context, 'Maximum quantity reached for this size.');
       }
       return;
    }
    
    // Products with no inventory map - add freely (fallback)
    if (p.inventory.isEmpty) {
      context.read<CartProvider>().addToCart(p, '');
      AppSnackBar.success(context, 'Product added to cart.');
      return;
    }

    // Fully sold-out product
    if (_isFullySoldOut) {
      AppSnackBar.error(context, '${p.title} is sold out.');
      return;
    }

    if (_selectedSize == null) {
      AppSnackBar.error(context, 'Please select a size first');
      return;
    }

    final added = context.read<CartProvider>().addToCart(p, _selectedSize!);
    if (added) {
      AppSnackBar.success(context, 'Product added to cart.');
    } else {
      AppSnackBar.error(context, 'Maximum quantity reached for this size.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.zero,
            border: Border.all(
              color: _isHovering ? Colors.grey.shade200 : Colors.grey.shade200.withValues(alpha: 0),
              width: 1,
            ),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 28,
                      spreadRadius: 1,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Image with white inset padding
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRect(
                        child: ScaleTransition(
                          scale: _scaleAnim,
                          child: p.images.isNotEmpty
                              ? Image.asset(
                                  p.images.first,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported,
                                          size: 40, color: Colors.grey),
                                    ),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: Icon(Icons.image,
                                        size: 40, color: Colors.grey),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Info panel
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      p.title.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 12, 
                        fontWeight: FontWeight.w600, 
                        letterSpacing: 0.5,
                        color: Colors.grey.shade600, 
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Text(
                      p.price,
                      style: GoogleFonts.montserrat(
                        fontSize: 14, 
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                  // Size bubbles + ADD TO BAG — slide in on hover
                  AnimatedSize(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOut,
                    alignment: Alignment.topCenter,
                    child: (_isHovering || MediaQuery.of(context).size.width < 600)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Only show size selector if there are multiple sizes
                              if (p.inventory.length > 1)
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: p.inventory.entries.map((entry) {
                                    final size = entry.key;
                                    final qty = entry.value;
                                    final isOos = qty <= 0;
                                    return _SizeBubble(
                                      size: size,
                                      isSelected: _selectedSize == size,
                                      isOutOfStock: isOos,
                                      onTap: isOos
                                          ? null
                                          : () => setState(() => _selectedSize = size),
                                    );
                                  }).toList(),
                                ),
                              const SizedBox(height: 8),
                              // ADD TO BAG button
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: _AddToBagButton(
                                  onTap: _isFullySoldOut ? null : _addToCart,
                                  soldOut: _isFullySoldOut,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          )
                        : const SizedBox(width: double.infinity),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class _SizeBubble extends StatefulWidget {
  final String size;
  final bool isSelected;
  final bool isOutOfStock;
  final VoidCallback? onTap;

  const _SizeBubble({
    required this.size,
    required this.isSelected,
    this.isOutOfStock = false,
    required this.onTap,
  });

  @override
  State<_SizeBubble> createState() => _SizeBubbleState();
}

class _SizeBubbleState extends State<_SizeBubble> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final oos = widget.isOutOfStock;
    return MouseRegion(
      cursor: oos ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(right: 6),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: oos
                ? Colors.grey.shade100
                : widget.isSelected
                    ? Colors.grey.shade800
                    : (_isHovered ? Colors.grey.shade100 : Colors.white),
            border: Border.all(
              color: oos
                  ? Colors.grey.shade300
                  : widget.isSelected
                      ? Colors.grey.shade800
                      : (_isHovered ? Colors.black : Colors.grey.shade400),
              width: 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                widget.size,
                style: GoogleFonts.montserrat(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: oos ? Colors.grey.shade400 : (widget.isSelected ? Colors.white : Colors.black),
                ),
              ),
              // Diagonal strikethrough for OOS
              if (oos)
                CustomPaint(
                  size: const Size(24, 24),
                  painter: _StrikethroughPainter(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Draws a diagonal line across the size bubble to indicate out-of-stock
class _StrikethroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(4, size.height - 4), Offset(size.width - 4, 4), paint);
  }

  @override
  bool shouldRepaint(_StrikethroughPainter oldDelegate) => false;
}

class _AddToBagButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool soldOut;
  const _AddToBagButton({this.onTap, this.soldOut = false});

  @override
  State<_AddToBagButton> createState() => _AddToBagButtonState();
}

class _AddToBagButtonState extends State<_AddToBagButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.soldOut || widget.onTap == null;
    return MouseRegion(
      cursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: (_) { if (!isDisabled) setState(() => _hovering = true); },
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: isDisabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey.shade100
                : (_hovering ? Colors.black : Colors.white),
            border: Border.all(
              color: isDisabled ? Colors.grey.shade300 : Colors.black,
              width: 1,
            ),
          ),
          child: Text(
            widget.soldOut ? 'SOLD OUT' : 'ADD TO BAG',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: isDisabled
                  ? Colors.grey.shade400
                  : (_hovering ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

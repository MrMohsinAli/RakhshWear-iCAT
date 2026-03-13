import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_ecommerce_app/services/app_state.dart';
import 'package:smart_ecommerce_app/screens/checkout_screen.dart';
import 'package:smart_ecommerce_app/screens/login_screen.dart';
import 'package:smart_ecommerce_app/screens/signup_screen.dart';
import 'package:smart_ecommerce_app/screens/web_layout.dart';
import 'package:smart_ecommerce_app/screens/product_detail_page.dart';
import 'package:smart_ecommerce_app/widgets/primary_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  /// Shows a bottom sheet prompting the user to log in or create an account.
  void _showLoginPrompt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow it to take more height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.6,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sign in to Checkout',
                          style: GoogleFonts.montserrat(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Please log in or create an account to proceed with your order.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 18), // Reduced gap to move buttons up
                        PrimaryButton(
                          label: 'LOGIN',
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              FadeSlideRoute(
                                builder: (context) =>
                                    const LoginScreen(redirectToCheckout: true),
                              ),
                            );
                          },
                          bgColor: Colors.grey.shade800,
                          hoverBgColor: Colors.black,
                        ),
                        const SizedBox(height: 10),
                        PrimaryButton(
                          label: 'CREATE AN ACCOUNT',
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              FadeSlideRoute(
                                builder: (context) => SignupScreen(),
                              ),
                            );
                          },
                          bgColor: Colors.white,
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY SHOPPING BAG',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 100, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'Your bag is empty',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'CONTINUE SHOPPING',
                      onPressed: () => Navigator.pop(context),
                      width: 260,
                      height: 50,
                      bgColor: Colors.white,
                      textColor: const Color(0xFF37474F),  
                      borderColor: const Color(0xFF37474F), 
                      hoverBgColor: const Color(0xFF37474F), 
                      hoverTextColor: Colors.white,      
                      borderRadius: 30,
                    ),
                  ],
                ),
              ),
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cart Items List
              Expanded(
                flex: 2,
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image — tappable
                        _HoverableCartImage(
                          imagePath: item.product.images.first,
                          onTap: () => Navigator.push(
                            context,
                            FadeSlideRoute(
                              builder: (context) => WebLayout(
                                body: ProductDetailPage(productId: item.product.id),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title — tappable
                              _HoverableCartTitle(
                                title: item.product.title,
                                onTap: () => Navigator.push(
                                  context,
                                  FadeSlideRoute(
                                    builder: (context) => WebLayout(
                                      body: ProductDetailPage(productId: item.product.id),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('${item.product.price}${item.selectedSize.isNotEmpty ? ' | Size: ${item.selectedSize}' : ''}'),
                              const SizedBox(height: 12),
                              // Quantity Controls
                              Row(
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    onPressed: () => cart.decrementQuantity(
                                        item.product.id, item.selectedSize),
                                  ),
                                  Text('${item.quantity}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Builder(builder: (ctx) {
                                    final stock = item.product.inventory.isEmpty
                                        ? null
                                        : (item.product.inventory[item.selectedSize] ?? 0);
                                    final atMax = stock != null && item.quantity >= stock;
                                    return IconButton(
                                      icon: Icon(Icons.add_circle_outline,
                                          color: atMax ? Colors.grey.shade300 : null),
                                      onPressed: atMax
                                          ? null
                                          : () => cart.addToCart(item.product, item.selectedSize),
                                    );
                                  }),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    onPressed: () => cart.removeFromCart(
                                        item.product.id, item.selectedSize),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'PKR ${(item.totalPrice).toStringAsFixed(0)}',
                          style:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Order Summary
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORDER SUMMARY',
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.titleLarge,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: GoogleFonts.montserrat(color: Colors.grey.shade700, fontSize: 15)),
                          RichText(
                            text: TextSpan(
                              text: 'PKR ',
                              style: GoogleFonts.montserrat(color: Colors.grey.shade700, fontSize: 11),
                              children: [
                                TextSpan(
                                  text: cart.totalAmount.toStringAsFixed(0),
                                  style: GoogleFonts.montserrat(color: Colors.grey.shade700, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shipping', style: GoogleFonts.montserrat(color: Colors.grey.shade700, fontSize: 15)),
                          Text('Calculated at checkout', style: GoogleFonts.montserrat(color: Colors.grey.shade700, fontSize: 15)),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 16)),
                          RichText(
                            text: TextSpan(
                              text: 'PKR ',
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.grey.shade700),
                              children: [
                                TextSpan(
                                  text: cart.totalAmount.toStringAsFixed(0),
                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        label: 'PROCEED TO CHECKOUT',
                        onPressed: () {
                          final auth = context.read<AuthProvider>();
                          if (auth.isLoggedIn) {
                            Navigator.push(
                              context,
                              FadeSlideRoute(
                                builder: (context) =>
                                    const CheckoutScreen(),
                              ),
                            );
                          } else {
                            _showLoginPrompt(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HoverableCartImage extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const _HoverableCartImage({required this.imagePath, required this.onTap});

  @override
  State<_HoverableCartImage> createState() => _HoverableCartImageState();
}

class _HoverableCartImageState extends State<_HoverableCartImage> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.zero,
            boxShadow: _isHovering 
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 18,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    )
                  ] 
                : [],
          ),
        ),
      ),
    );
  }
}

class _HoverableCartTitle extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _HoverableCartTitle({required this.title, required this.onTap});

  @override
  State<_HoverableCartTitle> createState() => _HoverableCartTitleState();
}

class _HoverableCartTitleState extends State<_HoverableCartTitle> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            decoration: _isHovering ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

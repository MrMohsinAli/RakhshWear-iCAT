import 'package:smart_ecommerce_app/utils/page_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_ecommerce_app/services/app_state.dart';
import 'package:smart_ecommerce_app/screens/product_listing_page.dart';
import 'package:smart_ecommerce_app/screens/web_layout.dart';
import 'package:smart_ecommerce_app/screens/login_screen.dart';
import 'package:smart_ecommerce_app/services/mock_data_service.dart';
import 'package:smart_ecommerce_app/models/data_models.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_ecommerce_app/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      width: 400,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo covering full top area
            SizedBox(
              width: double.infinity,
              height: 160,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/logo2.png',
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          'RAKHSHWEAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 4,
                    child: SelectionContainer.disabled(
                      child: IconButton(
                        mouseCursor: SystemMouseCursors.click,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 28, color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: _buildMenuItems(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    int index = 0;
    Widget staggered(Widget child) => _StaggeredItem(index: index++, child: child);

    return [
      staggered(
        _MenuItem(
          text: 'NEW ARRIVAL',
          isBold: true,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              FadeSlideRoute(
                builder: (context) => const WebLayout(
                  body: ProductListingPage(
                    subcategories: ['Polos', 'Jeans', 'Unstitched Fabric', 'Kurta Trouser', 'Caps', 'Sneakers'],
                    collectionTitle: 'New Arrival',
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 4),
      staggered(
        _MenuItem(
          text: 'WINTER COLLECTION',
          isBold: true,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              FadeSlideRoute(
                builder: (context) => const WebLayout(
                  body: ProductListingPage(
                    subcategories: ['Jackets', 'Sweaters', 'Hoodies', 'Shawls', 'Jeans', 'Mufflers'],
                    collectionTitle: 'Winter Collection',
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 12),

      ...MockDataService.categories.map((category) {
        return staggered(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ExpandableCategory(category: category),
          ),
        );
      }),

      const SizedBox(height: 12),
      staggered(const Divider()),
      const SizedBox(height: 20),

      staggered(
        Text(
          'GET IN TOUCH',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      const SizedBox(height: 16),
      staggered(const _ContactItem(icon: Icons.phone, text: '042111364463')),
      const SizedBox(height: 8),
      staggered(const _ContactItem(icon: Icons.email, text: 'rakhshwear@hotmail.com')),
      const SizedBox(height: 8),
      staggered(const _ContactItem(icon: Icons.access_time, text: 'Mon-Fri 9:30 to 5:30')),
      const SizedBox(height: 16),
      staggered(const _HoverLoginButton()),
      const SizedBox(height: 30),
      staggered(
        Text(
          'FOLLOW US',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      const SizedBox(height: 16),
      staggered(
        Row(
          children: const [
            _SocialIcon(icon: FontAwesomeIcons.facebookF, color: Color(0xFF1877F2), url: 'https://www.facebook.com'),
            SizedBox(width: 16),
            _SocialIcon(icon: FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), url: 'https://www.whatsapp.com'),
            SizedBox(width: 16),
            _SocialIcon(icon: FontAwesomeIcons.instagram, color: Color(0xFFE4405F), url: 'https://www.instagram.com'),
            SizedBox(width: 16),
            _SocialIcon(icon: FontAwesomeIcons.snapchat, color: Color(0xFFFFFC00), url: 'https://www.snapchat.com'),
            SizedBox(width: 16),
            _SocialIcon(icon: FontAwesomeIcons.youtube, color: Color(0xFFFF0000), url: 'https://www.youtube.com'),
          ],
        ),
      ),
      const SizedBox(height: 20),
    ];
  }
}

class _StaggeredItem extends StatefulWidget {
  final Widget child;
  final int index;

  const _StaggeredItem({required this.child, required this.index});

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _slide = Tween<Offset>(begin: const Offset(-0.35, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    Future.delayed(Duration(milliseconds: 40 * widget.index), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

// Contact item widget for menu drawer
class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

// Social icon widget for menu drawer
class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String url;

  const _SocialIcon({required this.icon, required this.color, required this.url});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: () async {
            final uri = Uri.parse(widget.url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          child: AnimatedScale(
            scale: _isHovering ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _isHovering ? widget.color : widget.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: 18,
                color: _isHovering ? Colors.white : widget.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverLoginButton extends StatefulWidget {
  const _HoverLoginButton();

  @override
  State<_HoverLoginButton> createState() => _HoverLoginButtonState();
}

class _HoverLoginButtonState extends State<_HoverLoginButton> {

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoggedIn) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: 'Hello, ',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: '${auth.userName}.',
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                color: const Color(0xFF37474F), // Dark blue-grey
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  auth.logout();
                  Navigator.pop(context); // close drawer on logout
                },
                icon: const Icon(Icons.power_settings_new, size: 20),
                color: Colors.red.shade700,
                tooltip: 'Logout',
                splashRadius: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          );
        }

        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 200,
            child: PrimaryButton(
              label: 'LOGIN / SIGNUP',
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  FadeSlideRoute(builder: (context) => const LoginScreen()),
                );
              },
              bgColor: Colors.grey.shade800,
              hoverBgColor: Colors.black,
              borderRadius: 8,
            ),
          ),
        );
      },
    );
  }
}

// Expandable category widget
class _ExpandableCategory extends StatefulWidget {
  final Category category;

  const _ExpandableCategory({required this.category});

  @override
  State<_ExpandableCategory> createState() => _ExpandableCategoryState();
}

class _ExpandableCategoryState extends State<_ExpandableCategory> {
  bool _isExpanded = false;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        SelectionContainer.disabled(
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6), // Reduced from 10
                child: Row(
                  children: [
                    Text(
                      widget.category.title.toUpperCase(),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: _isHovering ? FontWeight.w800 : FontWeight.w700,
                        letterSpacing: 1.2,
                        color: _isHovering ? Colors.black : Colors.grey.shade700,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Subcategories (shown when clicked)
        if (_isExpanded)
          Container(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.category.subcategories.map((sub) {
                return _SubcategoryItem(
                  text: sub,
                  categoryId: widget.category.id,
                  subcategory: sub,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

// Subcategory item widget
class _SubcategoryItem extends StatefulWidget {
  final String text;
  final String categoryId;
  final String subcategory;

  const _SubcategoryItem({
    required this.text,
    required this.categoryId,
    required this.subcategory,
  });

  @override
  State<_SubcategoryItem> createState() => _SubcategoryItemState();
}

class _SubcategoryItemState extends State<_SubcategoryItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              FadeSlideRoute(
                builder: (context) => WebLayout(
                  body: ProductListingPage(
                    categoryId: widget.categoryId,
                    subcategory: widget.subcategory,
                  ),
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.transparent,
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: _isHovering ? Colors.black : Colors.grey.shade700,
                      fontWeight: _isHovering ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.only(top: 4),
                    height: 1.5,
                    width: _isHovering ? 28.0 : 0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Simple menu item (for NEW IN and WINTER COLLECTION)
class _MenuItem extends StatefulWidget {
  final String text;
  final bool isBold;
  final VoidCallback onTap;

  const _MenuItem({
    required this.text,
    this.isBold = false,
    required this.onTap,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: InkWell(
          onTap: widget.onTap,
          hoverColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 10).copyWith(
              left: _isHovering ? 12 : 0,
            ),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.montserrat(
                fontSize: widget.isBold ? 22 : 16,
                fontWeight: widget.isBold ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 1.2,
                color: _isHovering ? Colors.black : Colors.grey.shade700,
              ),
              child: Text(widget.text.toUpperCase()),
            ),
          ),
        ),
      ),
    );
  }
}
